import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/views/overlays/automatic_program_overlay.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/top_title_button.dart';
import 'package:i_model/widgets/tab_header_adjustment.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';



void selectedAutomaticProgramDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ProgramsController controller = Get.put(ProgramsController());

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.85,
          decoration: boxDecoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: SingleChildScrollView( // Only one scroll view to handle the content
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  TopTitleButton(title: translation(context).automaticProgrammes),
                  Divider(color: AppColors.pinkColor),

                  SizedBox(height: screenHeight * 0.02,),

                  /// Selected program details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          /// Selected program image
                          imageWidget(
                              image: controller.selectedProgramImage.value,
                              height: screenHeight * 0.15
                          ),
                          SizedBox(width: screenWidth * 0.02,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Selected program name
                              TextView.title(
                                  '${controller.selectedProgramName.value} - 25 min'.toUpperCase(),
                                  color: AppColors.pinkColor,
                                  fontSize: 12.sp
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              /// Selected program description
                              SizedBox(
                                width: screenWidth * 0.35,
                                child: TextView.title(
                                    translation(context).selectedProgramDescription,
                                    color: AppColors.blackColor.withValues(alpha: 0.8),
                                    fontSize: 10.sp,
                                    lines: 2
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          automaticProgramOverlay(context, programList: controller.automaticProgramsList);
                        },
                        child: Image(
                          image: AssetImage(
                            Strings.backIcon,
                          ),
                          height: screenHeight * 0.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03,), // Adjust space here as needed

                  /// Table headers
                  Row(
                    children: [
                      tabHeaderAdjustment(context, title: translation(context).order),
                      tabHeaderAdjustment(
                          context,
                          title: translation(context).program,
                          padding: screenWidth * 0.01,
                      ),
                      tableTextInfo(
                        title: translation(context).duration,
                        fontSize: 10.sp,
                      ),
                      tabHeaderAdjustment(
                          context,
                          title: translation(context).adjustment,
                          isEnd: true,
                          padding: screenWidth * 0.02,
                      )
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005,),
                  CustomContainer(
                    height: screenHeight * 0.48,
                    width: double.infinity,
                    color: AppColors.greyColor,
                    widget: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.selectedProgramDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: RoundedContainer(
                              width: double.infinity,
                              borderColor: AppColors.transparentColor,
                              borderRadius: screenWidth * 0.006,
                              color: AppColors.pureWhiteColor,
                              widget: Row(
                                children: [
                                  /// Table cells info
                                  tableTextInfo(
                                    title: controller.selectedProgramDetails[index].order.toString(),
                                    color: AppColors.blackColor.withValues(alpha: 0.8),
                                    fontSize: 10.sp,
                                  ),
                                  tableTextInfo(
                                    title: controller.selectedProgramDetails[index].name,
                                    color: AppColors.pinkColor,
                                    fontSize: 11.sp,
                                  ),
                                  tableTextInfo(
                                    title: controller.selectedProgramDetails[index].duration.toString(),
                                    color: AppColors.blackColor.withValues(alpha: 0.8),
                                    fontSize: 10.sp,
                                  ),
                                  tableTextInfo(
                                    title: controller.selectedProgramDetails[index].adjustment.toString(),
                                    color: AppColors.blackColor.withValues(alpha: 0.8),
                                    fontSize: 10.sp,
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03), // Add space below the table content
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
