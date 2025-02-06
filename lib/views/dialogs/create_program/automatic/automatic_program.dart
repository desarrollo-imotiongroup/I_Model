import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/views/dialogs/create_program/automatic/create_sequence_dialog.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/tab_header_adjustment.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class AutomaticProgram extends StatelessWidget {
  const AutomaticProgram({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final ProgramsController controller = Get.put(ProgramsController());

    return Obx(
          () => Column(
        children: [
          // Name text field and status drop down
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFieldLabel(
                  label: Strings.programName2,
                  textEditingController: controller.automaticProgramNameController,
                  fontSize: 11.sp,
                ),
              ),
              // Client status drop down
              DropDownLabelWidget(
                label: Strings.equipment,
                selectedValue: controller.selectedEquipment.value,
                dropDownList: controller.equipmentOptions,
                onChanged: (value) {
                  controller.selectedEquipment.value = value;
                },
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.04),

          // Sequence Table and Create sequence button
          SizedBox(
            height: screenHeight * 0.42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sequence Table
                SizedBox(
                  width: screenWidth * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Table headers
                        Row(
                          children: [
                            tabHeaderAdjustment(context, title: Strings.order),
                            tabHeaderAdjustment(context, title: Strings.program, padding: screenWidth * 0.01),
                            tableTextInfo(title: '${Strings.duration} s.', fontSize: 10.sp),
                            tabHeaderAdjustment(context, title: Strings.adjustment, isEnd: true, padding: screenWidth * 0.01),
                            tabHeaderAdjustment(context, title: Strings.action, isEnd: true, padding: screenWidth * 0.03),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        CustomContainer(
                          height: screenHeight * 0.37,
                          width: double.infinity,
                          color: AppColors.greyColor,
                          widget: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.individualProgramSequenceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                      child: RoundedContainer(
                                        width: double.infinity,
                                        borderColor: AppColors.transparentColor,
                                        borderRadius: screenWidth * 0.006,
                                        color: AppColors.pureWhiteColor,
                                        widget: Row(
                                          children: [
                                            // Table cells info
                                            tableTextInfo(
                                              title: controller.individualProgramSequenceList[index].order.toString(),
                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                              fontSize: 10.sp,
                                            ),
                                            tableTextInfo(
                                              title: controller.individualProgramSequenceList[index].program.toString(),
                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                              fontSize: 10.sp,
                                            ),
                                            tableTextInfo(
                                              title: controller.individualProgramSequenceList[index].duration.toString(),
                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                              fontSize: 10.sp,
                                            ),
                                            tableTextInfo(
                                              title: controller.individualProgramSequenceList[index].adjustment.toString(),
                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                              fontSize: 10.sp,
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: (){
                                                  controller.removeProgram(index);
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: AppColors.redColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                SizedBox(width: screenWidth * 0.01),

                // Create sequence button
                CustomContainer(
                  onTap: (){
                    createSequenceDialog(context);
                  },
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.15,
                  borderColor: AppColors.blackColor,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.013),
                  widget: TextView.title(
                    Strings.createSequence.toUpperCase(),
                    fontSize: 12.sp,
                    color: AppColors.blackColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          // Delete and submit/check icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              imageWidget(image: Strings.removeIcon, height: screenHeight * 0.08),
              imageWidget(image: Strings.checkIcon, height: screenHeight * 0.08),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
