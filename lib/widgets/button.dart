import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/textview.dart';

class Button extends StatelessWidget {
  final double ? width;
  final double ? height;
  final double ? fontSize;
  final String ? text;
  final Function ? onPress;
  final Color ? btnColor;
  final Color ? textColor;
  final Color ? borderColor;
  final double ? borderRadius;
  final Function()? onTap;

  const Button(
      {Key? key, this.width,
        this.height,
        this.text,
        this.onPress,
        this.btnColor,
        this.textColor,
        this.borderRadius,
        this.onTap,
        this.fontSize,
        this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return GestureDetector(
      //key: const Key('Main button'),
      onTap: onTap,
      child: Container(
        height: height ?? screenHeight * 0.075,
        width:  width ?? screenWidth,
        decoration: BoxDecoration(
          color: btnColor ?? AppColors.pinkColor,
          border: Border.all(color: borderColor??Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? screenWidth *.02,),
        ),
        child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              child: TextView.title(
                  text?? 'Submit',
                  color: textColor?? AppColors.pureWhiteColor,
                  fontSize: fontSize ?? 18.sp
              ),
            )
        ),
      ),
    );
  }
}
