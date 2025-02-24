import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/dashboard_body_program.dart';

class DashboardThirdColumn extends StatelessWidget {
  DashboardThirdColumn({super.key});

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;

    return Obx(() {
      return Column(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isPantSelected.value
                ? SizedBox(height: screenHeight * 0.12)
                : Container(),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isPantSelected.value
                ? Column(
                    key: ValueKey('pantSelectedBodyParts'),
                    children: [
                      /// Buttocks - always visible
                      DashboardBodyProgram(
                        key: ValueKey('buttocks'),
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
                        programStatus: controller.programsStatus[7].status!.value,
                        onPress: (){
                          if(controller.programsStatus[7].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.glutes,
                              controller.programsStatus[7].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.buttocksPercentage.value = 0;
                          controller.buttocksIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.glutes,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[7].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Hamstrings - always visible
                      DashboardBodyProgram(
                        key: ValueKey('hamstrings'),
                        isImageLeading: false,
                        title: translation(context).hamstrings,
                        image: Strings.hamstringsIcon,
                        onIncrease: () {
                          controller.changeHamStringsPercentage(isIncrease: true);},
                        onDecrease: () {
                          controller.changeHamStringsPercentage(isDecrease: true);},
                        percentage: controller.hamStringsPercentage.value,
                        intensityColor: controller.hamstringsIntensityColor,
                        programStatus: controller.programsStatus[8].status!.value,
                        onPress: (){
                          if(controller.programsStatus[8].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.hamstrings,
                              controller.programsStatus[8].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.hamStringsPercentage.value = 0;
                          controller.hamstringsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.hamstrings,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[8].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Calves - only visible when pant is selected
                      DashboardBodyProgram(
                        key: ValueKey('calves'),
                        isImageLeading: false,
                        title: Strings.calves,
                        image: Strings.calvesIcon,
                        onIncrease: () {
                          controller.changeCalvesPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeCalvesPercentage(isDecrease: true);
                        },
                        percentage: controller.calvesPercentage.value,
                        intensityColor: controller.calvesIntensityColor,
                        programStatus: controller.programsStatus[9].status!.value,
                        onPress: (){
                          if(controller.programsStatus[9].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.calves,
                              controller.programsStatus[9].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.calvesPercentage.value = 0;
                          controller.calvesIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.calves,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[9].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),
                    ],
                  )
                : Column(
                    key: ValueKey('noPantSelectedBodyParts'),
                    children: [
                      SizedBox(height: screenHeight * 0.02,),
                      /// Upper back
                      DashboardBodyProgram(
                        isImageLeading: false,
                        topPadding: 0,
                        title: translation(context).upperBack,
                        image: Strings.upperBackIcon,
                        onIncrease: () {
                          controller.changeUpperBackPercentage(
                              isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeUpperBackPercentage(
                              isDecrease: true);
                        },
                        percentage: controller.upperBackPercentage.value,
                        intensityColor: controller.upperBackIntensityColor,
                        programStatus: controller.programsStatus[4].status!.value,
                        onPress: (){
                          if(controller.programsStatus[4].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.upperBack,
                              controller.programsStatus[4].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.upperBackPercentage.value = 0;
                          controller.upperBackIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.upperBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[4].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Middle back
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).middleBack,
                        image: Strings.middleBackIcon,
                        onIncrease: () {
                          controller.changeMiddleBackPercentage(
                              isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeMiddleBackPercentage(
                              isDecrease: true);
                        },
                        percentage: controller.middleBackPercentage.value,
                        intensityColor: controller.middleBackIntensityColor,
                        programStatus: controller.programsStatus[5].status!.value,
                        onPress: (){
                          if(controller.programsStatus[5].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.middleBack,
                              controller.programsStatus[5].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.middleBackPercentage.value = 0;
                          controller.middleBackIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.middleBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[5].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Lumbars
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
                        programStatus: controller.programsStatus[6].status!.value,
                        onPress: (){
                          if(controller.programsStatus[6].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.lowerBack,
                              controller.programsStatus[6].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.lumbarPercentage.value = 0;
                          controller.lumbarsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.lowerBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[6].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Buttocks - always visible
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
                        programStatus: controller.programsStatus[7].status!.value,
                        onPress: (){
                          if(controller.programsStatus[7].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.glutes,
                              controller.programsStatus[7].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.buttocksPercentage.value = 0;
                          controller.buttocksIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.glutes,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[7].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Hamstrings - always visible
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).hamstrings,
                        image: Strings.hamstringsIcon,
                        onIncrease: () {
                          controller.changeHamStringsPercentage(
                              isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeHamStringsPercentage(
                              isDecrease: true);
                        },
                        percentage: controller.hamStringsPercentage.value,
                        intensityColor: controller.hamstringsIntensityColor,
                        programStatus: controller.programsStatus[8].status!.value,
                        onPress: (){
                          if(controller.programsStatus[8].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.hamstrings,
                              controller.programsStatus[8].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.hamStringsPercentage.value = 0;
                          controller.hamstringsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.hamstrings,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[8].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
