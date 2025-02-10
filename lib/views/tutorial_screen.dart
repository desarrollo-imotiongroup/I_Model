import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/tutorial_controller.dart';
import 'package:i_model/widgets/first_step_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/widgets/textview.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({super.key});

  final TutorialController controller = Get.put(TutorialController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
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
                    top: screenHeight * 0.06,
                    left: screenHeight * 0.1,
                    right: screenHeight * 0.04,
                    bottom: screenHeight * 0.07,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
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
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Tutorials
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView.title(translation(context).tutorials.toUpperCase(),
                                    color: AppColors.pinkColor,
                                    isUnderLine: true,
                                    fontSize: 18.sp),
                                SizedBox(
                                  height: screenHeight * 0.07,
                                ),

                                /// First steps
                                MenuWidget(
                                  title: translation(context).firstSteps.toUpperCase(),
                                  onTap: () {
                                    controller.isFirstStep.value = true;
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                /// Software
                                MenuWidget(
                                  title: translation(context).software.toUpperCase(),
                                  onTap: () {},
                                ),

                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),

                                /// Common incidents
                                MenuWidget(
                                  title: translation(context).commonIncidents.toUpperCase(),
                                  onTap: () {},
                                )
                              ],
                            ),

                            /// logo_imodel
                            controller.isFirstStep.value
                                ? FirstStepWidget(
                                    onCancel: () {
                                      controller.dismissFirstStepState();
                                    },
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.1,
                                        right: screenWidth * 0.05),
                                    child: imageWidget(
                                      image: Strings.logoIModel,
                                      height: screenHeight * 0.2,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
