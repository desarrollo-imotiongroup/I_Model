import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class FirstStepWidget extends StatelessWidget {
  final Function()? onCancel;
  final Function()? onTapLicense;
  final Function()? onTapHowToPrepare;

  const FirstStepWidget(
      {this.onTapHowToPrepare, this.onTapLicense, this.onCancel, super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    Widget tutorialStepWidget({
      required String title,
      required String image,
      Function()? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.17,
              child: TextView.title(title.toUpperCase(),
                  color: AppColors.blackColor.withValues(alpha: 0.8),
                  fontSize: 10.sp,
                  lines: 2,
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            imageWidget(
              image: Strings.newMeasurementIcon,
              height: screenHeight * 0.2,
            )
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.05),
      width: screenWidth * 0.52,
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
        color: AppColors.pureWhiteColor,
        borderRadius: BorderRadius.circular(screenHeight * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3), // Shadow color
            spreadRadius: 3, // How wide the shadow spreads
            blurRadius: 2, // The blur effect
            offset: Offset(0, 3), // Changes position of shadow (x, y)
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: TextView.title(
                        translation(context).firstSteps.toUpperCase(),
                        isUnderLine: true,
                        color: AppColors.pinkColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCancel,
                child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.015),
                    child: Icon(
                      Icons.close_sharp,
                      size: screenHeight * 0.04,
                      color: AppColors.blackColor.withValues(alpha: 0.8),
                    )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              top: screenHeight * 0.002,
            ),
            child: Divider(
              color: AppColors.pinkColor,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// License
              tutorialStepWidget(
                title: translation(context).license,
                image: Strings.newMeasurementIcon,
                onTap: onTapLicense,
              ),

              /// How to prepare equipment
              tutorialStepWidget(
                title: translation(context).howToPrepareEquipment,
                image: Strings.newMeasurementIcon,
                onTap: onTapHowToPrepare,
              ),
            ],
          )
        ],
      ),
    );
  }
}
