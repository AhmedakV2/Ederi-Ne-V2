import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle; 
import 'package:googleapis_auth/auth_io.dart' as auth; 
import 'dart:convert';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/data_controller.dart';

class ProductCommentsSheet extends StatefulWidget {
  final String productId;
  final String productName;
  final String productOwnerId;

  const ProductCommentsSheet({
    super.key,
    required this.productId,
    required this.productName,
    required this.productOwnerId,
  });

  @override
  State<ProductCommentsSheet> createState() => _ProductCommentsSheetState();
}

class _ProductCommentsSheetState extends State<ProductCommentsSheet> {
  final _commentController = TextEditingController();
  final DataController db = DataController();
  final user = FirebaseAuth.instance.currentUser;
  String? _replyingToUserId;

  
  Future<void> _sendPushNotificationV1(String toUserToken, String title, String body) async {
    try {
      final String response = await rootBundle.loadString('assets/service-account.json');
      final data = json.decode(response);

      final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(data),
        _scopes,
      );

      final String projectID = data['project_id'];
      final String postUrl = 'https://fcm.googleapis.com/v1/projects/$projectID/messages:send';

      
      final Map<String, dynamic> message = {
        'message': {
          'token': toUserToken,
          'notification': {'title': title, 'body': body},
          'android': {
            'priority': 'high', 
            'notification': {
              'channel_id': 'high_importance_channel', 
              'priority': 'high',
              'sound': 'default',
            }
          },
          'apns': {
            'payload': {
              'aps': {
                'alert': {'title': title, 'body': body},
                'sound': 'default', 
                'badge': 1,
              }
            }
          },
          'data': {
            'productId': widget.productId,
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
        }
      };

      await client.post(Uri.parse(postUrl), body: json.encode(message));
      client.close();
      debugPrint("Kayan Push Bildirim fırlatıldı!");
    } catch (e) {
      debugPrint("V1 Bildirim Hatası: $e");
    }
  }

  void _processNotification(String text, bool isOwner) async {
    String? targetUserId;
    String notificationMessage = "";

    if (_replyingToUserId != null) {
      targetUserId = _replyingToUserId;
      notificationMessage = "${db.userName} yorumuna cevap verdi: $text";
    } else if (!isOwner) {
      targetUserId = widget.productOwnerId;
      notificationMessage = "${db.userName} ürününüze yorum yaptı: $text";
    }

    if (targetUserId != null) {
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add({
        'title': "Yeni Etkileşim",
        'body': notificationMessage,
        'productId': widget.productId,
        'fromUserName': db.userName,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

    
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(targetUserId).get();
      if (userDoc.exists) {
        String? token = userDoc.data()?['fcmToken'];
        if (token != null && token.isNotEmpty) {
          _sendPushNotificationV1(token, "Ederi Ne?", notificationMessage);
        }
      }
    }
  }

  void _sendComment() async {
    String text = _commentController.text.trim();
    if (text.isEmpty) return;

    bool isOwner = user?.uid == widget.productOwnerId;
    if (db.userRole == "Satıcı" && !isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Satıcılar sadece kendi ürünlerine cevap verebilir.")));
      return;
    }

    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .collection('comments')
        .add({
      'text': text,
      'userId': user?.uid,
      'userName': db.userName,
      'userAvatar': db.userAvatar,
      'isOwner': isOwner,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _processNotification(text, isOwner);
    _commentController.clear();
    setState(() => _replyingToUserId = null);
    FocusScope.of(context).unfocus();
  }

  void _onReplyTap(String userName, String userId) {
    setState(() {
      _replyingToUserId = userId;
      _commentController.text = "@$userName ";
    });
    _commentController.selection = TextSelection.fromPosition(TextPosition(offset: _commentController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: bottomPadding + 16),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 15),
          Text("${widget.productName} Yorumları", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.navyDark)),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.productId)
                  .collection('comments')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Center(child: Text("Henüz yorum yok.", style: TextStyle(color: Colors.grey)));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var comment = docs[index].data() as Map<String, dynamic>;
                    bool isCommentOwner = comment['isOwner'] ?? false;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCommentOwner ? AppTheme.accentGold.withOpacity(0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isCommentOwner ? Border.all(color: AppTheme.accentGold.withOpacity(0.3)) : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(radius: 18, backgroundImage: AssetImage(comment['userAvatar'] ?? "assets/images/avatar_1.png")),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(comment['userName'] ?? "Kullanıcı", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    if (isCommentOwner) ...[
                                      const SizedBox(width: 5),
                                      const Icon(Icons.verified, size: 14, color: AppTheme.accentGold),
                                      const Text(" (Sahip)", style: TextStyle(fontSize: 10, color: AppTheme.accentGold, fontWeight: FontWeight.bold))
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(comment['text'] ?? "", style: const TextStyle(color: AppTheme.navyDark, fontSize: 14)),
                              ],
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.reply, size: 18, color: Colors.grey), onPressed: () => _onReplyTap(comment['userName'], comment['userId'])),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Yorum yaz...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(backgroundColor: AppTheme.accentGold, child: IconButton(icon: const Icon(Icons.send, color: AppTheme.navyDark, size: 20), onPressed: _sendComment)),
            ],
          )
        ],
      ),
    );
  }
}