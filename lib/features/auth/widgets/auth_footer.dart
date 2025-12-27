import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AuthFooter extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const AuthFooter({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLogin ? "Hesabın yok mu?" : "Zaten hesabın var mı?",
            style: const TextStyle(color: AppTheme.navyLight),
          ),
          TextButton(
            onPressed: onToggle,
            child: Text(
              isLogin ? "Kayıt Ol" : "Giriş Yap",
              style: const TextStyle(
                color: AppTheme.accentGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
