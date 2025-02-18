import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/view_models/max_time_controller.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void maxTimeSelectionOverlay(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  MaxTimeSelectionController controller = Get.put(MaxTimeSelectionController());
  int oldMaxValue = controller.maxTimeValue.value;
  controller.onInit();

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.4,
          height: screenHeight * 0.4,
          decoration: boxDecoration(context),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: TopTitleButton(
                  title: translation(context).maxTime,
                  onCancel: () {
                    if (overlayEntry.mounted) {
                      overlayEntry.remove();
                    }
                  },
                ),
              ),

              Divider(color: AppColors.pinkColor),

              /// Slider for selecting max time
              Obx(() => Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05
                          ),
                          child: Slider(
                            activeColor: AppColors.pinkColor,
                            min: 20,
                            max: 30,
                            divisions: 10,
                            // Divisions between the values
                            value: controller.maxTimeValue.value.toDouble(),
                            onChanged: (double value) {
                              controller.maxTimeValue.value = value.toInt();
                            },
                          ),
                        ),

                        /// Display the selected value (minutes)
                        TextView.title(
                            '${controller.maxTimeValue.value} ${translation(context).minutes.toUpperCase()}',
                            fontSize: 12.sp),

                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        RoundedContainer(
                            onTap: () async {
                              controller.selectMaxTime(context,
                                  oldMaxValue: oldMaxValue,
                                  dismissOverlayFunc: () {
                                if (overlayEntry.mounted) {
                                  overlayEntry.remove();
                                }
                              });
                            },
                            width: screenWidth * 0.2,
                            widget: TextView.title(
                              translation(context).confirm.toUpperCase(),
                                fontSize: 12.sp,
                                color: AppColors.blackColor.withValues(alpha: 0.8),
                            ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
