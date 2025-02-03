import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

Widget tableTextInfo({required String title, double? fontSize, Color? color, int lines = 1, bool isCenter = false}){
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      child: TextView.title(
        title.toUpperCase(),
        fontSize: fontSize ?? 12.sp,
        color: color ?? AppColors.pinkColor,
        lines: lines == 1 ? 1 : lines,
        textAlign: isCenter ? TextAlign.center : TextAlign.start
      ),
    ),
  );
}
