import 'package:flutter/material.dart';

/// Green - Contraction
class LinePainter extends CustomPainter {
  final double progress;
  final double strokeHeight;
  final Color progressColor;

  const LinePainter({
    required this.progress,
    required this.strokeHeight,
    required this.progressColor
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300 // Background color of the bar
      ..style = PaintingStyle.fill;

    Paint progressPaint = Paint()
      ..color = progressColor // Green color for the fill
      ..style = PaintingStyle.fill;

    double cornerRadius = 100; // The radius of the rounded corners

    // Draw the background bar (initially empty)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, size.height / 2 - strokeHeight / 2, size.width, strokeHeight),
        Radius.circular(cornerRadius),
      ),
      backgroundPaint,
    );

    // Draw the progress (green bar)
    double progressWidth =
        size.width * progress; // Calculate the width based on progress
    progressWidth = progressWidth.clamp(
        0.0, size.width); // Ensures it does not exceed the width of the bar

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, size.height / 2 - strokeHeight / 2, progressWidth, strokeHeight),
        Radius.circular(cornerRadius),
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint when progress changes
  }
}

/// Red - Pulse
class LinePainter2 extends CustomPainter {
  final double progress3; // Progress from 1.0 to 0.0 (full to empty)
  final double strokeHeight; // Bar height

  LinePainter2({required this.progress3, required this.strokeHeight});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300 // Background color of the bar
      ..style = PaintingStyle.fill;

    Paint progressPaint = Paint()
      ..color = Colors.red // Red color for the fill
      ..style = PaintingStyle.fill;

    double cornerRadius =
        strokeHeight / 5; // The radius of the rounded corners

    // Draw the background bar (initially empty)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, size.height / 2 - strokeHeight / 2, size.width, strokeHeight),
        Radius.circular(cornerRadius),
      ),
      backgroundPaint,
    );

    // Draw the progress (red bar)
    double progressWidth =
        size.width * progress3; // Calculate width based on progress
    progressWidth = progressWidth.clamp(
        0.0, size.width); // Ensures it does not exceed the width of the bar

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, size.height / 2 - strokeHeight / 2, progressWidth, strokeHeight),
        Radius.circular(cornerRadius),
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint when progress changes
  }
}


class AverageLineWithTextPainter extends CustomPainter {
  final double average; // The average value (from 0.0 to 1.0)
  final double strokeHeight; // Bar height
  final TextStyle textStyle; // Text style (for percentage)

  AverageLineWithTextPainter({
    required this.average,
    required this.strokeHeight,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.transparent // Background color of the bar
      ..style = PaintingStyle.fill;

    Paint progressPaint = Paint()
      ..color = const Color(0xFF2be4f3) // Unique color of the progress bar
      ..style = PaintingStyle.fill;

    // Draw the background bar with a point (arrow) at the end
    Path backgroundPath = Path()
      ..moveTo(0, size.height / 2 - strokeHeight / 2) // Start from the left edge
      ..lineTo(size.width, size.height / 2 - strokeHeight / 2) // Draw the background base to full width
      ..lineTo(size.width + 10, size.height / 2) // Draw the tip towards the center
      ..lineTo(size.width, size.height / 2 + strokeHeight / 2) // Go down to the end of the bar
      ..lineTo(0, size.height / 2 + strokeHeight / 2) // Draw the bottom border of the bar
      ..close(); // Close the form

    // Draw the background of the bar
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Draw the progress with the same tip shape (arrow)
    double progressWidth = size.width * average; // Calculate the width based on the average
    progressWidth = progressWidth.clamp(0.0, size.width); // Ensures you don't overdo it

    // Draw the progress background (bar with normal background)
    Path progressPath = Path()
      ..moveTo(0, size.height / 2 - strokeHeight / 2) // Start from the left edge
      ..lineTo(progressWidth, size.height / 2 - strokeHeight / 2) // Draw the progress to the desired width
      ..lineTo(progressWidth + 10, size.height / 2) // Draw the tip towards the center
      ..lineTo(progressWidth, size.height / 2 + strokeHeight / 2) // Return to the end of the progress bar
      ..lineTo(0, size.height / 2 + strokeHeight / 2) // Draw the bottom border of the bar
      ..close(); // Close the form

    // Draw the progress bar with the same tip shape
    canvas.drawPath(progressPath, progressPaint);

    // Draw the percentage in the center of the bar
    String percentageText = "${(average.clamp(0.0, 1.0) * 100).toStringAsFixed(0)}%";
    TextSpan textSpan = TextSpan(
      text: percentageText,
      style: textStyle.copyWith(color: Colors.white), // White text
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // The text position should be just to the right of the progress bar
    double textX = progressWidth + 12; // Move the text to the right of the bar
    double textY = (size.height - textPainter.height) / 2;

    // If the percentage is 100%, the text should go outside the bar
    if (average == 1.0) {
      textX += 10; // Shift further to the right
    }

    // Draw the text at the calculated position
    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint when the average changes
  }
}