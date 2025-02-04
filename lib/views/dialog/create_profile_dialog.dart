import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/administrator_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';

import 'package:i_model/widgets/textview.dart';

void createProfileDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final AdministratorController controller = Get.put(AdministratorController());

  showDialog(
    context: context,
    builder: (BuildContext context) {

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.9,
          decoration: BoxDecoration(
            color: AppColors.pureWhiteColor,
            borderRadius: BorderRadius.circular(screenHeight * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.3),
                spreadRadius: 3,
                blurRadius: 2,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: TextView.title(
                              Strings.createProfile.toUpperCase(),
                              isUnderLine: true,
                              color: AppColors.pinkColor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close_sharp,
                            size: screenHeight * 0.04,
                            color: AppColors.blackColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: AppColors.pinkColor),

                  // Tab Bar Implementation
                  DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      children: [
                        RoundedContainer(
                          width: double.infinity,
                          color: AppColors.greyColor,
                          borderColor: AppColors.transparentColor,
                          widget: TabBar(
                            labelColor: AppColors.pinkColor,
                            unselectedLabelColor:
                            AppColors.blackColor.withValues(alpha: 0.8),
                            indicatorColor: AppColors.pinkColor,
                            dividerColor: Colors.transparent,
                            labelStyle: GoogleFonts.oswald(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            tabs: [
                              Tab(text: Strings.personalData.toUpperCase()),
                              Tab(text: Strings.cards.toUpperCase()),],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.7,
                          child: TabBarView(
                            children: [
                              /// Personal Data content
                              Obx(
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
                                              textEditingController: controller.createProfileNickNameController,
                                              fontSize: 11.sp,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                            selectedValue: controller.createProfileSelectedStatus.value,
                                            dropDownList: controller.administratorStatusList,
                                            onChanged: (value){
                                              controller.createProfileSelectedStatus.value = value;
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
                                              textEditingController: controller.createProfileNameController,
                                              fontSize: 11.sp,
                                            ),

                                            /// Gender text field
                                            SizedBox(height: screenHeight * 0.02,),
                                            DropDownLabelWidget(
                                                width: screenWidth * 0.2,
                                                selectedValue: controller.createProfileSelectedGender.value,
                                                dropDownList: controller.genderOptions,
                                                onChanged: (value){
                                                  controller.createProfileSelectedGender.value = value;
                                                },
                                                label: Strings.gender
                                            ),

                                            SizedBox(height: screenHeight * 0.02,),
                                            /// Birth date text field
                                            GestureDetector(
                                              onTap: () async {
                                                controller.createProfilePickBirthDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: TextFieldLabel(
                                                  width: screenWidth * 0.2,
                                                  label: Strings.birthDate,
                                                  textEditingController: controller.createProfileBirthDateController,
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
                                                selectedValue: controller.createProfileSelectedProfile.value,
                                                dropDownList: controller.profileOptions,
                                                onChanged: (value){
                                                  controller.createProfileSelectedProfile.value = value;
                                                },
                                                label: Strings.gender
                                            ),

                                            SizedBox(height: screenHeight * 0.035,),

                                            /// Session control drop down
                                            DropDownLabelWidget(
                                                width: screenWidth * 0.2,
                                                selectedValue: controller.createProfileSelectedSessionControl.value,
                                                dropDownList: controller.sessionControlOptions,
                                                onChanged: (value){
                                                  controller.createProfileSelectedSessionControl.value = value;
                                                },
                                                label: Strings.sessionControl
                                            ),
                                            SizedBox(height: screenHeight * 0.035,),

                                            /// Time control drop down
                                            DropDownLabelWidget(
                                                width: screenWidth * 0.2,
                                                selectedValue: controller.createProfileSelectedTimeControl.value,
                                                dropDownList: controller.timeControlOptions,
                                                onChanged: (value){
                                                  controller.createProfileSelectedTimeControl.value = value;
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
                                                controller.createProfilePickRegistrationDate(context);
                                              },
                                              child: AbsorbPointer(
                                                child: TextFieldLabel(
                                                  width: screenWidth * 0.2,
                                                  label: Strings.registrationDate,
                                                  textEditingController: controller.createProfileRegistrationDateController,
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
                              ),

                              /// Cards/bonos content
                              Obx(
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
                                              label: Strings.nick,
                                              textEditingController: controller.nickNameController,
                                              isReadOnly: true,
                                              fontSize: 11.sp,
                                            ),
                                          ),

                                          Row(
                                            children: [
                                              /// Client status drop down
                                              DropDownWidget(
                                                selectedValue: controller.selectedStatus.value,
                                                dropDownList: controller.administratorStatusList,
                                                isEnable: false,
                                                onChanged: (value){
                                                  controller.selectedStatus.value = value;
                                                },
                                              ),
                                              SizedBox(width: screenWidth * 0.01,),
                                              /// Add bonos button
                                              RoundedContainer(
                                                  borderRadius: screenHeight * 0.01,
                                                  width: screenWidth * 0.15,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: screenHeight * 0.013
                                                  ),
                                                  widget: TextView.title(
                                                      Strings.addPoints.toUpperCase(),
                                                      fontSize: 12.sp,
                                                      color: AppColors.blackColor.withValues(alpha: 0.8)
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),

                                    SizedBox(
                                      height: screenHeight * 0.42,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          /// Available points
                                          SizedBox(
                                            width: screenWidth * 0.32,
                                            child: Column(
                                              children: [
                                                TextView.title(
                                                  Strings.availablePoints.toUpperCase(),
                                                  color: AppColors.pinkColor,
                                                  fontSize: 11.sp,
                                                ),
                                                SizedBox(height: screenHeight * 0.02,),
                                                Expanded(
                                                  child: SizedBox(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          /// Table headers
                                                          Row(
                                                            children: [
                                                              tableTextInfo(
                                                                title: Strings.date,
                                                                fontSize: 10.sp,
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    tableTextInfo(
                                                                      title: Strings.quantity,
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    SizedBox(width: screenWidth * 0.02,),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005,),
                                                          CustomContainer(
                                                            height: screenHeight * 0.25,
                                                            width: double.infinity,
                                                            color: AppColors.greyColor,
                                                            widget: ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller.availablePoints.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  GestureDetector(
                                                                  onTap: (){},
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                                        ),
                                                                        child: RoundedContainer(
                                                                            width: double.infinity,
                                                                            borderColor: AppColors.transparentColor,
                                                                            borderRadius: screenWidth * 0.006,
                                                                            color: AppColors.pureWhiteColor,
                                                                            widget: Row(
                                                                              children: [
                                                                                /// Table cells info
                                                                                tableTextInfo(
                                                                                  title: controller.availablePoints[index].date!,
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.availablePoints[index].quantity.toString(),
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
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.005,),
                                                /// Available points total
                                                CustomContainer(
                                                    height: screenHeight * 0.07,
                                                    width: double.infinity,
                                                    color: AppColors.greyColor,
                                                    widget: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextView.title(
                                                            Strings.total.toUpperCase(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.blackColor.withValues(alpha: 0.8)
                                                        ),
                                                        TextView.title(
                                                            controller.availablePoints.length.toString(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.pinkColor
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.018,),

                                          /// Consumed points
                                          SizedBox(
                                            width: screenWidth * 0.35,
                                            child: Column(
                                              children: [
                                                TextView.title(
                                                  Strings.consumedPoints.toUpperCase(),
                                                  color: AppColors.pinkColor,
                                                  fontSize: 11.sp,
                                                ),
                                                SizedBox(height: screenHeight * 0.02,),
                                                /// Table
                                                Expanded(
                                                  child: SizedBox(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          /// Table headers
                                                          Row(
                                                            children: [
                                                              tableTextInfo(
                                                                title: Strings.date,
                                                                fontSize: 10.sp,
                                                              ),
                                                              tableTextInfo(
                                                                title: Strings.hour,
                                                                fontSize: 10.sp,
                                                              ),
                                                              tableTextInfo(
                                                                title: Strings.quantity,
                                                                fontSize: 10.sp,
                                                              ),
                                                              SizedBox(width: screenWidth * 0.02,),
                                                            ],
                                                          ),
                                                          SizedBox(height: screenHeight * 0.005,),
                                                          CustomContainer(
                                                            height: screenHeight * 0.25,
                                                            width: double.infinity,
                                                            color: AppColors.greyColor,
                                                            widget: ListView.builder(
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller.consumedPoints.length,
                                                              itemBuilder: (BuildContext context, int index) {
                                                                return  GestureDetector(
                                                                  onTap: (){},
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01,
                                                                        ),
                                                                        child: RoundedContainer(
                                                                            width: double.infinity,
                                                                            borderColor: AppColors.transparentColor,
                                                                            borderRadius: screenWidth * 0.006,
                                                                            color: AppColors.pureWhiteColor,
                                                                            widget: Row(
                                                                              children: [
                                                                                /// Table cells info
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].date!,
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].hour.toString(),
                                                                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                                  fontSize: 10.sp,
                                                                                ),
                                                                                tableTextInfo(
                                                                                  title: controller.consumedPoints[index].quantity.toString(),
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
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight * 0.005,),
                                                /// Consumed points total
                                                CustomContainer(
                                                    height: screenHeight * 0.07,
                                                    width: double.infinity,
                                                    color: AppColors.greyColor,
                                                    widget: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        TextView.title(
                                                            Strings.total.toUpperCase(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.blackColor.withValues(alpha: 0.8)
                                                        ),
                                                        TextView.title(
                                                            controller.consumedPoints.length.toString(),
                                                            fontSize: 10.sp,
                                                            color: AppColors.redColor
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
