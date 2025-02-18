import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

Widget noEntryToTab(BuildContext context, {required String title}){
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;

  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.15
    ),
    child: Center(
      child: TextView.title(
        title.toUpperCase(),
          fontSize: 10.sp,
          lines: 2,
          textAlign: TextAlign.center,
          color: AppColors.blackColor.withValues(alpha: 0.8)
      ),
    ),
  );
}