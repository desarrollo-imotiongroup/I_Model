import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/login_controller.dart';
import 'package:i_model/view_models/menu/menu_controller.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/widgets/with_device_biompedancia.dart';
import 'package:i_model/widgets/without_device_biompedancia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'overlays/alert_overlay.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final MenuScreenController menuController = Get.put(MenuScreenController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    void closeSession(){
      alertOverlay(context,
          heading: Strings.areYouSure,
          description: Strings.backToLogin,
          buttonText: translation(context).yesDelete,
          onPress: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('user_id');
            loginController.isLoggedIn.value = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              Strings.initialScreen, (route) => false,
            );
          });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        closeSession();
      },
      child: Scaffold(
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
                    child: GestureDetector(
                      onTap: (){
                        closeSession();
                      },
                      child: Image(
                        image: AssetImage(
                          Strings.ignitionIcon,
                        ),
                        height: screenHeight * 0.1,
                      ),
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
                          (menuController.isBiomPedancia.value && !menuController.isBiomPedanciaDevice.value)
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
      ),
    );
  }
}
