import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/client/client_controller.dart';
import 'package:i_model/view_models/dashboard_controller.dart';
import 'package:i_model/views/overlays/select_client_overlay.dart';
import 'package:i_model/widgets/dashboard_body_program.dart';
import 'package:i_model/widgets/image_widget.dart';

class DashboardFirstColumn extends StatelessWidget {
  DashboardFirstColumn({super.key});

  final DashboardController dashboardController = Get.put(DashboardController());

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
                     selectClientOverlay(context);
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
                    dashboardController.changeSuitSelection();
                  },
                  child: imageWidget(
                    image: dashboardController.isPantSelected.value
                        ? Strings.selectedPantIcon
                        : Strings.completeSuitSelected,
                    height: screenHeight * 0.08,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: dashboardController.isPantSelected.value ? screenHeight * 0.03 : 0,
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: dashboardController.isPantSelected.value
                ? Column(
                    key: ValueKey('pantSelectedBodyParts'),
                    children: [
                      /// Arms when selected pants
                      DashboardBodyProgram(
                        title: translation(context).arms,
                        image: Strings.armsIcon,
                        onIncrease: () {
                          dashboardController.changeArmsPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeArmsPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.armsPercentage.value,
                        intensityColor: dashboardController.armsIntensityColor,
                        programStatus: dashboardController.programsStatus[1].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[1].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.arms,
                              dashboardController.programsStatus[1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.armsPercentage.value = 0;
                          dashboardController.armsIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[1].status!.value)
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
                          dashboardController.changeAbdomenPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeAbdomenPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.abdomenPercentage.value,
                        intensityColor: dashboardController.abdomenIntensityColor,
                        programStatus: dashboardController.programsStatus[2].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[2].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.abdomen,
                              dashboardController.programsStatus[2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.abdomenPercentage.value = 0;
                          dashboardController.abdomenIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[2].status!.value)
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
                          dashboardController.changeLegsPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeLegsPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.legsPercentage.value,
                        intensityColor: dashboardController.legsIntensityColor,
                        programStatus: dashboardController.programsStatus[3].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[3].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.legs,
                              dashboardController.programsStatus[3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.legsPercentage.value = 0;
                          dashboardController.legsIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[3].status!.value)
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
                          dashboardController.changeChestPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeChestPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.chestPercentage.value,
                        intensityColor: dashboardController.chestIntensityColor,
                        programStatus: dashboardController.programsStatus[0].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[0].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                            Strings.chest,
                            dashboardController.programsStatus[0].status!.value == ProgramStatus.active
                                ? ProgramStatus.blocked
                                : ProgramStatus.active,
                          );
                          }
                        },
                        onLongPress: (){
                          dashboardController.chestPercentage.value = 0;
                          dashboardController.chestIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.chest,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[0].status!.value)
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
                          dashboardController.changeArmsPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeArmsPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.armsPercentage.value,
                        intensityColor: dashboardController.armsIntensityColor,
                        programStatus: dashboardController.programsStatus[1].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[1].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.arms,
                              dashboardController.programsStatus[1].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.armsPercentage.value = 0;
                          dashboardController.armsIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.arms,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[1].status!.value)
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
                          dashboardController.changeAbdomenPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeAbdomenPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.abdomenPercentage.value,
                        intensityColor: dashboardController.abdomenIntensityColor,
                        programStatus: dashboardController.programsStatus[2].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[2].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.abdomen,
                              dashboardController.programsStatus[2].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.abdomenPercentage.value = 0;
                          dashboardController.abdomenIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.abdomen,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[2].status!.value)
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
                          dashboardController.changeLegsPercentage(isIncrease: true);
                        },
                        onDecrease: () {
                          dashboardController.changeLegsPercentage(isDecrease: true);
                        },
                        percentage: dashboardController.legsPercentage.value,
                        intensityColor: dashboardController.legsIntensityColor,
                        programStatus: dashboardController.programsStatus[3].status!.value,
                        onPress: (){
                          if(dashboardController.programsStatus[3].status!.value != ProgramStatus.inactive) {
                            dashboardController.updateProgramStatus(
                              Strings.legs,
                              dashboardController.programsStatus[3].status!.value == ProgramStatus.active
                                  ? ProgramStatus.blocked
                                  : ProgramStatus.active,
                            );
                          }
                        },
                        onLongPress: (){
                          dashboardController.legsPercentage.value = 0;
                          dashboardController.legsIntensityColor = AppColors.lowIntensityColor;
                          dashboardController.updateProgramStatus(
                            Strings.legs,
                            [ProgramStatus.active, ProgramStatus.blocked].contains(dashboardController.programsStatus[3].status!.value)
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
