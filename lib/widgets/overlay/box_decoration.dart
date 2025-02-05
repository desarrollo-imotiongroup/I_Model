import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';

BoxDecoration boxDecoration(BuildContext context){
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenHeight = mediaQuery.size.height;

  return BoxDecoration(
    color: AppColors.pureWhiteColor,
    borderRadius: BorderRadius.circular(screenHeight * 0.02),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.3),
        spreadRadius: 3,
        blurRadius: 2,
        offset: Offset(0, 3),
      ),
    ],
  );
}



