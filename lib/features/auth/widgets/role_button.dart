import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RoleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const RoleButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentGold : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : AppTheme.accentGold,
            ),
          ),
        ),
      ),
    );
  }
}
