import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/beautician_controller.dart';
import 'package:i_model/widgets/containers/custom_container.dart';
import 'package:i_model/widgets/drop_down_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';

class BeauticianActivities extends StatelessWidget {
  const BeauticianActivities({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    final BeauticianController controller = Get.put(BeauticianController());

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
                    label: translation(context).nick,
                    textEditingController: controller.nickNameController,
                    isReadOnly: true,
                    fontSize: 11.sp,
                  ),
                ),

                /// Client status drop down
                DropDownWidget(
                  selectedValue: controller.fetchedStatus.value,
                  dropDownList: controller.statusList,
                  isEnable: false,
                  onChanged: (value){
                    controller.fetchedStatus.value = value;
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
                          title: translation(context).date,
                          fontSize: 10.sp,
                        ),
                        tableTextInfo(
                          title: translation(context).start,
                          fontSize: 10.sp,
                        ),
                        tableTextInfo(
                          title: translation(context).end,
                          fontSize: 10.sp,
                        ),
                        tableTextInfo(
                          title: translation(context).bonuses,
                          fontSize: 10.sp,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              tableTextInfo(
                                title: translation(context).client,
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
                        itemCount: controller.beauticiansActivity.length,
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
                                            title: controller.beauticiansActivity[index].date,
                                            color: AppColors.blackColor.withValues(alpha: 0.8),
                                            fontSize: 10.sp,
                                          ),
                                          tableTextInfo(
                                            title: controller.beauticiansActivity[index].start,
                                            color: AppColors.blackColor.withValues(alpha: 0.8),
                                            fontSize: 10.sp,
                                          ),
                                          tableTextInfo(
                                            title: controller.beauticiansActivity[index].end,
                                            color: AppColors.blackColor.withValues(alpha: 0.8),
                                            fontSize: 10.sp,
                                          ),
                                          tableTextInfo(
                                            title: controller.beauticiansActivity[index].bonuses,
                                            color: AppColors.blackColor.withValues(alpha: 0.8),
                                            fontSize: 10.sp,
                                          ),
                                          tableTextInfo(
                                            title: controller.beauticiansActivity[index].client,
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
              Container(),
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
