import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/eckal_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/line_painter_widget.dart';

class DashboardFourthColumn extends StatelessWidget {
  DashboardFourthColumn({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Obx( () =>
        SizedBox(
          height: screenHeight * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: screenHeight * 0.05,),
              /// E-Kal Widget
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),  // Animation duration
                switchInCurve: Curves.easeInOut,        // Smooth appearance
                switchOutCurve: Curves.easeInOut,       // Smooth disappearance
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,                  // Add fade effect
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),  // Slide from right
                        end: Offset.zero,         // Final position
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: controller.isEKalWidgetVisible.value
                    ? Row(
                  key: ValueKey(1),  // Helps AnimatedSwitcher track widget changes
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        EKalWidget(
                          mciName: Strings.mciNames[0],
                          mciId: Strings.mciIDs[0],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        EKalWidget(
                          mciName: Strings.mciNames[1],
                          mciId: Strings.mciIDs[1],
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Column(
                      children: [
                        EKalWidget(
                          mciName: Strings.mciNames[0],
                          mciId: Strings.mciIDs[0],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        EKalWidget(
                          mciName: Strings.mciNames[1],
                          mciId: Strings.mciIDs[1],
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          controller.changeEKalMenuVisibility();
                        },
                        child: imageWidget(
                          image: Strings.arrowHideIcon,
                          height: screenHeight * 0.15,
                        ),
                      ),
                    ),
                  ],
                )
                    : GestureDetector(
                  key: ValueKey(2),  // Helps AnimatedSwitcher track widget changes
                  onTap: () {
                    controller.changeEKalMenuVisibility();
                  },
                  child: Container(
                      width: screenWidth * 0.2,
                      alignment: Alignment.centerLeft,
                      child: Transform.rotate(
                        angle: 3.14,
                        child: imageWidget(
                          image: Strings.arrowHideIcon,
                          height: screenHeight * 0.15,
                        ),
                      )
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05,),
              /// Line painters
              Column(
                children: [
                  LinePainterWidget(
                    title: translation(context).contractionTime,
                    progressValue: controller.progressContractionValue,
                    progressColor: AppColors.redColor,
                  ),
                  SizedBox(
                      height: screenHeight * 0.04
                  ),
                  LinePainterWidget(
                    title: translation(context).pauseTime,
                    progressValue: controller.progressPauseValue,
                    progressColor: AppColors.greenColor,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05,),
              Row(
                children: [
                  GestureDetector(
                    child: GestureDetector(
                      onTap: (){
                        controller.changeActiveState();
                      },
                      child: imageWidget(
                          image: controller.isActive.value
                              ? Strings.activeIcon
                              : Strings.inActiveIcon,
                          height: screenHeight * 0.1
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04,),
                  imageWidget(
                      image: Strings.resetIcon,
                      height: screenHeight * 0.1
                  ),
                ],
              )
            ],
          ),
        )
    );

  }
}
