import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../../../core/theme/app_theme.dart';
import '../../../../data/data_controller.dart'; 
import 'product_comments_sheet.dart';
import '../../profile/profile_screen.dart';

class PriceItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final DataController db = DataController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  PriceItemCard({super.key, required this.item});

  
  void _rateProduct(BuildContext context, int rating) async {
    String? productId = item['id'];
    if (productId == null) return;

    if (db.userRole == "Satıcı") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Satıcılar oy kullanamaz!")));
        return;
    }

    await FirebaseFirestore.instance.collection('products').doc(productId).update({
      'rating': rating.toDouble(),
    });
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Puan verildi: $rating ⭐")));
  }

  
  void _votePrice(BuildContext context, bool isTrue) async {
    String? productId = item['id'];
    if (productId == null || currentUserId.isEmpty) return;

    List<dynamic> confirmedUsers = item['confirmedUserIds'] ?? [];
    List<dynamic> reportedUsers = item['reportedUserIds'] ?? [];

    bool hasConfirmed = confirmedUsers.contains(currentUserId);
    bool hasReported = reportedUsers.contains(currentUserId);

    if (hasConfirmed || hasReported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu ürün için zaten oy kullandınız!"), backgroundColor: Colors.orange)
      );
      return;
    }
    
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference docRef = FirebaseFirestore.instance.collection('products').doc(productId);

    if (isTrue) {
      batch.update(docRef, {
        'confirmationCount': FieldValue.increment(1),
        'confirmedUserIds': FieldValue.arrayUnion([currentUserId])
      });
    } else {
      batch.update(docRef, {
        'reportCount': FieldValue.increment(1),
        'reportedUserIds': FieldValue.arrayUnion([currentUserId])
      });
    }

    await batch.commit();
  }

  
  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductCommentsSheet(
        productId: item['id'], 
        productName: item['name'] ?? "Ürün",
        productOwnerId: item['ownerId'] ?? "", 
      ),
    );
  }

  
  void _goToProfile(BuildContext context) {
    String? ownerId = item['ownerId'];
    if (ownerId != null && ownerId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(targetUserId: ownerId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double currentRating = (item['rating'] as num?)?.toDouble() ?? 0.0;
    int confirmCount = item['confirmationCount'] ?? 0;
    int reportCount = item['reportCount'] ?? 0;
    bool isSuspicious = reportCount >= 5;

    List<dynamic> confirmedUsers = item['confirmedUserIds'] ?? [];
    List<dynamic> reportedUsers = item['reportedUserIds'] ?? [];
    bool iConfirmed = confirmedUsers.contains(currentUserId);
    bool iReported = reportedUsers.contains(currentUserId);

    
    String locationInfo = "${item['city'] ?? 'Bilinmeyen İl'} / ${item['district'] ?? item['neighborhood'] ?? 'Bilinmeyen İlçe'}";

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.navyDark.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.shopping_basket_outlined, color: AppTheme.accentGold, size: 30),
                ),
                const SizedBox(width: 16),
                
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        children: [
                          Flexible(
                            child: Text(item['name'] ?? "Ürün", 
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isSuspicious)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                              child: const Text("ŞÜPHELİ", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            )
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.accentGold),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              locationInfo,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      
                      Row(
                        children: [
                          const Icon(Icons.storefront, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item['market'] ?? "", 
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                     
                      InkWell(
                        onTap: () => _goToProfile(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.person_outline, size: 12, color: AppTheme.accentGold.withValues(alpha: 0.8)),
                            const SizedBox(width: 4),
                            Text(
                              "Paylaşan: ${item['addedBy'] ?? 'Anonim'}", 
                              style: TextStyle(
                                color: AppTheme.accentGold.withValues(alpha: 0.9), 
                                fontSize: 11, 
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppTheme.accentGold.withValues(alpha: 0.5)
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₺${(item['price'] ?? 0).toString()}", 
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white)
                    ),
                    const SizedBox(height: 5),
                    
                   
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => _rateProduct(context, index + 1),
                          child: Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: index < currentRating ? Colors.amber : Colors.white30,
                          ),
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 15),
            Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 10),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                InkWell(
                  onTap: () => _openComments(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white70),
                        SizedBox(width: 5),
                        Text("Yorumlar", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),

                
                Row(
                  children: [
                    InkWell(
                      onTap: () => _votePrice(context, true),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up, 
                            size: 18, 
                            color: iConfirmed ? Colors.greenAccent : Colors.white38),
                          const SizedBox(width: 4),
                          Text("$confirmCount", 
                            style: TextStyle(color: iConfirmed ? Colors.greenAccent : Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () => _votePrice(context, false),
                      child: Row(
                        children: [
                          Icon(Icons.thumb_down, 
                            size: 18, 
                            color: iReported ? Colors.redAccent : Colors.white38),
                          if (reportCount > 0) ...[
                             const SizedBox(width: 4),
                             Text("$reportCount", style: TextStyle(color: iReported ? Colors.redAccent : Colors.white70, fontSize: 12)),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}