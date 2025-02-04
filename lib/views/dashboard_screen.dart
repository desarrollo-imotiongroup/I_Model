
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/overlay/program_list_overlay.dart';
import 'package:i_model/widgets/button.dart';
import 'package:i_model/widgets/dashboard_body_program.dart';
import 'package:i_model/widgets/eckal_widget.dart';
import 'package:i_model/widgets/frequency_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/line_painter.dart';
import 'package:i_model/widgets/line_painter_widget.dart';
import 'package:i_model/widgets/mci_widget.dart';
import 'package:i_model/widgets/rounded_container.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/time_control_widget.dart';
import 'package:i_model/widgets/time_counter_widget.dart';

class DashboardScreen extends StatelessWidget
{DashboardScreen({super.key});

 final DashboardController dashboardController = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.offWhite
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.035,
                left: screenWidth * 0.03,
                right: screenWidth * 0.03,
              ),
              child: Column(
                children: [
                  /// MCI Containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          MciWidget(
                            mciName: Strings.mciNames[0],
                            mciId: Strings.mciIDs[0],
                          ),
                          MciWidget(
                            mciName: Strings.mciNames[1],
                            mciId: Strings.mciIDs[1],
                          ),
                          MciWidget(
                            icon: Strings.selectedSuitIcon,
                            mciName: Strings.mciNames[2],
                            mciId: Strings.mciIDs[2],
                          ),
                        ],
                      ),
                      GestureDetector(
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
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Muscle group  - first column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.025),
                          /// Profile, repeat, suit selected icons
                          SizedBox(
                            width: screenWidth * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                imageWidget(
                                  image: Strings.selectCustomerIcon,
                                  height: screenHeight * 0.08,
                                ),
                                imageWidget(
                                  image: Strings.repeatSession,
                                  height: screenHeight * 0.08,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    controller.changeSuitSelection();
                                  },
                                  child: imageWidget(
                                    image: controller.isPantSelected.value
                                        ? Strings.selectedPantIcon
                                        : Strings.completeSuitSelected,
                                    height: screenHeight * 0.08,
                                  ),
                                )
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              /// Chest
                              DashboardBodyProgram(
                                title: translation(context).chest,
                                image: Strings.chestIcon,
                                onIncrease: (){
                                  controller.changeChestPercentage(isIncrease: true);
                                },
                                onDecrease: (){
                                  controller.changeChestPercentage(isDecrease: true);
                                },
                                percentage: controller.chestPercentage.value,
                                intensityColor: controller.chestIntensityColor,
                              ),

                              /// Arms
                              DashboardBodyProgram(
                                title: translation(context).arms,
                                image: Strings.armsIcon,
                                onIncrease: () {
                                  controller.changeArmsPercentage(isIncrease: true);
                                },
                                onDecrease: () {
                                  controller.changeArmsPercentage(isDecrease: true);
                                },
                                percentage: controller.armsPercentage.value,
                                intensityColor: controller.armsIntensityColor,
                              ),

                              /// Abdomen
                              DashboardBodyProgram(
                                title: translation(context).abdomen,
                                image: Strings.abdomenIcon,
                                onIncrease: () {
                                  controller.changeAbdomenPercentage(isIncrease: true);
                                },
                                onDecrease: () {
                                  controller.changeAbdomenPercentage(isDecrease: true);
                                },
                                percentage: controller.abdomenPercentage.value,
                                intensityColor: controller.abdomenIntensityColor,
                              ),

                              /// Legs
                              DashboardBodyProgram(
                                title: translation(context).legs,
                                image: Strings.legsIcon,
                                onIncrease: () {
                                  controller.changeLegsPercentage(isIncrease: true);
                                },
                                onDecrease: () {
                                  controller.changeLegsPercentage(isDecrease: true);
                                },
                                percentage: controller.legsPercentage.value,
                                intensityColor: controller.legsIntensityColor,
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.03,),

                      /// Second column - timer
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.03,),
                          TextView.title(
                              controller.selectedProgramName.value.toUpperCase(),
                              fontSize: 12.sp,
                              color: AppColors.pinkColor
                          ),
                          SizedBox(height: screenHeight * 0.01,),
                          RoundedContainer(
                              onTap: (){
                                if(controller.selectedProgramType.value == Strings.individual){
                                  controller.changeProgramType();
                                }
                                else{
                                  controller.changeProgramType(isIndividual: false);
                                }
                                // selectProgramOverlay(
                                //   context,
                                //   title: Strings.selectProgramType
                                // );
                              },
                              width: screenWidth * 0.1,
                              borderRadius: screenHeight * 0.02,
                              borderColor: AppColors.transparentColor,
                              color: AppColors.pinkColor,
                              widget: TextView.title(
                                  controller.selectedProgramType.value.toUpperCase(),
                                  color: AppColors.pureWhiteColor,
                                  fontSize: 10.sp
                              )
                          ),
                          SizedBox(height: screenHeight * 0.025,),
                          TextView.title(
                              controller.selectedProgramName.value.toUpperCase(),
                              fontSize: 14.sp,
                              color: AppColors.blackColor.withValues(alpha: 0.8)
                          ),
                          SizedBox(height: screenHeight * 0.01,),
                          GestureDetector(
                            onTap: (){
                              programListOverlay(
                                context,
                                programList:
                                controller.selectedProgramType.value == Strings.individual
                                    ? Consts.individualProgramsList
                                    : Consts.automaticProgramsList,
                              );
                            },
                            child: imageWidget(
                              image: controller.selectedProgramImage.value,
                              height: screenHeight * 0.13,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015,),

                          /// Frequency and pulse widget
                          FrequencyWidget(frequency: 43, pulse: 450),
                          SizedBox(height: screenHeight * 0.02,),

                          /// Time Counter and Up down arrow
                          TimeCounterWidget(
                              minutes: controller.formatTime(controller.remainingSeconds.value),
                              onIncrease: (){
                                controller.increaseMinute();
                              },
                              onDecrease: (){
                                controller.decreaseMinute();
                              },
                              timeImage: controller.timerImage.value,
                          ),

                          /// Start, pause and Up down arrow
                          TimeControlWidget(
                            onPlayPause: (){
                              controller.isTimerPaused.value
                                  ? controller.startTimer()
                                  : controller.pauseTimer();
                            },
                            icon: controller.isTimerPaused.value ? Strings.playIcon : Strings.pauseIcon,
                            onIncrease: (){
                              controller.changeAllProgramsPercentage(isIncrease: true);
                            },
                            onDecrease: (){
                              controller.changeAllProgramsPercentage(isDecrease: true);
                            },
                          )
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.03,),

                      /// Muscle group 2 - third column
                      Column(
                        children: [
                          /// Upper back
                          DashboardBodyProgram(
                            isImageLeading: false,
                            topPadding: 0,
                            title: translation(context).upperBack,
                            image: Strings.upperBackIcon,
                            onIncrease: () {
                              controller.changeUpperBackPercentage(isIncrease: true);
                            },
                            onDecrease: () {
                              controller.changeUpperBackPercentage(isDecrease: true);
                            },
                            percentage: controller.upperBackPercentage.value,
                            intensityColor: controller.upperBackIntensityColor,
                          ),

                          /// Middle back
                          DashboardBodyProgram(
                            isImageLeading: false,
                            title: translation(context).middleBack,
                            image: Strings.middleBackIcon,
                            onIncrease: () {
                              controller.changeMiddleBackPercentage(isIncrease: true);
                            },
                            onDecrease: () {
                              controller.changeMiddleBackPercentage(isDecrease: true);
                            },
                            percentage: controller.middleBackPercentage.value,
                            intensityColor: controller.middleBackIntensityColor,
                          ),

                          /// lumbars
                          DashboardBodyProgram(
                            isImageLeading: false,
                            title: translation(context).lumbars,
                            image: Strings.lumbarsIcon,
                            onIncrease: () {
                              controller.changeLumbarPercentage(isIncrease: true);
                            },
                            onDecrease: () {
                              controller.changeLumbarPercentage(isDecrease: true);
                            },
                            percentage: controller.lumbarPercentage.value,
                            intensityColor: controller.lumbarsIntensityColor,
                          ),

                          /// buttocks
                          DashboardBodyProgram(
                            isImageLeading: false,
                            title: translation(context).buttocks,
                            image: Strings.buttocksIcon,
                            onIncrease: () {
                              controller.changeButtocksPercentage(isIncrease: true);
                            },
                            onDecrease: () {
                              controller.changeButtocksPercentage(isDecrease: true);
                            },
                            percentage: controller.buttocksPercentage.value,
                            intensityColor: controller.buttocksIntensityColor,
                          ),

                          /// Hamstrings
                          DashboardBodyProgram(
                            isImageLeading: false,
                            title: translation(context).hamstrings,
                            image: Strings.hamstringsIcon,
                            onIncrease: () {
                              controller.changeHamStringsPercentage(isIncrease: true);
                            },
                            onDecrease: () {
                              controller.changeHamStringsPercentage(isDecrease: true);
                            },
                            percentage: controller.hamStringsPercentage.value,
                            intensityColor: controller.hamstringsIntensityColor,
                          ),

                        ],
                      ),
                      SizedBox(width: screenWidth * 0.03,),

                      /// Fourth column, contraction, pause, reset
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
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
