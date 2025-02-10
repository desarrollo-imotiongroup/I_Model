import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/view_models/menu/license_controller.dart';
import 'package:i_model/widgets/box_decoration.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/top_title_button.dart';

void licenseDetailDialog(BuildContext context, {required int index}) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final LicenseController controller = Get.put(LicenseController());

  mciInfoWidget(String text){
    return TextView.title(
        text,
        fontSize: 10.sp,
        color: AppColors.blackColor.withValues(alpha: 0.8)
    );
  }
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: screenWidth * 0.7,
          height: screenHeight * 0.65,
          decoration: boxDecoration(context),
          child: SingleChildScrollView( // Only one scroll view to handle the content
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: screenWidth * 0.015),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: TopTitleButton(
                      title: translation(context).mci,
                      onCancel: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Divider(color: AppColors.pinkColor),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.03,
                      horizontal: screenWidth * 0.035,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Info column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextView.title(
                              controller.mciLicenseList[index].mci,
                              color: AppColors.blackColor.withValues(alpha: 0.8),
                              fontSize: 12.sp,
                            ),
                            SizedBox(height: screenHeight * 0.08,),
                            Column(
                              children: [
                                TextView.title(
                                  translation(context).info,
                                  color: AppColors.blackColor.withValues(alpha: 0.8),
                                  fontSize: 12.sp,
                                ),
                                SizedBox(height: screenHeight * 0.02,),
                                CustomContainer(
                                    height: screenHeight * 0.2,
                                    width: screenWidth * 0.3,
                                    color: AppColors.greyColor,
                                    widget: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              mciInfoWidget('C:'),
                                              mciInfoWidget('T:'),
                                              mciInfoWidget('CT:'),
                                              mciInfoWidget('CP:'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              mciInfoWidget('V:'),
                                              mciInfoWidget('LS:'),
                                              mciInfoWidget('FS:'),
                                              mciInfoWidget('TS:'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            )
                          ],
                        ),

                        /// Recharge column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Obx(() =>
                                    DropDownLabelWidget(
                                      label: translation(context).status,
                                      selectedValue: controller.selectedStatus.value,
                                      dropDownList: controller.statusList,
                                      onChanged: (status){
                                        controller.selectedStatus.value = status;
                                        controller.updateStatus(index: index, value: status);
                                      },

                                    )
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.06,),
                            Column(
                              children: [
                                RoundedContainer(
                                    borderColor: AppColors.pinkColor,
                                    width: screenWidth * 0.12,
                                    widget: TextView.title(
                                        translation(context).recharge,
                                        fontSize: 12.sp,
                                        color: AppColors.pinkColor
                                    )
                                ),
                                SizedBox(height: screenHeight * 0.02,),
                                CustomContainer(
                                    height: screenHeight * 0.2,
                                    width: screenWidth * 0.3,
                                    color: AppColors.greyColor,
                                    widget: Container()
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
