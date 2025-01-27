import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';

class TimeControlWidget extends StatelessWidget {
  final Function()? onIncrease;
  final Function()? onDecrease;
  final Function()? onPlayPause;
  final String icon;

  const TimeControlWidget({
    this.onIncrease,
    this.onDecrease,
    this.onPlayPause,
    required this.icon,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Padding(
      padding: EdgeInsets.only(
          top: screenHeight * 0.02
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onIncrease,
            child: imageWidget(
                image: Strings.increaseIcon,
                height: screenHeight * 0.08
            ),
          ),
          SizedBox(width: screenWidth * 0.01,),
          GestureDetector(
            onTap: onPlayPause,
            child: imageWidget(
                image: icon,
                height: screenHeight * 0.1
            ),
          ),
          SizedBox(width: screenWidth * 0.01,),
          GestureDetector(
            onTap: onDecrease,
            child: imageWidget(
                image: Strings.decreaseIcon,
                height: screenHeight * 0.08
            ),
          ),
        ],
      ),
    );
  }
}
