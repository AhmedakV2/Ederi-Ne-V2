import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChartPainter extends CustomPainter {
  final List<double> ratings;

  ChartPainter({
    required this.ratings,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (ratings.isEmpty) return;

    // --- KALEM AYARLARI ---
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.accentGold.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = AppTheme.accentGold
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint dotPaint = Paint()..color = AppTheme.navyDark;

    // --- HESAPLAMALAR ---
    final Path path = Path();
    
    // Y ekseni hesaplayıcı (0 puan en altta, 5 puan en üstte)
    double getY(double rating) {
      // 5.0 maksimum puan. Orantı kuruyoruz.
      // rating 5 ise y = 0 (en üst)
      // rating 0 ise y = size.height (en alt)
      return size.height - ((rating / 5.0) * size.height);
    }

    // --- ÇİZİM MANTIĞI ---

    // SENARYO 1: Sadece 1 adet veri varsa (Düz çizgi çiz)
    if (ratings.length == 1) {
      double y = getY(ratings.first);
      
      // Çizgi (Soldan sağa düz)
      path.moveTo(0, y);
      path.lineTo(size.width, y);
      canvas.drawPath(path, strokePaint);

      // Dolgu
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, fillPaint);

      // Tek bir nokta (Ortaya)
      canvas.drawCircle(Offset(size.width / 2, y), 5, dotPaint);
      return;
    }

    // SENARYO 2: Birden fazla veri varsa (Eğrisel grafik çiz)
    final double stepX = size.width / (ratings.length - 1);

    path.moveTo(0, getY(ratings.first));

    for (int i = 0; i < ratings.length - 1; i++) {
      final double x1 = i * stepX;
      final double y1 = getY(ratings[i]);
      final double x2 = (i + 1) * stepX;
      final double y2 = getY(ratings[i + 1]);

      final double controlX = x1 + (stepX / 2);

      path.cubicTo(
        controlX, y1, // Kontrol noktası 1
        controlX, y2, // Kontrol noktası 2
        x2, y2,       // Hedef nokta
      );
    }

    // Önce çizgiyi çiz
    canvas.drawPath(path, strokePaint);

    // Sonra dolguyu çiz (Path'i kapatarak)
    Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Son olarak noktaları çiz
    for (int i = 0; i < ratings.length; i++) {
      final double cx = i * stepX;
      final double cy = getY(ratings[i]);
      
      // Nokta gölgesi (hafif beyazlık)
      canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = Colors.white);
      // Asıl nokta
      canvas.drawCircle(Offset(cx, cy), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.ratings != ratings;
  }
}