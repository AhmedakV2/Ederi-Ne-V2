import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

import '../../navigation/main_navigation.dart'; 

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

        
        Positioned(
          right: -30,
          top: -20,
          child: Icon(
            Icons.shopping_cart,
            size: 150,
            color: Colors.white.withOpacity(0.05),
          ),
        ),

        
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

        
        Positioned(
          top: 50,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              if (Navigator.canPop(context)) {
                
                Navigator.pop(context);
              } else {
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  MainNavigation(), 
                  ),
                  (route) => false, 
                );
              }
            },
          ),
        ),
      ],
    );
  }
}