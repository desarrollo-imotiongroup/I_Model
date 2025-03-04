import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/overlays/program_list_overlay.dart';
import 'package:i_model/widgets/containers/rounded_container.dart';
import 'package:i_model/widgets/frequency_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/textview.dart';
import 'package:i_model/widgets/time_control_widget.dart';
import 'package:i_model/widgets/time_counter_widget.dart';

class DashboardSecondColumn extends StatelessWidget {
  final int index;

  DashboardSecondColumn({required this.index, super.key});

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return
      Column(
      children: [
        SizedBox(height: screenHeight * 0.03,),
        Obx(() =>
            TextView.title(
              // controller.testingPercentage[index].toString(),
                controller.isProgramSelected[index]
                    ? controller.selectedMainProgramName[index].toUpperCase()
                    : Strings.nothing,
                fontSize: 12.sp,
                color: AppColors.pinkColor
            ),
        ),

        SizedBox(height: screenHeight * 0.01,),
        Obx(() =>
            RoundedContainer(
                onTap: (){
                  if(controller.isTimerPaused[index]){
                    if(controller.selectedProgramType[index] == Strings.individual){
                      controller.changeProgramType();
                    }
                    else{
                      controller.changeProgramType(isIndividual: false);
                    }
                  }
                },
                width: screenWidth * 0.1,
                borderRadius: screenHeight * 0.02,
                borderColor: AppColors.transparentColor,
                color: AppColors.pinkColor,
                widget: TextView.title(
                    controller.selectedProgramType[index].toUpperCase(),
                    color: AppColors.pureWhiteColor,
                    fontSize: 10.sp
                )
            ),
        ),

        SizedBox(height: screenHeight * 0.025,),
        Obx(() =>
            TextView.title(
                controller.isProgramSelected[index]
                    ? controller.selectedProgramName[index].toUpperCase()
                    : Strings.nothing,
                fontSize: 14.sp,
                color: AppColors.blackColor.withValues(alpha: 0.8)
            ),
        ),

        SizedBox(height: screenHeight * 0.01,),
        Obx(() =>
            GestureDetector(
              onTap: (!controller.isTimerPaused[index])
                  ? null
                  : (){
                programListOverlay(
                  context,
                  deviceIndex: index,
                  programList:
                  controller.selectedProgramType[index] == Strings.individual
                      ? controller.individualProgramList
                      : controller.automaticProgramList,
                );
              },
              child: imageWidget(
                image: controller.isProgramSelected[index]
                    ? controller.selectedProgramImage[index]
                    : Strings.selectProgramIcon,
                height: screenHeight * 0.13,
              ),
            ),
        ),

        SizedBox(height: screenHeight * 0.015,),

        /// Frequency and pulse widget
        Obx(() => FrequencyWidget(
              frequency: controller.frequency[index],
              pulse: controller.pulse[index],
              duration: controller.formatProgramDuration(
                  controller.remainingProgramDuration[index]),
            )),
        SizedBox(height: screenHeight * 0.02,),

        /// Time Counter and Up down arrow
        Obx(() =>
           TimeCounterWidget(
              minutes: controller.formatTime(controller.remainingSeconds[index], index),
              // minutes: controller.formatTime(controller.remainingSeconds[index]),
              onIncrease: (){
                if(controller.selectedProgramType[index] == Strings.individual) {
                  controller.increaseMinute();
                }
              },
              onDecrease: (){
                if(controller.selectedProgramType[index] == Strings.individual) {
                  controller.decreaseMinute();
                }
              },
              timeImage: controller.timerImage[index],
            ),
        ),


        /// Start, pause and Up down arrow
        Obx(() =>
            TimeControlWidget(
              onPlayPause: (){
                if (controller.isProgramSelected[index]) {
                  if (controller.isTimerPaused[index] && controller.minutes[index] > 0) {
                    controller.startTimer(index);
                    if(controller.selectedProgramType[index] == Strings.individual) {
                      controller.startContractionTimeCycle(index, controller.selectedMacAddress[index]);
                    }
                    else{
                      controller.startContractionForMultiplePrograms(index, controller.selectedMacAddress[index] );
                    }
                  }
                  else {
                    controller.pauseTimer();
                    controller.stopElectrostimulationProcess(controller.selectedMacAddress[index], index);
                    controller.contractionCycleTimer[index]?.cancel();
                    controller.pauseCycleTimer[index]?.cancel();
                  }
                }
              },
              icon: controller.isTimerPaused[index] ? Strings.playIcon : Strings.pauseIcon,
              onIncrease: (){
                controller.changeAllProgramsPercentage(isIncrease: true);
              },
              onDecrease: (){
                controller.changeAllProgramsPercentage(isDecrease: true);
              },
            )
        )

      ],
    );
  }
}
