import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

class MenuWidget extends StatelessWidget {
  final Function()? onTap;
  final String title;

  const MenuWidget({
    this.onTap,
    required this.title,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return  GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            bottom: screenHeight * 0.02,
            left: screenWidth * 0.05
        ),
        width: screenWidth * 0.24,
        height: screenHeight * 0.1,
        child: Card(
          color: AppColors.pureWhiteColor,
          elevation: 5,
          shadowColor: AppColors.pureWhiteColor,
          child: Center(
            child: TextView.title(
                title,
                color: AppColors.pinkColor,
                fontSize: 14.sp
            ),
          ),
        ),
      ),
    );
  }
}
