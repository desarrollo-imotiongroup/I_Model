import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/client_controller.dart';
import 'package:i_model/widgets/active_group_icon.dart';
import 'package:i_model/widgets/check_box.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield_label.dart';

class ClientActiveGroups extends StatelessWidget {
  const ClientActiveGroups({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double screenWidth = mediaQuery.size.width;
    final ClientController controller = Get.put(ClientController());

    return Obx(
          () => Column(
        children: [
          /// Name text field and status drop down
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFieldLabel(
                    label: translation(context).name,
                    textEditingController: controller.clientNameController,
                    isReadOnly: true,
                    fontSize: 11.sp,
                  ),
                ),

                /// Client status drop down
                DropDownWidget(
                  selectedValue: controller.selectedStatus.value,
                  dropDownList: controller.clientStatusList,
                  isEnable: false,
                  onChanged: (value){
                    controller.selectedStatus.value = value;
                  },
                )
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.02,),

          Expanded(
            child: SizedBox(
              width: screenWidth * 0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          /// Upper back
                          CheckBox(
                            title: Strings.upperBack,
                            isChecked: controller.isUpperBackChecked.value,
                            onTap: (){
                              controller.toggleUpperBack();
                            },),

                          /// Middle back
                          CheckBox(
                            title: Strings.middleBack,
                            isChecked: controller.isMiddleBackChecked.value,
                            onTap: (){
                              controller.toggleMiddleBack();
                            },),

                          /// Lumbares / lower back
                          CheckBox(
                            title: Strings.lowerBack,
                            isChecked: controller.isLowerBackChecked.value,
                            onTap: (){
                              controller.toggleLowerBack();
                            },),

                          /// Glutes
                          CheckBox(
                            title: Strings.glutes,
                            isChecked: controller.isGlutesChecked.value,
                            onTap: (){
                              controller.toggleGlutes();
                            },),

                          /// hamstrings / Isquios
                          CheckBox(
                            title: Strings.hamstrings,
                            isChecked: controller.isHamstringsChecked.value,
                            onTap: (){
                              controller.toggleHamstrings();
                            },),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.05,),
                      Stack(
                        children: [
                          // First image widget
                          imageWidget(
                            image: Strings.avatarBackViewIcon,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.espaldaAlta,
                            isChecked: controller.isUpperBackChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.espaldaMedia,
                            isChecked: controller.isMiddleBackChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.lumbaresIcon,
                            isChecked: controller.isLowerBackChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.gluteosIcon,
                            isChecked: controller.isGlutesChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.isquiosIcon,
                            isChecked: controller.isHamstringsChecked.value,
                          ),
                        ],
                      )


                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          imageWidget(
                              image: Strings.avatarFrontViewIcon
                          ),
                          ActiveGroupIcon(
                            icon: Strings.pechoIcon,
                            isChecked: controller.isChestChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.abdomenBodyIcon,
                            isChecked: controller.isAbdominalChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.piernasIcon,
                            isChecked: controller.isLegsChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.brazosIcon,
                            isChecked: controller.isArmsChecked.value,
                          ),
                          ActiveGroupIcon(
                            icon: Strings.extraIcon,
                            isChecked: controller.isExtraChecked.value,
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.05,),
                      Column(
                        children: [
                          /// Chest / pecho
                          CheckBox(
                            title: Strings.chest,
                            isChecked: controller.isChestChecked.value,
                            onTap: (){
                              controller.toggleChest();
                            },),

                          /// Abdominal
                          CheckBox(
                            title: Strings.abdominals,
                            isChecked: controller.isAbdominalChecked.value,
                            onTap: (){
                              controller.toggleAbdominal();
                            },),

                          /// Arms / Brazos
                          CheckBox(
                            title: Strings.arms,
                            isChecked: controller.isArmsChecked.value,
                            onTap: (){
                              controller.toggleArms();
                            },),

                          /// Legs / piernas
                          CheckBox(
                            title: Strings.legs,
                            isChecked: controller.isLegsChecked.value,
                            onTap: (){
                              controller.toggleLegs();
                            },),


                          /// Extra
                          CheckBox(
                            title: translation(context).extra,
                            isChecked: controller.isExtraChecked.value,
                            onTap: (){
                              controller.toggleExtra();
                            },),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.01,),
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
