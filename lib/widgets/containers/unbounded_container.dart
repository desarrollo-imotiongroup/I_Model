import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';

class UnboundedContainer extends StatelessWidget {
  final double? height;
  final Color? color;
  final Function()? onTap;
  final Color? borderColor;
  final Widget? widget;

  const UnboundedContainer({
    this.height,
    this.color,
    this.onTap,
    this.borderColor,
    this.widget,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(screenHeight * 0.007),
              border: Border.all(
                  color: borderColor ?? AppColors.transparentColor
              )
          ),
          child: Center(child: Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: screenHeight * 0.05,
              vertical: screenHeight * 0.01,
            ),
            child: widget,
          ))
      ),
    );
  }
}
