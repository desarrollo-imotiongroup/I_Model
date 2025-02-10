import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield_label.dart';

class Cronaxia extends StatelessWidget {
  const Cronaxia({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final ProgramsController controller = Get.put(ProgramsController());

    Widget cronaxiaTextField({
      required String label,
      required TextEditingController textEditingController,
      bool isDone = false,
    }){
      return TextFieldLabel(
        width: screenWidth * 0.12,
        label: label,
        textEditingController: textEditingController,
        isAllowNumberOnly: true,
        fontSize: 11.sp,
        unit: ' (ms)',
        textInputAction: !isDone ? TextInputAction.next : TextInputAction.done,
        isReadOnly: controller.pulseController.text == '' ? false : true,
      );
    }


    return Obx(() =>
        Column(
          children: [
            /// Program name text field and equipment drop down
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFieldLabel(
                    label: translation(context).programName2,
                    textEditingController: controller.individualProgramNameController,
                    fontSize: 11.sp,
                    isReadOnly: true,
                  ),
                ),

                /// Client status drop down
                DropDownLabelWidget(
                  label: translation(context).equipment,
                  selectedValue: controller.selectedEquipment.value,
                  dropDownList: controller.equipmentOptions,
                  onChanged: (value){
                    controller.selectedEquipment.value = value;
                  },
                  isEnable: false,
                )
              ],
            ),

            SizedBox(height: screenHeight * 0.01,),

            ///  TextFields
            Expanded(
              child: Padding(
                  padding:  EdgeInsets.only(
                    top: screenHeight * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// TextFields 1st column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Upper back text field
                          cronaxiaTextField(
                            label: Strings.upperBack,
                            textEditingController: controller.upperBackController,
                          ),
                          SizedBox(height: screenHeight * 0.01,),

                          /// Pulse text field
                          cronaxiaTextField(
                            label: Strings.middleBack,
                            textEditingController: controller.middleBackController,
                          ),
                        ],
                      ),

                      /// TextFields 2nd column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Lower back text field / Lumbares
                          cronaxiaTextField(
                            label: Strings.lowerBack,
                            textEditingController: controller.lowerBackController,
                          ),
                          SizedBox(height: screenHeight * 0.01,),

                          /// Glutes text field
                          cronaxiaTextField(
                            label: Strings.glutes,
                            textEditingController: controller.glutesController,
                          ),
                        ],
                      ),

                      /// TextFields 3rd column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Hamstrings text field / Isquios
                          cronaxiaTextField(
                            label: Strings.hamstrings,
                            textEditingController: controller.hamstringsController,
                          ),
                          SizedBox(height: screenHeight * 0.01,),

                          /// Chest text field / Pecho
                          cronaxiaTextField(
                            label: Strings.chest,
                            textEditingController: controller.chestController,
                          ),
                        ],
                      ),

                      /// TextFields 4th column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Abdomen text field
                          cronaxiaTextField(
                            label: Strings.abdomen,
                            textEditingController: controller.abdomenController,
                          ),
                          SizedBox(height: screenHeight * 0.01,),

                          /// Legs text field / Piernas
                          cronaxiaTextField(
                            label: Strings.legs,
                            textEditingController: controller.legsController,
                          ),
                        ],
                      ),

                      /// TextFields 5th column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Arms text field / Brazos
                          cronaxiaTextField(
                            label: Strings.arms,
                            textEditingController: controller.armsController,
                          ),
                          SizedBox(height: screenHeight * 0.01,),

                          /// Extra text field
                          cronaxiaTextField(
                              label: Strings.extra,
                              textEditingController: controller.extraController,
                              isDone: true
                          ),
                        ],
                      ),
                    ],
                  )

              ),
            ),

            SizedBox(height: screenHeight * 0.01,),

            /// delete and submit/check icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                imageWidget(
                    image: Strings.removeIcon,
                    height: screenHeight * 0.08
                ),
                imageWidget(
                    image: Strings.checkIcon,
                    height: screenHeight * 0.08
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03,)
          ],
        ),
    );
  }
}
