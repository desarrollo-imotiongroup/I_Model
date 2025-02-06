import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
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
                      ),

                      /// Hamstrings - always visible
                      DashboardBodyProgram(
                        key: ValueKey('hamstrings'),
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
                      ),
                    ],
                  )
                : Column(
                    key: ValueKey('noPantSelectedBodyParts'),
                    children: [
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
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
