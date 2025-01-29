import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/menu/menu_controller.dart';
import 'package:i_model/widgets/with_device_biompedancia.dart';
import 'package:i_model/widgets/without_device_biompedancia.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/technical_service.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final MenuScreenController menuController = Get.put(MenuScreenController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Strings.bgImage,
                ),
                fit: BoxFit.cover)),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.07,
            left: screenHeight * 0.1,
            right: screenHeight * 0.04,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Image(
                    image: AssetImage(
                      Strings.ignitionIcon,
                    ),
                    height: screenHeight * 0.1,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Menu list
                        Column(
                          children: [
                            MenuWidget(
                              title: translation(context).controlPanel,
                              onTap: () {
                                menuController.dismissBiomPedanciaState();
                                Navigator.pushNamed(
                                    context, Strings.dashboardScreen);
                              },
                            ),
                            MenuWidget(
                              title: translation(context).clients,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Strings.clientScreen);
                                menuController.dismissBiomPedanciaState();
                              },
                            ),
                            MenuWidget(
                              title: translation(context).programs,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Strings.programsScreen);
                                menuController.dismissBiomPedanciaState();
                              },
                            ),
                            MenuWidget(
                              title: translation(context).biompedancia,
                              onTap: () {
                                menuController.isBiomPedancia.value = true;
                                if (menuController.isBiomPedanciaDevice.value) {
                                  withDeviceBiompedancia(context);
                                }
                              },
                            ),
                            MenuWidget(
                              title: translation(context).tutorials,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Strings.tutorialScreen);
                                menuController.dismissBiomPedanciaState();
                              },
                            ),
                            MenuWidget(
                              title: translation(context).settings,
                              onTap: () {
                                menuController.dismissBiomPedanciaState();
                                Navigator.pushNamed(
                                    context, Strings.settingScreen);
                              },
                            ),
                          ],
                        ),
                        (menuController.isBiomPedancia.value &&
                                !menuController.isBiomPedanciaDevice.value)
                            ? WithoutDeviceBiompedancia(
                                onCancel: () {
                                  menuController.dismissBiomPedanciaState();
                                },
                              )
                            : Padding(
                                padding:
                                    EdgeInsets.only(right: screenWidth * 0.05),
                                child: imageWidget(
                                  image: Strings.logoIModel,
                                  height: screenHeight * 0.2,
                                ),
                              )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
