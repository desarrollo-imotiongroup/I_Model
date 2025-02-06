import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';


class DashboardBodyProgram extends StatelessWidget {
  final String title;
  final String image;
  final int percentage;
  final Function()? onIncrease;
  final Function()? onDecrease;
  final double? topPadding;
  final bool isImageLeading;
  final Color? intensityColor;

  const DashboardBodyProgram(
      {required this.title,
      required this.image,
      required this.percentage,
      required this.onDecrease,
      required this.onIncrease,
      this.topPadding,
      this.isImageLeading = true,
      this.intensityColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Column(
      children: [
        SizedBox(height: topPadding ?? screenHeight * 0.025),
        TextView.title(title.toUpperCase(),
            fontSize: 11.sp,
            color: AppColors.blackColor.withValues(alpha: 0.8)),
        SizedBox(
          height: screenHeight * 0.005,
        ),
        Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  width: isImageLeading ? screenWidth * 0.02 : 0,
                ),
                RoundedContainer(
                    borderRadius: screenHeight * 0.025,
                    borderColor: AppColors.transparentColor,
                    width: screenWidth * 0.185,
                    color: AppColors.pureWhiteColor,
                    widget: Row(
                      mainAxisAlignment: isImageLeading ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: onIncrease,
                          child: imageWidget(
                              image: Strings.increaseIcon,
                              height: screenHeight * 0.07),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        TextView.title('${percentage.toString()}%',
                            fontSize: 11.sp,
                            color: AppColors.blackColor.withValues(alpha: 0.8)),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        GestureDetector(
                          onTap: onDecrease,
                          child: imageWidget(
                              image: Strings.decreaseIcon,
                              height: screenHeight * 0.07),
                        ),
                      ],
                    )),

                SizedBox(
                  width: !isImageLeading ? screenWidth * 0.02 : 0,
                ),
              ],
            ),
            isImageLeading
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0,
                    child: CircleAvatar(

                        backgroundColor:
                            intensityColor ?? AppColors.lowIntensityColor,
                        backgroundImage: AssetImage(image),
                        radius: screenHeight * 0.05),
                  )
                : Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: CircleAvatar(
                        backgroundColor:
                            intensityColor ?? AppColors.lowIntensityColor,
                        backgroundImage: AssetImage(image),
                        radius: screenHeight * 0.05),
                  )
          ],
        )
      ],
    );
  }
}
