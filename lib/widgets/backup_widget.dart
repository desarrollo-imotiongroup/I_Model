import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/button.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/textview.dart';

class BackupWidget extends StatelessWidget {
  final Function()? onCancel;
  final bool isMakeCopySelected;
  final bool isReStoreCopySelected;
  final Function()? onTapMakeCopy;
  final Function()? onTapReStoreCopy;
  final bool isYesSelected;
  final bool isNoSelected;
  final Function()? onTapYes;
  final Function()? onTapNo;

  const BackupWidget(
      {this.onCancel,
      this.isMakeCopySelected = false,
      this.isReStoreCopySelected = false,
      this.onTapMakeCopy,
      this.onTapNo,
      this.onTapReStoreCopy,
      this.onTapYes,
      this.isNoSelected = false,
      this.isYesSelected = false,
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
                        Strings.backup,
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
            height: screenHeight * 0.05,
          ),

          /// Make copy and restore copy button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundedContainer(
                color: isMakeCopySelected  ? AppColors.darkGrey2 : AppColors.transparentColor,
                widget: TextView.title(
                  Strings.makeCopy,
                  color: isMakeCopySelected  ? AppColors.pureWhiteColor : AppColors.darkGrey2,
                  fontSize: 12.sp,
                ),
                onTap: onTapMakeCopy,
              ),
              RoundedContainer(
                color: isReStoreCopySelected  ? AppColors.darkGrey2 : AppColors.transparentColor,
                widget: TextView.title(Strings.reStoreCopy,
                    color: isReStoreCopySelected  ? AppColors.pureWhiteColor : AppColors.darkGrey2,
                    fontSize: 12.sp),
                onTap: onTapReStoreCopy,
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          TextView.title(
            isMakeCopySelected
                ? Strings.makeCopyConfirmationMsg
                : isReStoreCopySelected
                    ? Strings.reStoreCopyConfirmationMsg
                    : Strings.nothing,

            color: AppColors.darkGrey2,
            fontSize: 12.sp,
          ),

          SizedBox(height: screenHeight * 0.05,),
          /// Si and No buttons
          isReStoreCopySelected || isMakeCopySelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedContainer(
                      color: isYesSelected  ? AppColors.darkGrey2 : AppColors.transparentColor,
                      width: screenWidth * 0.05,
                      widget: TextView.title(
                        Strings.yes,
                        color: isYesSelected  ? AppColors.pureWhiteColor : AppColors.darkGrey2,
                        fontSize: 12.sp,
                      ),
                      onTap: onTapYes,
                    ),
                    RoundedContainer(
                      color: isNoSelected  ? AppColors.darkGrey2 : AppColors.transparentColor,
                      width: screenWidth * 0.05,
                      widget: TextView.title(
                          Strings.no,
                          color: isNoSelected  ? AppColors.pureWhiteColor : AppColors.darkGrey2,
                          fontSize: 12.sp),
                      onTap: onTapNo,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
