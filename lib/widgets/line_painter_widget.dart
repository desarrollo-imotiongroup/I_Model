import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/line_painter.dart';
import 'package:i_model/widgets/textview.dart';

class LinePainterWidget extends StatelessWidget {
  final String title;
  final double progressValue;
  final Color progressColor;

  const LinePainterWidget({
    required this.title,
    required this.progressValue,
    required this.progressColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Column(
      children: [
        TextView.title(
            title,
            fontSize: 10.sp,
            color: AppColors.blackColor.withValues(alpha: 0.8)
        ),
        SizedBox(height: screenHeight * 0.006,),
        CustomPaint(
          size: Size(
            screenWidth * 0.19,
            screenHeight * 0.03,
          ),
          painter: LinePainter(
              progress: progressValue,
              strokeHeight: screenHeight * 0.023,
              progressColor: progressColor
          ),
        ),
      ],
    );
  }
}


