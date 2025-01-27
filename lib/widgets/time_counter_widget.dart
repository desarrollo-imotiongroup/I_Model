import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class TimeCounterWidget extends StatelessWidget {
  final String minutes;
  final String timeImage;
  final Function()? onIncrease;
  final Function()? onDecrease;

  const TimeCounterWidget({
    required this.minutes,
    required this.onDecrease,
    required this.onIncrease,
    required this.timeImage,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return  Center(
        child: Stack(
          children: <Widget>[
            imageWidget(
              image:  timeImage,
              height: screenHeight * 0.25,
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onIncrease,
                    child: imageWidget(
                        image: Strings.arrowUp,
                        height: screenHeight * 0.03
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02
                    ),
                    child: TextView.title(
                        minutes,
                        fontSize: 16.sp,
                        isBold: true,
                        color: AppColors.blackColor.withValues(alpha: 0.8)
                    ),
                  ),
                  GestureDetector(
                    onTap: onDecrease,
                    child: imageWidget(
                        image: Strings.arrowDown,
                        height: screenHeight * 0.03
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
