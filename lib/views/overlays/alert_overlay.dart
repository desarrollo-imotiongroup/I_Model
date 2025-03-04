import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/containers/unbounded_container.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void alertOverlay(
  BuildContext context, {
  required String heading,
  String buttonText = '',
  String description = '',
  Color? headingColor,
  bool isOneButtonNeeded = false,
  Function()? onPress,
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Wrap(
          children: [
            Container(
              width: screenWidth * 0.4,
              height: description != '' ? screenHeight * 0.30 : screenHeight * 0.25,
              decoration: boxDecoration(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.02,
                ),
                child: Column(
                  children: [
                    TopTitleButton(
                      title: heading,
                      isCancelNeeded: false,
                      isAlert: true,
                      textColor: headingColor,
                      isUnderLine: false,
                    ),
                    description != ''
                        ? Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: TextView.title(
                              textAlign: TextAlign.center,
                              description.toUpperCase(),
                              fontSize: 11.sp,
                              lines: 2,
                              color: AppColors.blackColor
                                  .withValues(alpha: 0.7)),
                        ),
                      ],
                    )
                        : Container(),
                    Spacer(),
                    if (isOneButtonNeeded)
                      Center(
                      child: SizedBox(
                        width: screenWidth * 0.15,
                        child: UnboundedContainer(
                          borderColor: AppColors.pinkColor,
                          onTap: () {
                            if (overlayEntry.mounted) {
                              overlayEntry.remove();
                            }
                          },
                          widget: TextView.title(
                              translation(context).gotIt.toUpperCase(),
                              fontSize: 11.sp,
                              color: AppColors.pinkColor),
                        ),
                      ),
                    ) else Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UnboundedContainer(
                          borderColor: AppColors.pinkColor,
                          onTap: () {
                            if (overlayEntry.mounted) {
                              overlayEntry.remove();
                            }
                          },
                          widget: TextView.title(
                              translation(context).cancel.toUpperCase(),
                              fontSize: 11.sp,
                              color: AppColors.pinkColor),
                        ),
                        UnboundedContainer(
                          onTap: (){
                            onPress!();
                            if (overlayEntry.mounted) {
                              overlayEntry.remove();
                            }
                          },
                          color: AppColors.darkRedColor,
                          widget: TextView.title(buttonText.toUpperCase(),
                              fontSize: 11.sp,
                              color: AppColors.pureWhiteColor),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

}
