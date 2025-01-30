import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/menu/license_controller.dart';
import 'package:i_model/widgets/overlay/license_detail_overlay.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class LicenseScreen extends StatelessWidget {
  LicenseScreen({super.key});

  final LicenseController controller = Get.put(LicenseController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
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
                /// License
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView.title(
                      translation(context).license,
                      isUnderLine: true,
                      color: AppColors.pinkColor,
                    ),
                    GestureDetector(
                      onTap: () {
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
                              TextView.title(Strings.licenseData.toUpperCase(),
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
                                        label: Strings.licenseNo.toUpperCase(),
                                        textEditingController: controller.licenseNumberController,
                                        isAllowNumberOnly: true,
                                        fontSize: 12.sp,
                                      ),

                                      /// Name textField
                                      TextFieldLabel(
                                        label: Strings.name.toUpperCase(),
                                        textEditingController: controller.nameController,
                                        fontSize: 12.sp,
                                      ),

                                      /// Direction/address textField
                                      TextFieldLabel(
                                        label: Strings.address.toUpperCase(),
                                        textEditingController: controller.addressController,
                                        fontSize: 12.sp,
                                      ),

                                      /// City textField
                                      TextFieldLabel(
                                        label: Strings.city.toUpperCase(),
                                        textEditingController: controller.cityController,
                                        fontSize: 12.sp,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      /// Province textField
                                      TextFieldLabel(
                                        label: Strings.province.toUpperCase(),
                                        textEditingController: controller.provinceController,
                                        fontSize: 12.sp,
                                      ),

                                      /// Country textField
                                      TextFieldLabel(
                                        label: Strings.country.toUpperCase(),
                                        textEditingController: controller.countryController,
                                        fontSize: 12.sp,
                                      ),

                                      ///  Telephone textField
                                      TextFieldLabel(
                                        label: Strings.phone.toUpperCase(),
                                        textEditingController: controller.phoneController,
                                        fontSize: 12.sp,
                                        isAllowNumberOnly: true,
                                      ),

                                      /// Email textField
                                      TextFieldLabel(
                                        label: Strings.email.toUpperCase(),
                                        textEditingController: controller.emailController,
                                        fontSize: 12.sp,
                                        textInputAction: TextInputAction.done,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.06,),

                              RoundedContainer(
                                  onTap: (){
                                    controller.validateLicense();
                                  },
                                  borderRadius: screenHeight * 0.01,
                                  width: screenWidth * 0.2,
                                  widget: TextView.title(
                                    Strings.validateLicense.toUpperCase(),
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                  )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    /// License numbers - N licencia
                    Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth * 0.05
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.75,
                            child: Column(
                              children: [
                                TextView.title(
                                    Strings.licenseNumber.toUpperCase(),
                                    isUnderLine: true,
                                    color: AppColors.pinkColor,
                                    fontSize: 13.sp,
                                ),
                                SizedBox(height: screenHeight * 0.05,),

                                /// Table header
                                SizedBox(
                                  width: screenWidth * 0.26,
                                  child: Row(
                                    children: [
                                      tableTextInfo(title: Strings.mci),
                                      tableTextInfo(title: Strings.type),
                                      tableTextInfo(title: Strings.status),
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
                                          itemCount: controller.mciLicenseList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return  GestureDetector(
                                              onTap: (){
                                                licenseDetailOverlay(context);
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
                                                              title: controller.mciLicenseList[index].mci,
                                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                                              fontSize: 10.sp,
                                                            ),
                                                            tableTextInfo(
                                                              title: controller.mciLicenseList[index].type.toUpperCase(),
                                                              color: AppColors.blackColor.withValues(alpha: 0.8),
                                                              fontSize: 10.sp,
                                                            ),
                                                            tableTextInfo(
                                                              title: controller.mciLicenseList[index].status.toUpperCase(),
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
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
