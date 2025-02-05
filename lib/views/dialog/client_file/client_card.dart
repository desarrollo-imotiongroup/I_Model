import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client_controller.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({super.key});

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
                    label: Strings.name,
                    textEditingController: controller.clientNameController,
                    isReadOnly: true,
                    fontSize: 11.sp,
                  ),
                ),

                Row(
                  children: [
                    /// Client status drop down
                    DropDownWidget(
                      selectedValue: controller.selectedStatus.value,
                      dropDownList: controller.clientStatusList,
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
    );
  }
}
