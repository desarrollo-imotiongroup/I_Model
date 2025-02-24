import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/menu/license_controller.dart';
import 'package:i_model/views/dialogs/license_detail_dialog.dart';
import 'package:i_model/views/overlays/maxTimeSelectionOverlay.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class LicenseScreen extends StatefulWidget {
  LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final LicenseController controller = Get.put(LicenseController());

  @override
  void dispose() {
    print('license dispose');
    // Dispose of all FocusNodes using the controller
    controller.nameFocusNode.dispose();
    controller.directionFocusNode.dispose();
    controller.cityFocusNode.dispose();
    controller.provinceFocusNode.dispose();
    controller.countryFocusNode.dispose();
    controller.phoneFocusNode.dispose();
    controller.emailFocusNode.dispose();

    // Dispose of all TextEditingControllers using the controller
    controller.licenseNumberController.dispose();
    controller.nameController.dispose();
    controller.directionController.dispose();
    controller.cityController.dispose();
    controller.provinceController.dispose();
    controller.countryController.dispose();
    controller.phoneController.dispose();
    controller.emailController.dispose();

    controller.disposeController();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: GetBuilder<LicenseController>(
        builder: (LicenseController controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Strings.bgImage,
                  ),
                  fit: BoxFit.cover),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.07,
                left: screenHeight * 0.1,
                right: screenHeight * 0.04,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// License title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextView.title(
                          translation(context).license.toUpperCase(),
                          isUnderLine: true,
                          color: AppColors.pinkColor,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
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
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    /// Row for license data and details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// License data - datos licencia
                        Column(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.53,
                              height: screenHeight * 0.75,
                              child: Column(
                                children: [
                                  TextView.title(translation(context).licenseData.toUpperCase(),
                                      isUnderLine: true,
                                      color: AppColors.pinkColor,
                                      fontSize: 13.sp),

                                  SizedBox(height: screenHeight * 0.03,),

                                  /// For TextFields in 2 rows
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          /// License Number textField
                                          TextFieldLabel(
                                            label: translation(context).licenseNo.toUpperCase(),
                                            textEditingController: controller.licenseNumberController,
                                            fontSize: 12.sp,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.nameFocusNode);
                                            },
                                          ),

                                          /// Name textField
                                          TextFieldLabel(
                                            label: translation(context).name.toUpperCase(),
                                            textEditingController: controller.nameController,
                                            fontSize: 12.sp,
                                            focusNode: controller.nameFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.directionFocusNode);
                                            },
                                          ),

                                          /// Direction/address textField
                                          TextFieldLabel(
                                            label: translation(context).address.toUpperCase(),
                                            textEditingController: controller.directionController,
                                            fontSize: 12.sp,
                                            focusNode: controller.directionFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.cityFocusNode);
                                            },
                                          ),

                                          /// City textField
                                          TextFieldLabel(
                                            label: translation(context).city.toUpperCase(),
                                            textEditingController: controller.cityController,
                                            fontSize: 12.sp,
                                            focusNode: controller.cityFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.provinceFocusNode);
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          /// Province textField
                                          TextFieldLabel(
                                            label: translation(context).province.toUpperCase(),
                                            textEditingController: controller.provinceController,
                                            fontSize: 12.sp,
                                            focusNode: controller.provinceFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.countryFocusNode);
                                            },
                                          ),

                                          /// Country textField
                                          TextFieldLabel(
                                            label: translation(context).country.toUpperCase(),
                                            textEditingController: controller.countryController,
                                            fontSize: 12.sp,
                                            focusNode: controller.countryFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.phoneFocusNode);
                                            },
                                          ),

                                          ///  Telephone textField
                                          TextFieldLabel(
                                            label: translation(context).phone.toUpperCase(),
                                            textEditingController: controller.phoneController,
                                            fontSize: 12.sp,
                                            isAllowNumberOnly: true,
                                            focusNode: controller.phoneFocusNode,
                                            onNext: () {
                                              controller.moveFocusTo(context, controller.emailFocusNode);
                                            },
                                          ),

                                          /// Email textField
                                          TextFieldLabel(
                                            label: translation(context).email.toUpperCase(),
                                            textEditingController: controller.emailController,
                                            fontSize: 12.sp,
                                            textInputAction: TextInputAction.done,
                                            focusNode: controller.emailFocusNode,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.06,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundedContainer(
                                          onTap: () {
                                            controller.validarLicencia(context);
                                          },
                                          borderRadius: screenHeight * 0.01,
                                          width: screenWidth * 0.2,
                                          widget: TextView.title(
                                            translation(context).validateLicense.toUpperCase(),
                                            color: AppColors.blackColor,
                                            fontSize: 14.sp,
                                          )
                                      ),
                                      Obx(() =>
                                      controller.mcis.isNotEmpty
                                          ? Padding(padding: EdgeInsets.only(left: screenWidth * 0.02),
                                        child: TextView.title(
                                            translation(context).validLicense.toUpperCase(),
                                            color: Colors.green,
                                            fontSize: 12.sp
                                        ),
                                      )
                                          : SizedBox()
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        /// License numbers - N licencia
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screenWidth * 0.02
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.75,
                                    child: Column(
                                      children: [
                                        TextView.title(
                                          translation(context).licenseNumber.toUpperCase(),
                                          isUnderLine: true,
                                          color: AppColors.pinkColor,
                                          fontSize: 13.sp,
                                        ),
                                        SizedBox(height: screenHeight * 0.04,),

                                        /// Table header
                                        SizedBox(
                                          width: screenWidth * 0.26,
                                          child: Row(
                                            children: [
                                              tableTextInfo(title: translation(context).mci),
                                              tableTextInfo(title: translation(context).type),
                                              tableTextInfo(title: translation(context).status),
                                            ],
                                          ),
                                        ),

                                        Obx(() =>
                                            CustomContainer(
                                                color: AppColors.greyColor,
                                                width: screenWidth * 0.3,
                                                height: screenHeight * 0.6,
                                                widget: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller.mcis.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return  GestureDetector(
                                                      onTap: () async {
                                                        // controller.selectedStatus.value =
                                                        //     controller.mciLicenseList[index].status.value;
                                                        //
                                                        // licenseDetailDialog(
                                                        //   context,
                                                        //   index: index,
                                                        // );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: screenHeight * 0.01,
                                                            ),
                                                            child: RoundedContainer(
                                                                width: screenWidth * 0.3,
                                                                borderColor: AppColors.transparentColor,
                                                                borderRadius: screenWidth * 0.006,
                                                                color: AppColors.pureWhiteColor,
                                                                widget: Row(
                                                                  children: [
                                                                    /// Table cells info
                                                                    tableTextInfo(
                                                                      title: controller.mcis[index]['mac'],
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 8.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.mcis[index]['macBle'] == true
                                                                      ? 'BLE'
                                                                      : 'BT',
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.licenseStatus.value,
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
                                                )
                                            )
                                        )

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /// Setting button for max time selection
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: screenHeight * 0.03
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  maxTimeSelectionOverlay(context);
                                },
                                child: Icon(
                                    Icons.settings,
                                    color: AppColors.blackColor,
                                    size: screenHeight * 0.05,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
