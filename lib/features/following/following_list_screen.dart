import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/data_controller.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/following_user_card.dart';

import '../../features/profile/profile_screen.dart'; 

class FollowingListScreen extends StatefulWidget {
  const FollowingListScreen({super.key});

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  final db = DataController();
  final currentUser = FirebaseAuth.instance.currentUser;

  void _handleUnfollow(String targetUserId, String targetUserName) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Takipten Çık"),
        content: Text("$targetUserName adlı satıcıyı takipten çıkmak istiyor musunuz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("İptal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Evet, Çıkar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
          'following': FieldValue.arrayRemove([targetUserId])
        });
      }

      setState(() {
        db.followingIds.remove(targetUserId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$targetUserName takipten çıkarıldı."),
            backgroundColor: AppTheme.navyDark,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> followingIds = db.followingIds;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "Takip Edilenler",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: followingIds.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 15),
                  Text("Kimseyi takip etmiyorsun.",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: followingIds.length,
              itemBuilder: (context, index) {
                final targetUserId = followingIds[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(targetUserId).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                      );
                    }

                    var userData = snapshot.data!.data() as Map<String, dynamic>?;
                    if (userData == null) return const SizedBox();

                    String name = userData['storeName'] ?? userData['name'] ?? "Bilinmeyen Kullanıcı";

                    return FollowingUserCard(
                      userName: name,
                      userId: targetUserId, 
                      onUnfollow: () => _handleUnfollow(targetUserId, name),
                      
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              targetUserId: targetUserId, 
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}