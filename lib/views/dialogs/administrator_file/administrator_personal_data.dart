import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/administrator_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class AdministratorPersonalData extends StatelessWidget {
  const AdministratorPersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final AdministratorController controller = Get.put(AdministratorController());

    return Obx(
          () => Column(
        children: [
          /// Nick text field and status drop down
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFieldLabel(
                    label: Strings.nick,
                    textEditingController: controller.nickNameController,
                    fontSize: 11.sp,
                  ),
                ),

                /// Client status drop down
                DropDownWidget(
                  selectedValue: controller.selectedStatus.value,
                  dropDownList: controller.statusOptions,
                  onChanged: (value){
                    controller.selectedStatus.value = value;
                  },
                )
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01,),
          ///  TextFields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// TextFields 1st column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name text field
                  TextFieldLabel(
                    width: screenWidth * 0.2,
                    label: Strings.name,
                    textEditingController: controller.perDataNameController,
                    fontSize: 11.sp,
                  ),

                  /// Gender text field
                  SizedBox(height: screenHeight * 0.02,),
                  DropDownLabelWidget(
                      width: screenWidth * 0.2,
                      selectedValue: controller.selectedGender.value,
                      dropDownList: controller.genderOptions,
                      onChanged: (value){
                        controller.selectedGender.value = value;
                      },
                      label: Strings.gender
                  ),

                  SizedBox(height: screenHeight * 0.02,),
                  /// Birth date text field
                  GestureDetector(
                    onTap: () async {
                      controller.pickBirthDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFieldLabel(
                        width: screenWidth * 0.2,
                        label: Strings.birthDate,
                        textEditingController: controller.birthDateController,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),

                ],
              ),

              /// TextFields 2nd column
              Column(
                children: [
                  /// Profile drop down
                  DropDownLabelWidget(
                      width: screenWidth * 0.2,
                      selectedValue: controller.selectedProfile.value,
                      dropDownList: controller.profileOptions,
                      onChanged: (value){
                        controller.selectedProfile.value = value;
                      },
                      label: Strings.profile
                  ),

                  SizedBox(height: screenHeight * 0.035,),

                  /// Session control drop down
                  DropDownLabelWidget(
                      width: screenWidth * 0.2,
                      selectedValue: controller.selectedSessionControl.value,
                      dropDownList: controller.sessionControlOptions,
                      onChanged: (value){
                        controller.selectedSessionControl.value = value;
                      },
                      label: Strings.sessionControl
                  ),
                  SizedBox(height: screenHeight * 0.035,),

                  /// Time control drop down
                  DropDownLabelWidget(
                      width: screenWidth * 0.2,
                      selectedValue: controller.selectedTimeControl.value,
                      dropDownList: controller.timeControlOptions,
                      onChanged: (value){
                        controller.selectedTimeControl.value = value;
                      },
                      label: Strings.timeControl
                  ),
                ],
              ),

              /// TextFields 3rd column
              Column(
                children: [
                  /// Registration date
                  GestureDetector(
                    onTap: (){
                      controller.pickRegistrationDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFieldLabel(
                        width: screenWidth * 0.2,
                        label: Strings.registrationDate,
                        textEditingController: controller.registrationDateController,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035,),
                  /// Registration date
                  RoundedContainer(
                      borderRadius: screenHeight * 0.01,
                      width: screenWidth * 0.15,
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.013
                      ),
                      widget: TextView.title(
                          Strings.resetPassword.toUpperCase(),
                          fontSize: 12.sp,
                          color: AppColors.blackColor.withValues(alpha: 0.8)
                      ))
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02,),

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
          )
        ],
      ),
    );
  }
}
