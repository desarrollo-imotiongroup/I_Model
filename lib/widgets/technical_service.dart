import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';

class TechnicalService extends StatelessWidget {
  final Function()? onCancel;

  const TechnicalService({
    this.onCancel,
    super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;


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
          SizedBox(height: screenWidth * 0.01,),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: TextView.title(
                        translation(context).technicalService,
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
                  )
                ),
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
          SizedBox(height: screenHeight * 0.02,),
          TextView.title(
              translation(context).contact,
              fontSize: 13.sp,
              color: AppColors.pinkColor
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                top: screenHeight * 0.02
            ),
            child: TextView.title(
                translation(context).contactInfo,
                fontSize: 11.sp,
                color: AppColors.blackColor.withValues(alpha: 0.7),
                lines: 2,
                textAlign: TextAlign.center
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.05),
            width: screenWidth * 0.35,
            decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(
                    screenHeight * 0.02
                )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02
              ),
              child: Column(
                children: [
                  TextView.title(
                    '${translation(context).email}: technical_service@i-motiongroup.com',
                    fontSize: 11.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.7),
                  ),
                  SizedBox(height: screenHeight * 0.01,),
                  TextView.title(
                    '${translation(context).whatsapp}:  (+34) 618 112 271',
                    fontSize: 11.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

  }
}
