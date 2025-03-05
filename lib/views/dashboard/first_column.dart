import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/overlays/select_client_overlay.dart';
import 'package:i_model/widgets/dashboard_body_program.dart';
import 'package:i_model/widgets/image_widget.dart';

class DashboardFirstColumn extends StatelessWidget {
  final int index;

  DashboardFirstColumn({required this.index, super.key});

  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.025),
          SizedBox(
            width: screenWidth * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: imageWidget(
                    image: Strings.selectClientIcon,
                    height: screenHeight * 0.08,
                  ),
                  onTap: (){
                     selectClientOverlay(
                         context,
                        deviceIndex: controller.selectedDeviceIndex.value,
                        selectedClientNames: controller.selectedClientNames,
                        onClientSelectedForDevice: (int deviceIndex, clientData) {
                         if (clientData != null) {
                           controller.setClientInfoForDevice(deviceIndex, clientData);
                         }
                       },
                     );
                  },
                ),
                GestureDetector(
                  onTap: (){
                  },
                  child: imageWidget(
                    image: Strings.repeatSession,
                    height: screenHeight * 0.08,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(controller.isTimerPaused[index]) {
                      controller.changeSuitSelection();
                    }
                  },
                  child: imageWidget(
                    image: controller.isPantSelected[index]
                        ? Strings.selectedPantIcon
                        : Strings.completeSuitSelected,
                    height: screenHeight * 0.08,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: controller.isPantSelected[index] ? screenHeight * 0.03 : 0,
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isPantSelected[index]
                ? Column(
                    key: ValueKey('pantSelectedBodyParts'),
                    children: [
                      /// Arms when selected pants
                      DashboardBodyProgram(
                        title: translation(context).arms,
                        image: Strings.armsIcon,
                        onIncrease: () {
                          controller.changeArmsPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeArmsPercentage(index, isDecrease: true);
                        },
                        percentage: controller.armsPercentage[index],
                        intensityColor: controller.armsIntensityColor[index],
                        programStatus: controller.programsStatus[index][1].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][1].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.arms,
                              controller.programsStatus[index][1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.armsPercentage[index] = 0;
                          controller.armsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][1].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                            inActive: true,
                            deviceIndex: index,
                            canal: 0,
                            percentage: 0
                          );
                        },
                      ),

                      /// Abdomen when selected pants
                      DashboardBodyProgram(
                        title: translation(context).abdomen,
                        image: Strings.abdomenIcon,
                        onIncrease: () {
                          controller.changeAbdomenPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeAbdomenPercentage(index, isDecrease: true);
                        },
                        percentage: controller.abdomenPercentage[index],
                        intensityColor: controller.abdomenIntensityColor[index],
                        programStatus: controller.programsStatus[index][2].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][2].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.abdomen,
                              controller.programsStatus[index][2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.abdomenPercentage[index] = 0;
                          controller.abdomenIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][2].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 1,
                              percentage: 0
                          );
                        },
                      ),

                      /// Legs when selected pants
                      DashboardBodyProgram(
                        title: translation(context).legs,
                        image: Strings.legsIcon,
                        onIncrease: () {
                          controller.changeLegsPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeLegsPercentage(index, isDecrease: true);
                        },
                        percentage: controller.legsPercentage[index],
                        intensityColor: controller.legsIntensityColor[index],
                        programStatus: controller.programsStatus[index][3].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][3].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.legs,
                              controller.programsStatus[index][3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                                inActive: true,
                                deviceIndex: index,
                                canal: 2,
                                percentage: 0
                            );
                          }
                        },
                        onLongPress: (){
                          controller.legsPercentage[index] = 0;
                          controller.legsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][3].status!.value)
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
                      /// Chest
                      DashboardBodyProgram(
                        title: translation(context).chest,
                        image: Strings.chestIcon,
                        onIncrease: () {
                          controller.changeChestPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeChestPercentage(index, isDecrease: true);
                        },
                        percentage: controller.chestPercentage[index],
                        intensityColor: controller.chestIntensityColor[index],
                        programStatus: controller.programsStatus[index][0].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][0].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                            Strings.chest,
                            controller.programsStatus[index][0].status!.value == ProgramStatus.active
                                ? ProgramStatus.blocked
                                : ProgramStatus.active,
                          );
                          }
                        },
                        onLongPress: (){
                          controller.chestPercentage[index] = 0;
                          controller.chestIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.chest,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][0].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 5,
                              percentage: 0
                          );
                        },
                      ),

                      /// Arms
                      DashboardBodyProgram(
                        title: translation(context).arms,
                        image: Strings.armsIcon,
                        onIncrease: () {
                          controller.changeArmsPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeArmsPercentage(index, isDecrease: true);
                        },
                        percentage: controller.armsPercentage[index],
                        intensityColor: controller.armsIntensityColor[index],
                        programStatus: controller.programsStatus[index][1].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][1].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.arms,
                              controller.programsStatus[index][1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,

                            );
                          }
                        },
                        onLongPress: (){
                          controller.armsPercentage[index] = 0;
                          controller.armsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][1].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 8,
                              percentage: 0
                          );
                        },
                      ),

                      /// Abdomen
                      DashboardBodyProgram(
                        title: translation(context).abdomen,
                        image: Strings.abdomenIcon,
                        onIncrease: () {
                          controller.changeAbdomenPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeAbdomenPercentage(index, isDecrease: true);
                        },
                        percentage: controller.abdomenPercentage[index],
                        intensityColor: controller.abdomenIntensityColor[index],
                        programStatus: controller.programsStatus[index][2].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][2].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.abdomen,
                              controller.programsStatus[index][2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                                inActive: true,
                                deviceIndex: index,
                                canal: 6,
                                percentage: 0
                            );
                          }
                        },
                        onLongPress: (){
                          controller.abdomenPercentage[index] = 0;
                          controller.abdomenIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][2].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Legs
                      DashboardBodyProgram(
                        title: translation(context).legs,
                        image: Strings.legsIcon,
                        onIncrease: () {
                          controller.changeLegsPercentage(index, isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeLegsPercentage(index, isDecrease: true);
                        },
                        percentage: controller.legsPercentage[index],
                        intensityColor: controller.legsIntensityColor[index],
                        programStatus: controller.programsStatus[index][3].status!.value,
                        onPress: (){
                          if(controller.programsStatus[index][3].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.legs,
                              controller.programsStatus[index][3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.legsPercentage[index] = 0;
                          controller.legsIntensityColor[index] = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[index][3].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                              inActive: true,
                              deviceIndex: index,
                              canal: 7,
                              percentage: 0
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
