import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
// import '../price_list_screen.dart'; // Buna artık gerek yok
import '../../navigation/main_navigation.dart'; // ✅ MainNavigation'ı import etmelisin (Dosya yolunu kendi projene göre ayarla)

class AddPriceHeader extends StatelessWidget {
  const AddPriceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),

        // Arka plan ikonları (Süsleme)
        Positioned(
          right: -30,
          top: -20,
          child: Icon(
            Icons.shopping_cart,
            size: 150,
            color: Colors.white.withOpacity(0.05),
          ),
        ),

        // Başlık İçeriği
        Positioned(
          top: 60,
          left: 20,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fiyat Ekle",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Yeni bir ürün paylaş",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ✅ DÜZELTİLEN KISIM: Çarpı Butonu
        Positioned(
          top: 50,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) {
                // Eğer geriye gidilebiliyorsa normal şekilde git
                Navigator.pop(context);
              } else {
                // Eğer geriye gidilemiyorsa (örn: bildirimden geldiysen)
                // PriceListScreen yerine ANA İSKELET OLAN MainNavigation'a git.
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  MainNavigation(), // ✅ Burası değişti
                  ),
                  (route) => false, // Geri tuşu geçmişini temizle
                );
              }
            },
          ),
        ),
      ],
    );
  }
}