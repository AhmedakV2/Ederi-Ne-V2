import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart'; 

class PriceHeader extends StatelessWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;

  const PriceHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        "Ederi Ne?",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                        gradient: AppTheme.accentGradient,
                      ),
                      Text("Piyasanın nabzını tut",
                          style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/Login.png',
                    height: 30,
                  ),
                ],
              ),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const GradientIcon(Icons.tune, gradient: AppTheme.accentGradient),
                  onPressed: onFilterTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          
          TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: AppTheme.textWhite),
            decoration: InputDecoration(
              hintText: 'Ürün, market veya kategori ara...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const GradientIcon(Icons.search, gradient: AppTheme.accentGradient),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.black.withOpacity(0.15),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}