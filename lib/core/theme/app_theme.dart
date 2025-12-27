import 'package:flutter/material.dart';

class AppTheme {
  // --- RENKLER ---
  static const Color background = Colors.white;            
  
  // Lacivert Geçiş
  static const Color navyDark = Color(0xFF0D2342);         
  static const Color navyLight = Color(0xFF1E88E5);        
  
  // Sarı Geçiş
  static const Color accentGold = Color(0xFFFFC636);       
  static const Color accentGoldDark = Color(0xFFC7A008);   
  
  // Sabit Renkler
  static const Color navyBlue = navyDark;                  
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB0B3B8);

  // --- GRADIENTLER ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [navyDark, navyLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, accentGoldDark],
  );
}

// --- YARDIMCI WIDGETLAR ---

// 1. Gradient Metin
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(this.text, {required this.style, required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), 
      ),
    );
  }
}

// 2. Gradient İkon
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(this.icon, {this.size = 24.0, required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Icon(
        icon,
        size: size,
        color: Colors.white, 
      ),
    );
  }
}

// 3. Gradient Kenarlık (Hatalar Giderildi)
class GradientBorder extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final BorderRadius borderRadius;
  final Color innerColor; // Yeni: İç rengi özelleştirilebilir yaptık

  const GradientBorder({
    required this.child,
    required this.gradient,
    this.width = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.innerColor = Colors.white, // Varsayılan beyaz (Kartlar için)
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.all(width),
        decoration: BoxDecoration(
          color: innerColor, // Sabit navyBlue yerine esnek renk
          borderRadius: borderRadius.subtract(BorderRadius.all(Radius.circular(width))),
        ),
        child: child,
      ),
    );
  }
}