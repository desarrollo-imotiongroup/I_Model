import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/view_models/select_language_controller.dart';
import 'package:i_model/widgets/textview.dart';

class SelectLanguage extends StatelessWidget {
  final Function()? onCancel;

  SelectLanguage({this.onCancel, super.key});

  final SelectLanguageController selectLanguageController =
      Get.put(SelectLanguageController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.05),
      width: screenWidth * 0.52,
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
        color: AppColors.pureWhiteColor,
        borderRadius: BorderRadius.circular(screenHeight * 0.02),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3), // Shadow color
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.01,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: TextView.title(
                        translation(context).languageSelection,
                        isUnderLine: true,
                        color: AppColors.pinkColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCancel,
                child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.015),
                    child: Icon(
                      Icons.close_sharp,
                      size: screenHeight * 0.04,
                      color: AppColors.blackColor.withValues(alpha: 0.8),
                    )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
              top: screenHeight * 0.002,
            ),
            child: Divider(
              color: AppColors.pinkColor,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SizedBox(
            height: screenHeight * 0.35,
            width: screenWidth * 0.47,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: selectLanguageController.languages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 5.0, // Space between columns
                mainAxisSpacing: 5.0, // Space between rows
                childAspectRatio: 3.5, // Adjust this for better proportions
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(screenHeight * 0.01),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.pureWhiteColor,
                      borderRadius: BorderRadius.circular(screenHeight * 0.02),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: const Offset(0, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Center(
                      child: ListTile(
                        onTap: (){
                          selectLanguageController.selectedLanguage.value = selectLanguageController.languages[index];
                          selectLanguageController.chooseLanguage(context: context);
                        },
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.015,
                            vertical: screenHeight * 0.01),
                        minVerticalPadding: 0,
                        horizontalTitleGap: 0,
                        title: Center(
                          child: Text(
                            selectLanguageController.languages[index],
                            style: TextStyle(fontSize: 11.sp),
                          ),
                        ),
                        leading: SizedBox(
                            width: screenWidth * 0.015,
                            child: Obx(
                              () => Radio<String>(
                                value: selectLanguageController.languages[index],
                                groupValue: selectLanguageController.selectedLanguage.value,
                                activeColor: AppColors.pinkColor,
                                onChanged: (value) async {
                                  selectLanguageController.selectedLanguage.value = value!;
                                  selectLanguageController.chooseLanguage(context: context);
                                },
                              ),
                            )),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
