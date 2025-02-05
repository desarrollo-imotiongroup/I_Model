import 'package:flutter/material.dart';
import 'package:i_model/core/colors.dart';

class RoundedContainer extends StatelessWidget {
  final Widget widget;
  final double? borderRadius;
  final double? width;
  final Color? color;
  final EdgeInsets? padding;
  final Function()? onTap;
  final Color? borderColor;

  const RoundedContainer({
    required this.widget,
    this.borderRadius,
    this.width,
    this.color,
    this.onTap,
    this.padding,
    this.borderColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? screenWidth * .17,
          decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius ?? screenHeight * 0.01),
          border: Border.all(
            color: borderColor ?? AppColors.darkGrey2
          )
        ),
        child: Center(child: Padding(
          padding: padding ?? EdgeInsets.all(
             screenHeight * 0.015
          ),
          child: widget,
        ))
      ),
    );
  }
}


class BarContainer extends StatelessWidget {
  final double? width;
  final Color? color;
  final Function()? onTap;

  const BarContainer({
    this.width,
    this.color,
    this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: width ?? screenWidth * .17,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(screenHeight * 0.0),
          ),
          child: SizedBox())
      );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget widget;
  final double? width;
  final double? height;
  final Color? color;
  final EdgeInsets? padding;
  final Function()? onTap;
  final Color? borderColor;

  const CustomContainer({
    required this.widget,
    this.width,
    this.height,
    this.color,
    this.onTap,
    this.padding,
    this.borderColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: height ?? screenHeight * 0.5,
          width: width ?? screenWidth * .17,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(screenHeight * 0.01),
              border: Border.all(
                  color: borderColor ?? AppColors.transparentColor
              )
          ),
          child: Center(child: Padding(
            padding: padding ?? EdgeInsets.all(
                screenHeight * 0.015
            ),
            child: widget,
          ))
      ),
    );
  }
}

