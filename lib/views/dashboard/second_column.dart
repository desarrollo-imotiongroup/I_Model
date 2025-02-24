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
  DashboardSecondColumn({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Obx(() =>
        Column(
      children: [
        SizedBox(height: screenHeight * 0.03,),
        TextView.title(
            controller.isProgramSelected.value
                ? controller.selectedMainProgramName.value.toUpperCase()
                : Strings.nothing,
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
            controller.isProgramSelected.value
                ? controller.selectedProgramName.value.toUpperCase()
                : Strings.nothing,
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
                  ? controller.individualProgramList
                  : controller.automaticProgramList,
            );
          },
          child: imageWidget(
            image: controller.isProgramSelected.value
                ? controller.selectedProgramImage.value
                : Strings.selectProgramIcon,
            height: screenHeight * 0.13,
          ),
        ),
        SizedBox(height: screenHeight * 0.015,),

        /// Frequency and pulse widget
        FrequencyWidget(frequency: controller.frequency.value, pulse: controller.pulse.value),
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
            if (controller.isProgramSelected.value) {
              if (controller.isTimerPaused.value && controller.minutes.value > 0) {
                controller.startTimer();
                // controller.startFullElectrostimulationTrajeProcess(
                //     controller.selectedMacAddress.value,
                //     controller.selectedProgramName.value
                // );
                if(controller.selectedProgramType.value == Strings.individual) {
                  controller.startContractionTimeCycle();
                }
                else{
                  controller.startContractionForMultiplePrograms();
                }
              }
              else {
                controller.pauseTimer();
                controller.stopElectrostimulationProcess(controller.selectedMacAddress.value);
                controller.contractionCycleTimer?.cancel();
                controller.pauseCycleTimer?.cancel();
              }
            }
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
    ));

  }
}
