import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController ? textEditingController;
  final bool ? obscureText;
  final String?  hint;
  final TextInputType? textInputType;
  final double ? width;
  final double ? height;
  final double ? fontSize;
  final String ? icon;
  final Color? borderColor;
  final Color? bgColor;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? cursorColor;
  final TextInputAction? textInputAction;
  final bool? isReadyOnly;


  const TextFieldWidget(
      {super.key,
        this.textEditingController,
        this.obscureText,
        this.hint,
        this.textInputType,
        this.width,
        this.fontSize,
        this.height,
        this.icon,
        this.borderColor,
        this.bgColor,
        this.textColor,
        this.hintTextColor,
        this.cursorColor,
        this.textInputAction,
        this.isReadyOnly
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.04,
      width:  width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: bgColor?? AppColors.lightGrey,
          border: Border.all(color: borderColor?? AppColors.lightGrey),
          borderRadius: BorderRadius.all(Radius.circular(
              MediaQuery.of(context).size.height*.01))
      ),
      child: Center(
        child: TextField(
          controller: textEditingController,
          obscureText:obscureText?? false,
          cursorHeight: 16.sp,
          keyboardType: textInputType??TextInputType.text,
          cursorColor: cursorColor?? AppColors.lightBlack,
          readOnly: isReadyOnly ?? false ? true : false,
          style: TextStyle(
            color: textColor ?? AppColors.lightBlack,
            fontSize: fontSize ?? 15.sp,
          ),
          textInputAction: textInputAction ?? TextInputAction.next,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.02),
              hintText: hint??"",
              alignLabelWithHint: false,
              hintStyle: TextStyle(
                color: hintTextColor ?? AppColors.darkGrey,
                fontSize: 15.sp,
              )
          ),
        ),
      ),
    );
  }
}
