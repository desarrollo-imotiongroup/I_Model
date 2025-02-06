import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
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
                  )
                : Column(
                    key: ValueKey('noPantSelectedBodyParts'),
                    children: [
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
                      ),
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
          ),
        ],
      ),
    );
  }
}
