import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/button.dart';
import 'package:i_model/widgets/textview.dart';

void selectProgramOverlay(
  BuildContext context, {
  required final String title,
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  bool isIndividual = true;
  final DashboardController controller = Get.put(DashboardController()); // Initialize the controller


  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.45,
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
          child: Wrap(
            children: [
              Column(
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
                                title.toUpperCase(),
                                isUnderLine: true,
                                color: AppColors.pinkColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (overlayEntry.mounted) {
                            overlayEntry.remove();
                          }
                        },
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
                  SizedBox(height: screenHeight * 0.02,),
                  Obx(() => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02
                    ),
                    child: Column(
                      children: [
                        /// Individual
                        ListTile(
                          textColor: AppColors.pinkColor,
                          title: TextView.title(
                              Strings.individual.toUpperCase(),
                              color: AppColors.pinkColor,
                              fontSize: 14.sp
                          ),
                          leading: Transform.scale(
                            scale: 1.3,
                            child: Radio<String>(
                              value: Strings.individual,
                              fillColor: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return AppColors.pinkColor; // Active color
                                  }
                                  return AppColors.darkGrey; // Inactive color
                                },
                              ),
                              groupValue: controller.selectedProgramType.value,
                              onChanged: (String? value) {
                                controller.selectedProgramType.value = value!;
                                isIndividual = true;
                              },
                            ),
                          )
                        ),

                        /// Automaticos
                        ListTile(
                          title: TextView.title(
                              Strings.automatics.toUpperCase(),
                              color: AppColors.pinkColor,
                              fontSize: 14.sp
                          ),
                          leading: Transform.scale(
                          scale: 1.3,
                          child: Radio<String>(
                            value: Strings.automatics,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.pinkColor; // Active color
                                }
                                return AppColors.darkGrey; // Inactive color
                              },
                            ),
                            groupValue: controller.selectedProgramType.value,
                            onChanged: (String? value) {
                              controller.selectedProgramType.value = value!;
                              isIndividual = false;

                            },
                          ),
                        ),
                        ),

                        SizedBox(height: screenHeight * 0.02,),

                        /// Select button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Button(
                            onTap: (){
                              if(isIndividual){
                                controller.changeProgramType(isIndividual: false);
                              }
                              else{
                                controller.changeProgramType(isIndividual: true);
                              }

                              if (overlayEntry.mounted) {
                                overlayEntry.remove();
                              }
                            },
                            text: Strings.select.toUpperCase(),
                            btnColor: AppColors.pinkColor,
                            width: screenWidth * 0.15,
                            borderRadius: screenWidth * 0.007,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03,)
                      ],
                    ),
                  ),),



                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
