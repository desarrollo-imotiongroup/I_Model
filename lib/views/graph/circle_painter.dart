import 'package:flutter/material.dart';

class CirclePainterWidget extends StatelessWidget {
  const CirclePainterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300), // Canvas size
      painter: CirclePainter(),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // List of colors for the circles
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.lightGreenAccent,
      Colors.green,
      Colors.blue,
      Colors.white,
    ];

    /// Draw 6 circles with decreasing radius
    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      double radius = (size.width / 2) - (i * 25); // Decreasing radius
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint constantly
  }
}