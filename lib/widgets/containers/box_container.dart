import 'package:flutter/material.dart';

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
