import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/create_profile_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield_label.dart';

class CreatePersonalData extends StatelessWidget {
  const CreatePersonalData({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final CreateProfileController controller = Get.put(CreateProfileController());

    return  Obx(
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
                    label: translation(context).nick,
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
                    label: translation(context).name,
                    textEditingController: controller.nameController,
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
                      label: translation(context).gender
                  ),

                  SizedBox(height: screenHeight * 0.02,),
                  /// Phone text field
                  TextFieldLabel(
                    width: screenWidth * 0.2,
                    label: translation(context).phone,
                    textEditingController: controller.phoneController,
                    fontSize: 11.sp,
                    isAllowNumberOnly: true,
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
                      label: translation(context).profile
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
                      label: translation(context).sessionControl
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
                      label: translation(context).timeControl
                  ),
                ],
              ),

              /// TextFields 3rd column
              Column(
                children: [
                  /// Registration date
                  GestureDetector(
                    onTap: (){
                      controller.createProfilePickRegistrationDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFieldLabel(
                        width: screenWidth * 0.2,
                        label: translation(context).registrationDate,
                        textEditingController: controller.registrationDateController,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  /// Birth date text field
                  GestureDetector(
                    onTap: () async {
                      controller.createProfilePickBirthDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFieldLabel(
                        width: screenWidth * 0.2,
                        label: translation(context).birthDate,
                        textEditingController: controller.birthDateController,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035,),
                  // /// Reset password
                  // RoundedContainer(
                  //     onTap: (){
                  //       resetPasswordOverlay(context);
                  //     },
                  //     borderRadius: screenHeight * 0.01,
                  //     width: screenWidth * 0.2,
                  //     padding: EdgeInsets.symmetric(
                  //         vertical: screenHeight * 0.013
                  //     ),
                  //     widget: TextView.title(
                  //         translation(context).resetPassword.toUpperCase(),
                  //         fontSize: 11.sp,
                  //         color: AppColors.blackColor.withValues(alpha: 0.8)
                  //     )),
                ],
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              GestureDetector(
                onTap: (){
                  controller.collectUserData(context);
                },
                child: imageWidget(
                    image: Strings.checkIcon,
                    height: screenHeight * 0.08
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
