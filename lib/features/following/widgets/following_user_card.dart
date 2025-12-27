import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class FollowingUserCard extends StatelessWidget {
  final String userName;
  final String userId;
  final VoidCallback onUnfollow;
  final VoidCallback onTap;

  const FollowingUserCard({
    super.key,
    required this.userName,
    required this.userId,
    required this.onUnfollow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material( // InkWell'in arka plan rengini bozmaması için eklendi
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, // Karta basınca profile gider
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // Arka plan rengini burada veriyoruz
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                // --- AVATAR ---
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Text(
                      userName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.navyDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                
                // --- KULLANICI ADI ---
                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.navyDark,
                    ),
                  ),
                ),

                // --- ÇIKAR BUTONU ---
                // GestureDetector kullanarak butonun tıklamasını karttan ayırıyoruz
                GestureDetector(
                  onTap: () {}, // InkWell'in bu bölgede çalışmasını durdurmak için boş bırakıyoruz
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: onUnfollow, // Sadece takipten çıkarır
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Çıkar",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}