import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/client_controller.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield_label.dart';

class ClientPersonalData extends StatefulWidget {
  const ClientPersonalData({super.key});

  @override
  State<ClientPersonalData> createState() => _ClientPersonalDataState();
}

class _ClientPersonalDataState extends State<ClientPersonalData> {
  final ClientController controller = Get.put(ClientController());

  @override
  void initState() {
    controller.refreshControllers();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;

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
                    fontSize: 11.sp,
                  ),
                ),

                /// Client status drop down
                DropDownWidget(
                  selectedValue: controller.fetchedStatus.value,
                  dropDownList: controller.statusList,
                  onChanged: (value){
                    controller.fetchedStatus.value = value;
                  },
                )
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.015,),
          ///  TextFields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// TextFields 1st column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Gender text field
                  SizedBox(height: screenHeight * 0.025,),

                  DropDownLabelWidget(
                      selectedValue: controller.clientSelectedGender.value,
                      dropDownList: controller.genderList,
                      onChanged: (value){
                        controller.clientSelectedGender.value = value;
                      },
                      label: translation(context).gender
                  ),
                  SizedBox(height: screenHeight * 0.02,),

                  /// Birth date text field
                  GestureDetector(
                    onTap: (){
                      controller.pickBirthDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFieldLabel(
                        label: translation(context).birthDate,
                        textEditingController: controller.clientDobController,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01,),

                  /// Phone text field
                  TextFieldLabel(
                    label: translation(context).phone,
                    textEditingController: controller.clientPhoneController,
                    isAllowNumberOnly: true,
                    fontSize: 11.sp,
                    onNext: (){
                      FocusScope.of(context).requestFocus(controller.heightFocusNode);
                    },
                  )
                ],
              ),

              /// TextFields 2nd column
              Column(
                children: [
                  /// Height text field
                  TextFieldLabel(
                    label: translation(context).height,
                    textEditingController: controller.clientHeightController,
                    isAllowNumberOnly: true,
                    fontSize: 11.sp,
                    focusNode: controller.heightFocusNode,
                    onNext: (){
                      FocusScope.of(context).requestFocus(controller.weightFocusNode);
                    },
                  ),

                  SizedBox(height: screenHeight * 0.01,),

                  /// Weight text field
                  TextFieldLabel(
                    label: translation(context).weight,
                    textEditingController: controller.clientWeightController,
                    isAllowNumberOnly: true,
                    fontSize: 11.sp,
                    focusNode: controller.weightFocusNode,
                    onNext: (){
                      FocusScope.of(context).requestFocus(controller.emailFocusNode);
                    },
                  ),

                  SizedBox(height: screenHeight * 0.01,),

                  /// Email text field
                  TextFieldLabel(
                    label: translation(context).email,
                    textEditingController: controller.clientEmailController,
                    textInputAction: TextInputAction.done,
                    fontSize: 11.sp,
                    focusNode: controller.emailFocusNode,
                  )
                ],
              )
            ],
          ),

          SizedBox(height: screenHeight * 0.02,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  alertOverlay(context,
                      heading: Strings.delete,
                      description: Strings.confirmDeleteClient,
                      buttonText: Strings.yesSure,
                      onPress: (){
                              controller.deleteClient(context);
                              Navigator.pop(context);

                  }
                  );
                },
                child: imageWidget(
                    image: Strings.removeIcon,
                    height: screenHeight * 0.08
                ),
              ),
              GestureDetector(
                onTap: (){
                  controller.updateData(context);
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
