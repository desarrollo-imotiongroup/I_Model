import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/overlay/box_decoration.dart';
import 'package:i_model/widgets/overlay/top_title_button.dart';
import 'package:i_model/widgets/textfield_label.dart';

void createSequenceDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ProgramsController controller = Get.put(ProgramsController());

  Widget textFieldWidget({
    required String label,
    required TextEditingController textEditingController,
    bool isDone = false,
    bool isUnitNeeded = false,
  }) {
    return TextFieldLabel(
      width: screenWidth * 0.15,
      label: label,
      textEditingController: textEditingController,
      isAllowNumberOnly: true,
      fontSize: 11.sp,
      unit: isUnitNeeded ? ' s.' : '',
      textInputAction: !isDone ? TextInputAction.next : TextInputAction.done,
    );
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.6,
          height: screenHeight * 0.5,
          decoration: boxDecoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  TopTitleButton(title:  Strings.createSequence),
                  Divider(color: AppColors.pinkColor),

                  SizedBox(
                    height: screenHeight * 0.38,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() =>
                              /// Select program drop down
                              DropDownWidget(
                                selectedValue: controller.selectedProgram.value,
                                dropDownList: controller.individualProgramOptionList,
                                onChanged: (value){
                                  controller.selectedProgram.value = value;
                                },
                              ),
                              ),
                              SizedBox(height: screenHeight * 0.02,),
                              /// Row for remaining text fields
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textFieldWidget(
                                    label: Strings.order,
                                    textEditingController: controller.orderController,
                                  ),
                                  textFieldWidget(
                                      label: Strings.duration,
                                      textEditingController: controller.durationController,
                                      isUnitNeeded: true
                                  ),
                                  textFieldWidget(
                                      label: Strings.adjustment,
                                      textEditingController: controller.adjustmentController,
                                      isDone: true
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /// Check / submit icon
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: (){
                              controller.createSequence(context);
                            },
                            child: imageWidget(
                                image: Strings.checkIcon,
                                height: screenHeight * 0.08
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
