import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/widgets/dashboard_body_program.dart';

class DashboardThirdColumn extends StatelessWidget {
  final int index;
  DashboardThirdColumn({required this.index, super.key});

  final DashboardController controller = Get.find<DashboardController>();

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
            child: controller.isPantSelected[index]
                ? SizedBox(height: screenHeight * 0.12)
                : Container(),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isPantSelected[index]
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
                          controller.changeButtocksPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeButtocksPercentage(index, isDecrease: true);
                        },
                        percentage: controller.buttocksPercentage[index],
                        intensityColor: controller.buttocksIntensityColor[index],
                        programStatus: controller.programsStatus[index][7].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][7].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.glutes,
                              controller.programsStatus[index][7].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.buttocksPercentage[index] = 0;
                          controller.buttocksIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.glutes,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][7].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 5,
                              percentage: 0
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
                          controller.changeHamStringsPercentage(index, isIncrease: true);},
                        onDecrease: () {
                          controller.changeHamStringsPercentage(index, isDecrease: true);},
                        percentage: controller.hamStringsPercentage[index],
                        intensityColor: controller.hamstringsIntensityColor[index],
                        programStatus: controller.programsStatus[index][8].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][8].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.hamstrings,
                              controller.programsStatus[index][8].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.hamStringsPercentage[index] = 0;
                          controller.hamstringsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.hamstrings,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][8].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 6,
                              percentage: 0
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
                          controller.changeCalvesPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeCalvesPercentage(index, isDecrease: true);
                        },
                        percentage: controller.calvesPercentage[index],
                        intensityColor: controller.calvesIntensityColor[index],
                        programStatus: controller.programsStatus[index][9].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][9].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.calves,
                              controller.programsStatus[index][9].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.calvesPercentage[index] = 0;
                          controller.calvesIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.calves,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][9].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 3,
                              percentage: 0
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
                          controller.changeUpperBackPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeUpperBackPercentage(index, isDecrease: true);
                        },
                        percentage: controller.upperBackPercentage[index],
                        intensityColor: controller.upperBackIntensityColor[index],
                        programStatus: controller.programsStatus[index][4].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][4].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.upperBack,
                              controller.programsStatus[index][4].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.upperBackPercentage[index] = 0;
                          controller.upperBackIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.upperBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][4].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 0,
                              percentage: 0
                          );
                        },
                      ),

                      /// Middle back
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).middleBack,
                        image: Strings.middleBackIcon,
                        onIncrease: () {
                          controller.changeMiddleBackPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeMiddleBackPercentage(index, isDecrease: true);
                        },
                        percentage: controller.middleBackPercentage[index],
                        intensityColor: controller.middleBackIntensityColor[index],
                        programStatus: controller.programsStatus[index][5].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][5].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.middleBack,
                              controller.programsStatus[index][5].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.middleBackPercentage[index] = 0;
                          controller.middleBackIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.middleBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][5].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 1,
                              percentage: 0
                          );
                        },
                      ),

                      /// Lumbars
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).lumbars,
                        image: Strings.lumbarsIcon,
                        onIncrease: () {
                          controller.changeLumbarPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeLumbarPercentage(index, isDecrease: true);
                        },
                        percentage: controller.lumbarPercentage[index],
                        intensityColor: controller.lumbarsIntensityColor[index],
                        programStatus: controller.programsStatus[index][6].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][6].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.lowerBack,
                              controller.programsStatus[index][6].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.lumbarPercentage[index] = 0;
                          controller.lumbarsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.lowerBack,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][6].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 2,
                              percentage: 0
                          );
                        },
                      ),

                      /// Buttocks - always visible
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).buttocks,
                        image: Strings.buttocksIcon,
                        onIncrease: () {
                          controller.changeButtocksPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeButtocksPercentage(index, isDecrease: true);
                        },
                        percentage: controller.buttocksPercentage[index],
                        intensityColor: controller.buttocksIntensityColor[index],
                        programStatus: controller.programsStatus[index][7].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][7].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.glutes,
                              controller.programsStatus[index][7].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.buttocksPercentage[index] = 0;
                          controller.buttocksIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.glutes,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][7].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 3,
                              percentage: 0
                          );
                        },
                      ),

                      /// Hamstrings - always visible
                      DashboardBodyProgram(
                        isImageLeading: false,
                        title: translation(context).hamstrings,
                        image: Strings.hamstringsIcon,
                        onIncrease: () {
                          controller.changeHamStringsPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeHamStringsPercentage(index, isDecrease: true);
                        },
                        percentage: controller.hamStringsPercentage[index],
                        intensityColor: controller.hamstringsIntensityColor[index],
                        programStatus: controller.programsStatus[index][8].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][8].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.hamstrings,
                              controller.programsStatus[index][8].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.hamStringsPercentage[index] = 0;
                          controller.hamstringsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.hamstrings,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][8].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 4,
                              percentage: 0
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
