import 'dart:math';
import 'package:flutter/material.dart';

class LiquidWavePainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;

  LiquidWavePainter({required this.animationValue, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = accentColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    final path2 = Path();

    path1.moveTo(0, size.height * 0.7);
    path2.moveTo(0, size.height * 0.75);

    for (double i = 0; i <= size.width; i++) {
      double y1 = sin((i / size.width * 2 * pi) + (animationValue * 2 * pi)) * 18 + (size.height * 0.7);
      path1.lineTo(i, y1);

      double y2 = cos((i / size.width * 2 * pi) + (animationValue * 2 * pi)) * 12 + (size.height * 0.75);
      path2.lineTo(i, y2);
    }

    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant LiquidWavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}