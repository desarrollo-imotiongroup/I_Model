import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/overlay/box_decoration.dart';
import 'package:i_model/widgets/overlay/top_title_button.dart';
import 'package:i_model/widgets/table_text_info.dart';

void individualProgramsOverlay(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;

  final ProgramsController controller = Get.put(ProgramsController());

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.85, // Ensure overlays height remains fixed
          decoration: boxDecoration(context),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                child: TopTitleButton(
                  title: Strings.individuals,
                  onCancel: (){
                    if (overlayEntry.mounted) {
                      overlayEntry.remove();
                    }
                },),
              ),

              Divider(color: AppColors.pinkColor),

              SizedBox(height: screenHeight * 0.02,),

              /// Table data
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.02
                  ),
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// Table headers
                          Row(
                            children: [
                              Expanded(child: Container()),
                              tableTextInfo(
                                title: Strings.programName,
                                fontSize: 10.sp,
                                lines: 2
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width: screenWidth * 0.01,),
                                    tableTextInfo(
                                      title: Strings.frequency,
                                      fontSize: 10.sp,
                                    ),
                                  ],
                                ),
                              ),
                              tableTextInfo(
                                title: Strings.pulse,
                                fontSize: 10.sp,
                                lines: 2
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    tableTextInfo(
                                      title: Strings.ramp,
                                      fontSize: 10.sp,
                                    ),
                                    SizedBox(width: screenWidth * 0.01,)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    tableTextInfo(
                                      title: Strings.contraction,
                                      fontSize: 10.sp,
                                    ),
                                    SizedBox(width: screenWidth * 0.01,)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    tableTextInfo(
                                      title: Strings.pause,
                                      fontSize: 10.sp,
                                    ),
                                    SizedBox(width: screenWidth * 0.03,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.005,),
                          CustomContainer(
                            height: screenHeight * 0.8,
                            width: double.infinity,
                            color: AppColors.greyColor,
                            widget: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: controller.individualProgramsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return  GestureDetector(
                                  onTap: (){},
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                        ),
                                        child: RoundedContainer(
                                            width: double.infinity,
                                            borderColor: AppColors.transparentColor,
                                            borderRadius: screenWidth * 0.006,
                                            color: AppColors.greyColor,
                                            widget: Row(
                                              children: [
                                                /// Table cells info
                                                imageWidget(
                                                  image: controller.individualProgramsList[index].image,
                                                  height: screenHeight * 0.1,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].name,
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].frequency.toString(),
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].pulse.toString(),
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].ramp.toString(),
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].contraction.toString(),
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                                tableTextInfo(
                                                  title: controller.individualProgramsList[index].pause.toString(),
                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                  fontSize: 10.sp,
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}

