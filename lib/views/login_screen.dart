import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/login_controller.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:i_model/widgets/button.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textfield.dart';
import 'package:i_model/widgets/textview.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        alertOverlay(context,
            heading: Strings.closeApplication,
            buttonText: Strings.closeApplicationButton,
            onTap: () {
          SystemNavigator.pop();});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(Strings.bgImage))),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  // Ensures the Column takes the full height
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.07,
                      left: screenHeight * 0.1,
                      right: screenHeight * 0.04,
                      bottom: screenHeight * 0.07,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Image(
                            image: AssetImage(
                              Strings.ignitionIcon,
                            ),
                            height: screenHeight * 0.1,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// Control access
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView.title(
                                    translation(context).controlAccess,
                                    color: AppColors.pinkColor,
                                    isUnderLine: true,
                                    fontSize: 20.sp),
                                SizedBox(
                                  height: screenHeight * 0.07,
                                ),

                                /// Username
                                TextView.title(
                                  translation(context).username,
                                  color: AppColors.darkGrey,
                                  fontSize: 16.sp,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                TextFieldWidget(
                                  bgColor: AppColors.greyColor,
                                  width: screenWidth * 0.3,
                                  height: screenHeight * 0.07,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),

                                /// Password
                                TextView.title(translation(context).password,
                                    color: AppColors.darkGrey, fontSize: 16.sp),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Obx(() =>
                                    TextFieldWidget(
                                      bgColor: AppColors.greyColor,
                                      width: screenWidth * 0.3,
                                      height: screenHeight * 0.07,
                                      textInputAction: TextInputAction.done,
                                      obscureText: controller.isObscured.value ? true : false,
                                      isSuffixIcon: true,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          controller.isObscured.value ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          controller.changeVisibility();
                                        },
                                      ),
                                    ),
                                ),

                              ],
                            ),

                            /// logo_imodel
                            Padding(
                              padding:
                                  EdgeInsets.only(right: screenWidth * 0.05),
                              child: imageWidget(
                                image: Strings.logoIModel,
                                height: screenHeight * 0.2,
                              ),
                            )
                          ],
                        ),
                        Spacer(),

                        /// Enter button
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Button(
                            onTap: () {
                              Navigator.pushNamed(context, Strings.menuScreen);
                            },
                            text: translation(context).enter,
                            textColor: AppColors.lightBlack.withValues(alpha: 0.8),
                            width: screenWidth * 0.15,
                            height: screenHeight * 0.08,
                            borderRadius: screenHeight * 0.01,
                            btnColor: AppColors.transparentColor,
                            borderColor: AppColors.pinkColor,
                            fontSize: 17.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
