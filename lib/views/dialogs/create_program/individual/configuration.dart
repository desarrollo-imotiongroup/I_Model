import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/programs_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/text_field_image.dart';
import 'package:i_model/widgets/textfield_label.dart';

class Configuration extends StatelessWidget {

  const Configuration({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final ProgramsController controller = Get.put(ProgramsController());

    return  Column(
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
              ),
            ),

            /// Client status drop down
            Obx(() =>
                DropDownLabelWidget(
                  label: translation(context).equipment,
                  selectedValue: controller.selectedEquipment.value,
                  dropDownList: controller.equipmentOptions,
                  onChanged: (value){
                    controller.selectedEquipment.value = value;
                  },
                ),)
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
                    /// Frequency text field
                    TextFieldLabel(
                      width: screenWidth * 0.15,
                      label: translation(context).frequency,
                      textEditingController: controller.frequencyController,
                      isAllowNumberOnly: true,
                      fontSize: 11.sp,
                      unit: ' (Hz)',
                      onNext: () {
                        controller.moveFocusTo(context, controller.pulseFocusNode);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01,),

                    /// Pulse text field
                    TextFieldLabel(
                      width: screenWidth * 0.15,
                      label: translation(context).pulse,
                      unit: ' (ms)',
                      textEditingController: controller.pulseController,
                      isAllowNumberOnly: true,
                      fontSize: 11.sp,
                      onNext: () {
                        controller.moveFocusTo(context, controller.rampFocusNode);
                      },
                      focusNode: controller.pulseFocusNode,
                    )
                  ],
                ),

                /// TextFields 2nd column
                Column(
                  children: [
                    /// Ramp text field
                    TextFieldImage(
                        icon: Strings.rampIcon,
                        label: translation(context).ramp,
                        unit: ' (sx10)',
                        textEditingController: controller.rampController,
                      onNext: () {
                        controller.moveFocusTo(context, controller.contractionFocusNode);
                      },
                      focusNode: controller.rampFocusNode,
                    ),

                    /// Contraction text field
                    TextFieldImage(
                      icon: Strings.contractionIcon,
                      label: translation(context).contraction,
                      unit: ' (s.)',
                      textEditingController: controller.contractionController,
                      textInputAction: TextInputAction.done,
                      onNext: () {
                        controller.moveFocusTo(context, controller.pauseFocusNode);
                      },
                      focusNode: controller.contractionFocusNode,
                    ),
                  ],
                ),

                /// TextFields 3rd column
                Column(
                  children: [
                    /// Pause text field
                    TextFieldImage(
                      icon: Strings.pauseProgramIcon,
                      label: translation(context).pause,
                      unit: ' (s.)',
                      textEditingController: controller.pauseController,
                      focusNode: controller.pauseFocusNode,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01,),

        /// delete and submit/check icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Container(),
            GestureDetector(
              onTap: (){
                controller.setCronaxiaTextFieldsValues();
                controller.createProgramAndSave(context);
              },
              child: imageWidget(
                  image: Strings.checkIcon,
                  height: screenHeight * 0.08
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.03,)
      ],
    );
  }
}
