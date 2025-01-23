import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextView {
  static Text title(final text, {final color, final TextAlign textAlign = TextAlign.start, final fontFamily, final lines, final fontSize, final isUnderLine = false}) {
    return Text(
      text ?? "",
      textAlign: textAlign,
      softWrap: true,
      maxLines: lines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize ?? 18.sp,
        color: color ?? AppColors.blackColor,
        decoration: isUnderLine ? TextDecoration.underline : TextDecoration.none,
        decorationColor: AppColors.pinkColor
      ),
    );
  }
}
