import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

class CheckBox extends StatelessWidget {
  final Function() onTap;
  final String title;
  final bool isChecked;

  const CheckBox({
    required this.onTap,
    required this.title,
    required this.isChecked,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.15,
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(screenHeight * 0.015),
        ),
        child: Center(
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01),
            minVerticalPadding: 0,
            horizontalTitleGap: 0,
            title: Center(
              child: TextView.title(
                title.toUpperCase(),
                fontSize: 10.sp,
                color: AppColors.blackColor.withValues(alpha: 0.8)
              ),
            ),
            leading: SizedBox(
                width: screenWidth * 0.018,
                child: Container(
                  decoration: BoxDecoration(
                    color: isChecked ? AppColors.pinkColor : AppColors.transparentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isChecked ? AppColors.pinkColor : AppColors.blackColor.withValues(alpha: 0.6),
                      width: 2,
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
