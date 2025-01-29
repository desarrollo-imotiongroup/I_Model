import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program_model.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/view_models/menu_controller.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/textfield.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

void withDeviceBiompedancia(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final MenuScreenController controller = Get.put(MenuScreenController());

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.7,
          height: screenHeight * 0.95, // Ensure overlay height remains fixed
          decoration: BoxDecoration(
            color: AppColors.pureWhiteColor,
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3), // Fixed shadow issue
                spreadRadius: 3,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenWidth * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TextView.title(
                            translation(context).biompedancia.toUpperCase(),
                            isUnderLine: true,
                            color: AppColors.pinkColor,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (overlayEntry.mounted) {
                            overlayEntry.remove();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.005),
                          child: Icon(
                            Icons.close_sharp,
                            size: screenHeight * 0.04,
                            color: AppColors.blackColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.pinkColor),

                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.04,
                    top: screenHeight * 0.03
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          RoundedContainer(
                            borderRadius: screenHeight * 0.01,
                            width: screenWidth * 0.2,
                              widget: TextView.title(
                                Strings.selectClient.toUpperCase(),
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                              )
                          ),
                          SizedBox(height: screenHeight * 0.02,),
                          /// Name - TextField
                          TextFieldLabel(
                              label: Strings.name,
                              textEditingController: controller.nameEditingController,
                              isReadOnly: true,
                          ),

                          /// Gender - TextField
                          TextFieldLabel(
                            label: Strings.gender,
                            textEditingController: controller.genderEditingController,
                            isReadOnly: true,
                          ),

                          /// Height - TextField
                          TextFieldLabel(
                            label: Strings.height,
                            textEditingController: controller.heightEditingController,
                            isReadOnly: true,
                          ),

                          /// Weight - TextField
                          TextFieldLabel(
                            label: Strings.weight,
                            textEditingController: controller.weightEditingController,
                            isReadOnly: true,
                          ),

                          /// Email - TextField
                          TextFieldLabel(
                            label: Strings.email,
                            textEditingController: controller.emailEditingController,
                            isReadOnly: true,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.8,
                        child: VerticalDivider(
                          color: AppColors.pinkColor,    // Color of the divider
                          thickness: 1,           // Thickness of the divider
                          width: 1,              // Width of the space the divider occupies
                          indent: 2,             // Space above the divider
                          endIndent: 0,          // Space below the divider
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.76,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedContainer(
                                borderRadius: screenHeight * 0.01,
                                width: screenWidth * 0.2,
                                widget: TextView.title(
                                  Strings.takeNewMeasurement.toUpperCase(),
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                )
                            ),
                            Column(
                              children: [
                                TextView.title(
                                  Strings.howToTakeMeasurement.toUpperCase(),
                                  color: AppColors.pinkColor,
                                  fontSize: 13.sp,
                                ),
                                SizedBox(height: screenHeight * 0.02,),
                                imageWidget(
                                    image: Strings.newMeasurementIcon
                                )
                              ],
                            ),
                            SizedBox(
                              width: screenWidth * 0.32,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: imageWidget(
                                    image: Strings.checkIcon,
                                    height: screenHeight * 0.09
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  overlayState.insert(overlayEntry);
}

