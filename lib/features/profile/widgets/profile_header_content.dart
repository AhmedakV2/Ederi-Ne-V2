import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileHeaderContent extends StatelessWidget {
  final String displayName; 
  final String avatarPath;
  final bool isTargetSeller;
  final bool isMyProfile;
  final int followerCount;
  final int followingCount;
  final int productCount;
  final double rating;
  final VoidCallback? onFollowersTap;

  const ProfileHeaderContent({
    super.key,
    required this.displayName,
    required this.avatarPath,
    required this.isTargetSeller,
    required this.isMyProfile,
    required this.followerCount,
    required this.followingCount,
    required this.productCount,
    required this.rating,
    this.onFollowersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50), 
          
          
          Container(
            padding: const EdgeInsets.all(4), 
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(avatarPath),
            ),
          ),
          const SizedBox(height: 10),
          
          
          Text(
            displayName,
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 25),

         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Expanded(
                  child: _buildStatCard(
                    icon: isTargetSeller ? Icons.group : Icons.person_add,
                    
                    value: isTargetSeller
                        ? followerCount.toString()
                        : (isMyProfile ? followingCount.toString() : "0"),
                    label: isTargetSeller ? "TAKİPÇİ" : "TAKİP EDİLEN",
                    
                    onTap: (!isTargetSeller && isMyProfile)
                        ? onFollowersTap
                        : null,
                  ),
                ),
                const SizedBox(width: 10), 
                
                
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.shopping_basket,
                    value: productCount.toString(),
                    label: "ÜRÜNLER",
                  ),
                ),
                const SizedBox(width: 10), 
                
                
                Expanded( 
                  child: _buildStatCard(
                    icon: Icons.star_rounded,
                    value: rating.toString(),
                    label: "PUAN",
                    isRating: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    VoidCallback? onTap,
    bool isRating = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            GradientIcon(
              icon,
              gradient: isRating
                  ? AppTheme.accentGradient
                  : AppTheme.primaryGradient,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.navyDark),
              overflow: TextOverflow.ellipsis, 
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10, 
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
    this.icon, {
    super.key,
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}