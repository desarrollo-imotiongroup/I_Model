import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
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
  final Function()? onPress;
  final Function()? onLongPress;
  final ProgramStatus programStatus;

  const DashboardBodyProgram(
      {required this.title,
      required this.image,
      required this.percentage,
      required this.onDecrease,
      required this.onIncrease,
      this.topPadding,
      this.isImageLeading = true,
      this.intensityColor,
      this.onPress,
      this.onLongPress,
      this.programStatus = ProgramStatus.active,
      super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    Widget circleAvatar(Function()? onTap, {required ProgramStatus programStatus}){
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            CircleAvatar(
                backgroundColor:
                intensityColor ?? AppColors.lowIntensityColor,
                backgroundImage: AssetImage(image),
                radius: screenHeight * 0.05
            ),
            programStatus == ProgramStatus.blocked
            ? Positioned.fill(
                child: imageWidget(
                    image: Strings.blockMuscleGroupIcon
                )
            )
            : Container()
          ],
        ),
      );
    }

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
                    color: programStatus == ProgramStatus.inactive
                        ? AppColors.greyColor
                        : AppColors.pureWhiteColor,
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
            if (isImageLeading)
              Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0,
                    child: circleAvatar(onPress, programStatus: programStatus),
                  ) else
                    Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: circleAvatar(onPress, programStatus: programStatus)
                  )
          ],
        )
      ],
    );
  }
}
