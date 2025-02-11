import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/setting_controller.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/containers/unbounded_container.dart';
import 'package:i_model/widgets/textfield_label.dart';
import 'package:i_model/widgets/textview.dart';

class SecurityVerification extends StatelessWidget {
  final Function()? onCancel;

  SecurityVerification({this.onCancel, super.key});

  final SettingController controller = Get.put(SettingController());

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
            spreadRadius: 3, // How wide the shadow spreads
            blurRadius: 2, // The blur effect
            offset: Offset(0, 3), // Changes position of shadow (x, y)
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
                        Strings.securityVerification,
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
          TextView.title(Strings.solvePrompt.toUpperCase(),
              fontSize: 12.sp,
              color: AppColors.blackColor.withValues(alpha: 0.8)),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          RoundedContainer(
              color: AppColors.greyColor,
              borderColor: AppColors.transparentColor,
              width: screenWidth * 0.45,
              widget: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02
                ),
                child: Column(
                  children: [
                    TextView.title(
                        controller.randomNumbers.isEmpty
                        ? Strings.loading
                        : controller.randomNumbers.join(' '),
                        color: AppColors.blackColor.withValues(alpha: 0.8),
                        fontSize: 12.sp,
                    ),
                    SizedBox(height: screenHeight * 0.01,),
                    TextFieldLabel(
                        label: Strings.enterSum,
                        textEditingController: controller.textEditingController,
                        width: double.infinity,
                        isAllowNumberOnly: true,
                        textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: screenHeight * 0.02,),
                    SizedBox(
                      width: screenWidth * 0.15,
                      child: UnboundedContainer(
                        onTap: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                          controller.verify(context);
                        },
                         height: screenHeight * 0.05,
                          borderColor: AppColors.blackColor.withValues(alpha: 0.8),
                          widget: TextView.title(
                            Strings.verify,
                            fontSize: 12.sp,
                          )
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
