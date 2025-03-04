import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/line_painter_widget.dart';
import 'package:i_model/widgets/textview.dart';

class LinePainterWithSeconds extends StatelessWidget {
  final double progressValue;
  final int secondsPerCycle;
  final bool isPause;
  final bool isActiveRecovery;
  final Function()? onPauseTap;

  const LinePainterWithSeconds({
    required this.progressValue,
    required this.secondsPerCycle,
    this.isPause = false,
    this.isActiveRecovery = false,
    this.onPauseTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LinePainterWidget(
          onPauseTap: onPauseTap,
          isPause: isPause,
          isActiveRecovery: isActiveRecovery,
          title: isPause
              ? translation(context).pauseTime
              : translation(context).contractionTime,
          progressValue:progressValue,
          progressColor: isPause ? AppColors.redColor : AppColors.greenColor,
        ),
        SizedBox(width: screenWidth * 0.01,),
        TextView.title(
            secondsPerCycle.toString(),
            fontSize: 11.sp,
            color: AppColors.blackColor.withValues(alpha: 0.8)
        )
      ],
    );
  }
}
