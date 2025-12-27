import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'header_clipper.dart'; 

class AuthHeader extends StatelessWidget {
  final bool isLogin;
  const AuthHeader({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 380,
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              height: 160,
              width: 160,
              child: Image.asset('assets/images/Login.png'),
            ),
            const SizedBox(height: 5),
            GradientText(
              isLogin ? "Tekrar Hoşgeldin!" : "Aramıza Katıl",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              gradient: AppTheme.accentGradient,
            ),
            const SizedBox(height: 5),
            Text(
              isLogin
                  ? "Hesabına giriş yap ve keşfetmeye başla"
                  : "Hemen ücretsiz bir hesap oluştur",
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ],
    );
  }
}
