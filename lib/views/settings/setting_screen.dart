import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/setting_controller.dart';
import 'package:i_model/views/settings/security_verification.dart';
import 'package:i_model/widgets/menu_widget.dart';
import 'package:i_model/views/settings/backup_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/views/settings/select_language.dart';
import 'package:i_model/views/settings/technical_service.dart';
import 'package:i_model/widgets/textview.dart';

import 'technical_support.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final SettingController settingController = Get.put(SettingController());

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
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.07,
            left: screenHeight * 0.1,
            right: screenHeight * 0.04,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView.title(translation(context).settings,
                        isUnderLine: true, color: AppColors.pinkColor),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage(
                          Strings.backIcon,
                        ),
                        height: screenHeight * 0.1,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Menu list
                    Column(
                      children: [
                        MenuWidget(
                          title: translation(context).license,
                          onTap: () {
                            Navigator.pushNamed(context, Strings.licenseScreen);
                          },
                        ),
                        MenuWidget(
                          title: translation(context).centerManagement,
                          onTap: () {
                            Navigator.pushNamed(
                                context, Strings.centerManagementScreen);
                          },
                        ),
                        MenuWidget(
                          title: translation(context).backup,
                          onTap: () {
                            settingController.displayBackUpService();
                          },
                        ),
                        MenuWidget(
                          title: translation(context).selectLanguage,
                          onTap: () {
                            settingController.displaySelectLanguage();
                          },
                        ),
                        MenuWidget(
                          title: translation(context).technicalService,
                          onTap: () {
                            settingController.displayTechnicalService();
                          },
                        ),
                      ],
                    ),

                    /// Displaying data based on click
                    Obx(
                      () => settingController.isIdle.value
                          ? Padding(
                              padding: EdgeInsets.only(right: screenWidth * 0.05),
                              child: imageWidget(
                                image: Strings.logoIModel,
                                height: screenHeight * 0.2,
                              ),
                            )

                          /// Servicio Tecnico
                          : settingController.isTechnicalService.value
                              ? TechnicalService(
                                  onCancel: () {
                                    settingController.displayLogo();
                                  },
                                  onClickSettings: (){
                                    settingController.displaySecurityVerification();
                                  },
                                )

                          /// Security Verification
                          : settingController.isSecurityVerification.value
                                  ? SecurityVerification(
                                      onCancel: () {
                                        settingController.textEditingController.clear();
                                        settingController.displayLogo();
                                      },
                                    )
                        /// Technical Contact support
                            : settingController.isContactSupport.value
                            ? TechnicalSupport(
                          onCancel: () {
                            settingController.textEditingController.clear();
                            settingController.displayLogo();
                          },
                        )
                          /// Copia de seguridad
                              : settingController.isBackUp.value
                                  ? BackupWidget(
                                      onTapMakeCopy: () {
                                        settingController.selectMakeCopy();
                                      },
                                      onTapReStoreCopy: () {
                                        settingController.selectReStoreCopy();
                                      },
                                      onCancel: () {
                                        settingController.displayLogo();
                                      },
                                      isMakeCopySelected: settingController.isMakeCopySelected.value,
                                      isReStoreCopySelected: settingController.isReStoreCopySelected.value,
                                      isYesSelected: settingController.isYesSelected.value,
                                      isNoSelected: settingController.isNoSelected.value,
                                      onTapYes: () {
                                        settingController.selectYes();
                                        if (settingController.isMakeCopySelected.value) {
                                          /// Hacer Copia Codigo aqui
                                        }
                                        if (settingController.isReStoreCopySelected.value) {
                                          /// Restaurar copia codigo aqui
                                        }
                                      },
                                      onTapNo: () {
                                        settingController.selectNo();
                                      },
                                    )
                                      /// Language selection
                                  : settingController.isSelectLanguage.value
                                      ? SelectLanguage(
                                          onCancel: () {
                                            settingController.displayLogo();
                                          },
                                        )
                                      : Container(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
