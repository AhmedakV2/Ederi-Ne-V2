import 'package:flutter/material.dart';

class AppTheme {
  
  static const Color background = Colors.white;            
  
 
  static const Color navyDark = Color(0xFF0D2342);         
  static const Color navyLight = Color(0xFF1E88E5);        
  
  
  static const Color accentGold = Color(0xFFFFC636);       
  static const Color accentGoldDark = Color(0xFFC7A008);   
  
 
  static const Color navyBlue = navyDark;                  
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFFB0B3B8);

 
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


class GradientBorder extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final BorderRadius borderRadius;
  final Color innerColor; 

  const GradientBorder({
    required this.child,
    required this.gradient,
    this.width = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.innerColor = Colors.white, 
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
          color: innerColor, 
          borderRadius: borderRadius.subtract(BorderRadius.all(Radius.circular(width))),
        ),
        child: child,
      ),
    );
  }
}