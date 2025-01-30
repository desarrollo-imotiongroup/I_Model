import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

void clientFileDialog(BuildContext context,) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final ClientController controller = Get.put(ClientController());

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
                              'Ficha Cliente'.toUpperCase(),
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
                    length: 5, // Number of tabs
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
                              Tab(text: Strings.activities.toUpperCase()),
                              Tab(text: Strings.cards.toUpperCase()),
                              Tab(text: Strings.bioimpedancia.toUpperCase()),
                              Tab(text: Strings.groupActivities.toUpperCase()),
                            ],
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
                                    /// Name text field and status drop down
                                    Padding(
                                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFieldLabel(
                                              label: Strings.name,
                                              textEditingController: controller.clientPerDataNameController,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                              selectedValue: controller.selectedStatus.value,
                                              dropDownList: controller.clientStatusList,
                                              onChanged: (value){
                                                controller.selectedStatus.value = value;
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
                                                selectedValue: controller.clientPerDataSelectedGender.value,
                                                dropDownList: controller.genderList,
                                                onChanged: (value){
                                                  controller.clientPerDataSelectedGender.value = value;
                                                },
                                                label: Strings.gender
                                            ),
                                            SizedBox(height: screenHeight * 0.02,),

                                            /// Birth date text field
                                            TextFieldLabel(
                                                label: Strings.birthDate,
                                                textEditingController: controller.clientPerDataDobController,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Phone text field
                                            TextFieldLabel(
                                              label: Strings.phone,
                                              textEditingController: controller.clientPerDataPhoneController,
                                              isAllowNumberOnly: true,
                                            )
                                          ],
                                        ),

                                        /// TextFields 2nd column
                                        Column(
                                          children: [
                                            /// Height text field
                                             TextFieldLabel(
                                              label: Strings.height,
                                              textEditingController: controller.clientPerDataHeightController,
                                               isAllowNumberOnly: true,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Weight text field
                                            TextFieldLabel(
                                              label: Strings.weight,
                                              textEditingController: controller.clientPerDataWeightController,
                                              isAllowNumberOnly: true,
                                            ),

                                            SizedBox(height: screenHeight * 0.01,),

                                            /// Email text field
                                            TextFieldLabel(
                                              label: Strings.email,
                                              textEditingController: controller.clientPerDataEmailController,
                                              textInputAction: TextInputAction.done,
                                            )
                                          ],
                                        )
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

                              /// Activities content
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
                                              label: Strings.name,
                                              textEditingController: controller.clientPerDataNameController,
                                            ),
                                          ),

                                          /// Client status drop down
                                          DropDownWidget(
                                            selectedValue: controller.selectedStatus.value,
                                            dropDownList: controller.clientStatusList,
                                            onChanged: (value){
                                              controller.selectedStatus.value = value;
                                            },
                                          )
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: screenHeight * 0.02,),


                                    /// Table data
                                    Expanded(
                                      child: SizedBox(
                                        width: screenWidth * 0.85,
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
                                                      title: Strings.cards,
                                                      fontSize: 10.sp,
                                                  ),
                                                  tableTextInfo(
                                                      title: Strings.points,
                                                      fontSize: 10.sp,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          tableTextInfo(
                                                            title: Strings.eKcal,
                                                            fontSize: 10.sp,
                                                          ),
                                                          SizedBox(width: screenWidth * 0.035,)
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: screenHeight * 0.005,),
                                              CustomContainer(
                                                height: screenHeight * 0.37,
                                                width: double.infinity,
                                                color: AppColors.greyColor,
                                                widget: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: controller.clientActivity.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return  GestureDetector(
                                                      onTap: (){},
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: screenHeight * 0.01,
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
                                                                      title: controller.clientActivity[index].date,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].hour,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].card,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].point,
                                                                      color: AppColors.blackColor.withValues(alpha: 0.8),
                                                                      fontSize: 10.sp,
                                                                    ),
                                                                    tableTextInfo(
                                                                      title: controller.clientActivity[index].ekal,
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

                              /// Content for Bonos
                              Container(
                                child: Center(
                                  child: Text('Bonos Content'),
                                ),
                              ),

                              /// Content for Bioimpedancia
                              Container(
                                child: Center(
                                  child: Text('Bioimpedancia Content'),
                                ),
                              ),

                              /// Content for Grupos Activos
                              Container(
                                child: Center(
                                  child: Text('Grupos Activos Content'),
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
