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
  DashboardFirstColumn({super.key});

  final DashboardController controller = Get.put(DashboardController());

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
                  onTap: (){
                    selectClientOverlay(context);
                  },
                  child: imageWidget(
                    image: Strings.selectClientIcon,
                    height: screenHeight * 0.08,
                  ),
                ),
                imageWidget(
                  image: Strings.repeatSession,
                  height: screenHeight * 0.08,
                ),
                GestureDetector(
                  onTap: () {
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
          SizedBox(
            height: controller.isPantSelected.value ? screenHeight * 0.03 : 0,
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isPantSelected.value
                ? Column(
                    key: ValueKey('pantSelectedBodyParts'),
                    children: [
                      /// Arms when selected pants
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
                        programStatus: controller.programsStatus[1].status!.value,
                        onPress: (){
                          if(controller.programsStatus[1].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.arms,
                              controller.programsStatus[1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.armsPercentage.value = 0;
                          controller.armsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[1].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Abdomen when selected pants
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
                        programStatus: controller.programsStatus[2].status!.value,
                        onPress: (){
                          if(controller.programsStatus[2].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.abdomen,
                              controller.programsStatus[2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.abdomenPercentage.value = 0;
                          controller.abdomenIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[2].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
                      ),

                      /// Legs when selected pants
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
                        programStatus: controller.programsStatus[3].status!.value,
                        onPress: (){
                          if(controller.programsStatus[3].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.legs,
                              controller.programsStatus[3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.legsPercentage.value = 0;
                          controller.legsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[3].status!.value)
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
                          controller.changeChestPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeChestPercentage(isDecrease: true);
                        },
                        percentage: controller.chestPercentage.value,
                        intensityColor: controller.chestIntensityColor,
                        programStatus: controller.programsStatus[0].status!.value,
                        onPress: (){
                          if(controller.programsStatus[0].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                            Strings.chest,
                            controller.programsStatus[0].status!.value == ProgramStatus.active
                                ? ProgramStatus.blocked
                                : ProgramStatus.active,
                          );
                          }
                        },
                        onLongPress: (){
                          controller.chestPercentage.value = 0;
                          controller.chestIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.chest,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[0].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
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
                        programStatus: controller.programsStatus[1].status!.value,
                        onPress: (){
                          if(controller.programsStatus[1].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.arms,
                              controller.programsStatus[1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.armsPercentage.value = 0;
                          controller.armsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[1].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
                          );
                        },
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
                        programStatus: controller.programsStatus[2].status!.value,
                        onPress: (){
                          if(controller.programsStatus[2].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.abdomen,
                              controller.programsStatus[2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.abdomenPercentage.value = 0;
                          controller.abdomenIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[2].status!.value)
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
                          controller.changeLegsPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          controller.changeLegsPercentage(isDecrease: true);
                        },
                        percentage: controller.legsPercentage.value,
                        intensityColor: controller.legsIntensityColor,
                        programStatus: controller.programsStatus[3].status!.value,
                        onPress: (){
                          if(controller.programsStatus[3].status!.value != ProgramStatus.inactive) {
                            controller.updateProgramStatus(
                              Strings.legs,
                              controller.programsStatus[3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          controller.legsPercentage.value = 0;
                          controller.legsIntensityColor = AppColors.lowIntensityColor;
                          controller.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(controller.programsStatus[3].status!.value)
                                ? ProgramStatus.inactive
                                : ProgramStatus.active,
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
