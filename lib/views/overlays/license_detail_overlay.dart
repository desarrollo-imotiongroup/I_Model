import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/top_title_button.dart';
import 'package:i_model/widgets/textview.dart';

void licenseDetailOverlay(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;

  mciInfoWidget(String text){
    return TextView.title(
        text,
        fontSize: 10.sp,
        color: AppColors.blackColor.withValues(alpha: 0.8)
    );
  }
  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.7,
          height: screenHeight * 0.65, // Ensure overlays height remains fixed
          decoration: boxDecoration(context),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: TopTitleButton(
                    title: translation(context).mci,
                    onCancel: (){
                      if (overlayEntry.mounted) {
                        overlayEntry.remove();
                      }
                    },
                ),
              ),
              Divider(color: AppColors.pinkColor),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.05,
                  horizontal: screenWidth * 0.035,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Info column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView.title(
                          Strings.mciId,
                          color: AppColors.blackColor.withValues(alpha: 0.8),
                          fontSize: 12.sp,
                        ),
                        SizedBox(height: screenHeight * 0.08,),
                        Column(
                          children: [
                            TextView.title(
                              translation(context).info,
                              color: AppColors.blackColor.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                            SizedBox(height: screenHeight * 0.02,),
                            CustomContainer(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.3,
                              color: AppColors.greyColor,
                                widget: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          mciInfoWidget('C:'),
                                          mciInfoWidget('T:'),
                                          mciInfoWidget('CT:'),
                                          mciInfoWidget('CP:'),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          mciInfoWidget('V:'),
                                          mciInfoWidget('LS:'),
                                          mciInfoWidget('FS:'),
                                          mciInfoWidget('TS:'),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        )
                      ],
                    ),

                    /// Recharge column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            TextView.title(
                              '${translation(context).status.toUpperCase()}: ',
                              color: AppColors.blackColor.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                            TextView.title(
                              translation(context).inactive.toUpperCase(),
                              color: AppColors.pinkColor,
                              fontSize: 12.sp,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.08,),
                        Column(
                          children: [
                            RoundedContainer(
                              borderColor: AppColors.pinkColor,
                              width: screenWidth * 0.12,
                                widget: TextView.title(
                                    translation(context).recharge,
                                  fontSize: 12.sp,
                                  color: AppColors.pinkColor
                                )
                            ),
                            SizedBox(height: screenHeight * 0.02,),
                            CustomContainer(
                                height: screenHeight * 0.2,
                                width: screenWidth * 0.3,
                                color: AppColors.greyColor,
                                widget: Container()
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);


}
