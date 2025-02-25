import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/ekcal_page_view.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/line_painter_with_seconds.dart';

class DashboardFourthColumn extends StatelessWidget {
  DashboardFourthColumn({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Obx(() => SizedBox(
          height: screenHeight * 0.85,
          width: screenWidth * 0.25,
          child: Container(
            color: AppColors.seperatorColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),

                /// E-Kal Widget
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(1.0, 0.0), // Slide from right
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: controller.isEKalWidgetVisible.value
                      ? Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.01, right: screenWidth * 0.01),
                    child: Row(
                      key: ValueKey(1),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dynamic PageView with constraints
                        EkcalPageView(),
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
                    ),
                  )
                      : GestureDetector(
                    key: ValueKey(2),
                    onTap: () {
                      controller.changeEKalMenuVisibility();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: Container(
                        width: screenWidth * 0.25,
                        alignment: Alignment.centerLeft,
                        child: Transform.rotate(
                          angle: 3.14,
                          child: imageWidget(
                            image: Strings.arrowHideIcon,
                            height: screenHeight * 0.15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),

                /// Line painters
                Column(
                  children: [
                    /// Contraction time line painter
                    LinePainterWithSeconds(
                        progressValue: controller.contractionProgress.value,
                        secondsPerCycle: controller.isContractionPauseCycleActive.value
                            ? controller.remainingContractionSeconds.value.toInt()
                            : controller.contractionSeconds.value,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    /// Pause time line painter
                    LinePainterWithSeconds(
                      progressValue: controller.pauseProgress.value,
                      secondsPerCycle: controller.isContractionPauseCycleActive.value
                          ? controller.remainingPauseSeconds.value.toInt()
                          : controller.pauseSeconds.value,
                      isPause: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: GestureDetector(
                        onTap: () {
                          controller.changeActiveState();
                        },
                        child: imageWidget(
                            image: controller.isActive.value
                                ? Strings.activeIcon
                                : Strings.inActiveIcon,
                            height: screenHeight * 0.1),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.resetProgramValues();
                      },
                      child: imageWidget(
                          image: Strings.resetIcon, height: screenHeight * 0.1),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ));
  }
}
