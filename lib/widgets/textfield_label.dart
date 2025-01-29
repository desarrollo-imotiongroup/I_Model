import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textfield.dart';
import 'package:i_model/widgets/textview.dart';

class TextFieldLabel extends StatelessWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool? isReadOnly;
  final bool? isAllowNumberOnly;
  final TextInputAction? textInputAction;
  final double? fontSize;

  const TextFieldLabel(
      {super.key,
      required this.label,
      required this.textEditingController,
      this.isReadOnly,
      this.isAllowNumberOnly,
      this.textInputAction,
      this.fontSize,
      });

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * 0.015,
        ),
        TextView.title(label.toUpperCase(),
            color: AppColors.blackColor.withValues(alpha: 0.8),
            fontSize: 11.sp),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        TextFieldWidget(
          textEditingController: textEditingController,
          bgColor: AppColors.greyColor,
          width: screenWidth * 0.25,
          height: screenHeight * 0.07,
          textInputAction: textInputAction ?? TextInputAction.next,
          textColor: AppColors.blackColor.withValues(alpha: 0.8),
          fontSize: fontSize ?? 14.sp,
          isReadyOnly: isReadOnly ?? false ? true : false,
          textInputType: isAllowNumberOnly ?? false
              ? TextInputType.number
              : TextInputType.text,
        ),
      ],
    );
  }
}
