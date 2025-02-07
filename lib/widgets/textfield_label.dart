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
  final double? width;
  final String? unit;
  final Function(String)? onChanged;
  final bool isObscureText;
  final bool isSuffixIcon;
  final Widget? suffixIcon;

  const TextFieldLabel({
    super.key,
    required this.label,
    required this.textEditingController,
    this.isReadOnly,
    this.isAllowNumberOnly,
    this.textInputAction,
    this.fontSize,
    this.width,
    this.unit,
    this.onChanged,
    this.isObscureText = false,
    this.isSuffixIcon = false,
    this.suffixIcon
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
        Row(
          children: [
            TextView.title(label.toUpperCase(),
                color: AppColors.blackColor.withValues(alpha: 0.8),
                fontSize: 11.sp),
            TextView.title(unit ?? '',
                fontSize: 11.sp,
                color: AppColors.blackColor.withValues(alpha: 0.8)),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.005,
        ),
        TextFieldWidget(
          onChanged: onChanged,
          textEditingController: textEditingController,
          bgColor: AppColors.greyColor,
          width: width ?? screenWidth * 0.25,
          height: screenHeight * 0.07,
          textInputAction: textInputAction ?? TextInputAction.next,
          textColor: AppColors.blackColor.withValues(alpha: 0.8),
          fontSize: fontSize ?? 14.sp,
          obscureText: isObscureText,
          isSuffixIcon: isSuffixIcon,
          suffixIcon: suffixIcon,
          isReadyOnly: isReadOnly ?? false ? true : false,
          textInputType: isAllowNumberOnly ?? false
              ? TextInputType.number
              : TextInputType.text,
        ),
      ],
    );
  }
}
