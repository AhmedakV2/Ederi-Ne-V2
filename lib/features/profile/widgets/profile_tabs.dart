import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/data_controller.dart'; // DataController eklendi
import 'rating_chart_painter.dart';

// --- TAB 1: HAKKINDA ---
class ProfileAboutTab extends StatelessWidget {
  final String bio;
  final bool isMyProfile;
  final bool isTargetSeller;
  final bool amIFollowing;
  final VoidCallback? onFollowToggle; 
  final List<dynamic> displayProducts;
  final List<double> ratingHistory;

  const ProfileAboutTab({
    super.key,
    required this.bio,
    required this.isMyProfile,
    required this.isTargetSeller,
    required this.amIFollowing,
    this.onFollowToggle,
    required this.displayProducts,
    required this.ratingHistory,
  });

  @override
  Widget build(BuildContext context) {
    final db = DataController(); // DataController örneği

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bio Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                if (!isMyProfile && isTargetSeller)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: (onFollowToggle == null) 
                            ? null 
                            : (amIFollowing ? null : AppTheme.accentGradient),
                        color: (onFollowToggle == null)
                            ? Colors.grey.shade300
                            : (amIFollowing ? Colors.green : null),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: onFollowToggle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: (onFollowToggle == null) ? Colors.grey : Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Text(
                            (onFollowToggle == null) 
                                ? "Takip Kapalı" 
                                : (amIFollowing ? "Takip Ediliyor" : "Takip Et"),
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15, color: AppTheme.navyDark, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          const Text("Son Gönderiler",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navyDark)),
          const SizedBox(height: 15),

          // 2. Yatay Liste (Son Gönderiler)
          SizedBox(
            height: 170,
            child: displayProducts.isEmpty
                ? Center(
                    child: Text("Henüz gönderi yok.",
                        style: TextStyle(color: Colors.grey[400])))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final item = displayProducts[index];
                      final double price = (item['price'] is int)
                          ? (item['price'] as int).toDouble()
                          : (item['price'] as double? ?? 0.0);

                      return GestureDetector(
                        // YENİ: Yatay listedeki ürüne tıklayınca ana sayfaya yönlendir
                        onTap: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            db.scrollToProduct(item['id'], db.allProductsList);
                          });
                        },
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(
                              right: 15, bottom: 10, top: 5),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                              border: Border.all(
                                  color: AppTheme.accentGold.withOpacity(0.3))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag_outlined,
                                  color: AppTheme.accentGold, size: 40),
                              const Spacer(),
                              Text(item['name'] ?? "Ürün",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.navyDark)),
                              const SizedBox(height: 5),
                              Text("₺${price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900, 
                                      fontSize: 15,
                                      color: AppTheme.navyDark)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 20),
          const Text("Puan Analizi",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navyDark)),
          const SizedBox(height: 15),

          // 3. Grafik Kartı
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ratingHistory.isEmpty || ratingHistory.every((r) => r == 0)
                ? Center(
                    child: Text(
                      'Analiz için veri yok',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  )
                : CustomPaint(
                    painter: ChartPainter(
                      ratings: ratingHistory,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- TAB 2: ÜRÜN LİSTESİ ---
class ProfilePostsTab extends StatelessWidget {
  final List<dynamic> displayProducts;
  final bool isMyProfile;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const ProfilePostsTab({
    super.key,
    required this.displayProducts,
    required this.isMyProfile,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final db = DataController(); // DataController örneği

    if (displayProducts.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("Henüz paylaşım yok", style: TextStyle(color: Colors.grey)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: displayProducts.length,
      itemBuilder: (context, i) {
        final item = displayProducts[i];
        final double price = (item['price'] is int)
            ? (item['price'] as int).toDouble()
            : (item['price'] as double? ?? 0.0);

        return GestureDetector(
          // YENİ: Paylaşımlar listesindeki ürüne tıklayınca ana sayfaya yönlendir
          onTap: () {
            // Önce profili kapatıp ana navigasyona dön
            Navigator.of(context).popUntil((route) => route.isFirst);
            
            // Kısa bir bekleme sonrası kaydırma işlemini başlat
            Future.delayed(const Duration(milliseconds: 300), () {
              db.scrollToProduct(item['id'], db.allProductsList);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppTheme.navyDark.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.shopping_basket_outlined,
                      color: AppTheme.accentGold, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] ?? "Ürün",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.navyDark)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.storefront,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(item['market'] ?? "",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₺${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, 
                            fontSize: 18,
                            color: AppTheme.navyDark)),
                    if (isMyProfile)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                // Düzenleme tıklandığında kaydırmayı engellemek için stopPropagation gibi davranır
                                onTap: () => onEdit(item),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.edit,
                                        size: 18, color: Colors.blueGrey)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onDelete(item),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.delete_outline,
                                        size: 18, color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}