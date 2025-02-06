import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

class TopTitleButton extends StatelessWidget {
  final String title;
  final Function()? onCancel;
  final Color? textColor;
  final bool isCancelNeeded;
  final bool isAlert;
  final bool isUnderLine;

  const TopTitleButton({
    required this.title,
    this.onCancel,
    this.textColor,
    this.isCancelNeeded = true,
    this.isAlert = false,
    this.isUnderLine = true,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;

    return Row(
      children: [
        Expanded(
          child: Center(
            child: TextView.title(
              title.toUpperCase(),
              isUnderLine: isUnderLine ? true : false,
              color: textColor ?? AppColors.pinkColor,
              fontSize: isAlert ? 13.sp : 15.sp,
            ),
          ),
        ),
        isCancelNeeded
        ? GestureDetector(
          onTap: onCancel ?? () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close_sharp,
            size: screenHeight * 0.04,
            color: AppColors.blackColor.withValues(alpha: 0.8),
          ),
        )
        : Container(),
      ],
    );
  }
}
