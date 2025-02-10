import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';

class SpiderChart extends StatelessWidget {
  final List<int> data;

  const SpiderChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: SpiderChartPainter(data, context),
    );
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<int> data;
  final BuildContext context;

  SpiderChartPainter(this.data, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final int numAxes = data.length;
    final double radius = size.width / 2;

    /// Center of the chart
    final Offset center = Offset(size.width / 2, size.height / 2);

    /// Angles of the axes
    final double angleStep = 2 * pi / numAxes;

    /// Draw the axes
    for (int i = 0; i < numAxes; i++) {
      final double angle = angleStep * i;
      final double x = center.dx + radius * cos(angle);
      final double y = center.dy + radius * sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }

    /// Draw the areas (polygon)
    Path path = Path();
    for (int i = 0; i < numAxes; i++) {
      final double angle = angleStep * i;
      final int value = data[i];
      final double x = center.dx + (radius * (value / 100)) * cos(angle);
      final double y = center.dy + (radius * (value / 100)) * sin(angle);

      if (i == 0) {
        path.moveTo(x, y); // Start path at the first point
      } else {
        path.lineTo(x, y); // Connect the points
      }
    }
    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    List<Color> circleColors = [
      Colors.pink,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
    ];

    /// Draw the reference circles
    const int levels = 6;
    for (int i = 1; i <= levels; i++) {
      double levelRadius = (size.width / 2) - (i * 25); // Decreasing radius
      // Use a different color for each reference circle
      Paint circlePaint = Paint()
        ..color = circleColors[i - 1]
        ..style = PaintingStyle.stroke; // Ensure it's just a border, not filled

      canvas.drawCircle(center, levelRadius, circlePaint);
    }

    List<String> labelsText = [
      translation(context).fatFreeHydration.toUpperCase(),
      translation(context).waterBalance.toUpperCase(),
      translation(context).imc.toUpperCase(),
      translation(context).bodyFat.toUpperCase(),
      translation(context).muscle.toUpperCase(),
      translation(context).skeleton.toUpperCase(),
    ];

    // Draw the labels
    for (int i = 0; i < numAxes; i++) {
      final double angle = angleStep * i;
      final double x = center.dx + (radius + 20) * cos(angle);
      final double y = center.dy + (radius + 20) * sin(angle);

      /// Assign the label according to the axis (i)
      String label = labelsText[i % labelsText.length];

      // Calculate the tangent angle (perpendicular to the axis)
      double tangentAngle = angle + pi / 2; // 90 degrees in radians (π/2)

      /// Set the text style
      TextSpan span = TextSpan(
        style: GoogleFonts.oswald(
          color: AppColors.blackColor.withValues(alpha: 0.8),
          fontSize: 11.sp,
        ),
        text: label,
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      /// Draw the text, centered and rotated
      canvas.save();
      canvas.translate(x, y); // Move to the center of the label
      canvas.rotate(tangentAngle); // Rotate the text to be perpendicular
      tp.paint(
          canvas, Offset(-tp.width / 2, -tp.height / 2)); // Draw the text
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}