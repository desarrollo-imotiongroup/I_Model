import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/center_management/beautician_controller.dart';
import 'package:i_model/views/dialogs/beautician_file/beautician_file_dialog.dart';
import 'package:i_model/widgets/overlay/box_decoration.dart';
import 'package:i_model/widgets/overlay/top_title_button.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/table_text_info.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

void beauticianListOverlay(BuildContext context) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  double screenWidth = mediaQuery.size.width;
  double screenHeight = mediaQuery.size.height;
  final BeauticianController controller = Get.put(BeauticianController());

  overlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.85,
          decoration: boxDecoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05
            ),
            child: Column(
              children: [
                SizedBox(height: screenWidth * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                  child: TopTitleButton(
                      title: Strings.beauticiansList,
                      onCancel: () {
                        controller.isDropdownOpen.value = false;
                        if (overlayEntry.mounted) {
                          overlayEntry.remove();
                        }
                      },
                  ),
                ),
                Divider(color: AppColors.pinkColor),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextFieldLabel(
                              label: Strings.name,
                              textEditingController: controller.beauticianNameController,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04,),
                          // Use Expanded here to make sure ListView doesn't overflow
                          Expanded(
                            child: SizedBox(
                              width: screenWidth * 0.85,
                              child: Column(
                                children: [
                                  /// Table headers
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.02,),
                                            tableTextInfo(title: Strings.number),
                                          ],
                                        ),
                                      ),
                                      tableTextInfo(title: Strings.name),
                                      tableTextInfo(title: Strings.phone),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            tableTextInfo(title: Strings.status),
                                            SizedBox(width: screenWidth * 0.03,),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.005,),
                                  CustomContainer(
                                    height: screenHeight * 0.5,
                                    width: double.infinity,
                                    color: AppColors.greyColor,
                                    widget: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: 13,
                                      itemBuilder: (BuildContext context, int index) {
                                        return  GestureDetector(
                                          onTap: (){
                                            if (overlayEntry.mounted) {
                                              overlayEntry.remove();
                                            }
                                            controller.selectedBeautician.value = controller.beauticiansList[index].name;
                                            beauticianFileDialog(context);
                                          },
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
                                                          title: '${index + 1}',
                                                          color: AppColors.blackColor.withValues(alpha: 0.8),
                                                          fontSize: 10.sp,
                                                        ),
                                                        tableTextInfo(
                                                          title: controller.beauticiansList[index].name,
                                                          color: AppColors.blackColor.withValues(alpha: 0.8),
                                                          fontSize: 10.sp,
                                                        ),
                                                        tableTextInfo(
                                                          title: controller.beauticiansList[index].phone.toUpperCase(),
                                                          color: AppColors.blackColor.withValues(alpha: 0.8),
                                                          fontSize: 10.sp,
                                                        ),
                                                        tableTextInfo(
                                                          title: controller.beauticiansList[index].status.toUpperCase(),
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
                        ],
                      ),
                      /// Drop down for client status
                      Positioned(
                        right: 0,
                        top: screenWidth * 0.03,
                        child: Column(
                          children: [
                            Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  // Prevent opening multiple dropdowns
                                  if (!controller.isDropdownOpen.value) {
                                    controller.isDropdownOpen.value = true;
                                  } else {
                                    controller.isDropdownOpen.value = false;
                                  }
                                },
                                /// When drop down not opened - closed
                                child: Container(
                                  width: screenWidth * 0.2,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.005),
                                        child: TextView.title(
                                          controller.selectedStatus.toUpperCase(),
                                          fontSize: 11.sp,
                                          color: AppColors.blackColor.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: AppColors.pinkColor,
                                        size: screenHeight * 0.05,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                            /// Show the dropdown only if it is not already open
                            /// When drop down is opened
                            Obx(() {
                              if (controller.isDropdownOpen.value) {
                                return Container(
                                  width: screenWidth * 0.2,
                                  color: AppColors.greyColor,
                                  child: Column(
                                    children: controller.statusOptions.map((String value) {
                                      return ListTile(
                                        title: TextView.title(
                                            value.toUpperCase(),
                                            fontSize: 11.sp,
                                            color: AppColors.blackColor.withValues(alpha: 0.8)),
                                        onTap: () {
                                          controller.selectedStatus.value = value;
                                          controller.isDropdownOpen.value = false;
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}
