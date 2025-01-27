import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/view_models/setting_controller.dart';
import 'package:i_model/views/menu_widget.dart';
import 'package:i_model/widgets/backup_widget.dart';
import 'package:i_model/widgets/image_widget.dart';
import 'package:i_model/widgets/select_language.dart';
import 'package:i_model/widgets/technical_service.dart';
import 'package:i_model/widgets/textview.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});

  final SettingController settingScreenController =
      Get.put(SettingController());

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
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.07,
            left: screenHeight * 0.1,
            right: screenHeight * 0.04,
          ),
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
                        // title: Strings.license,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).centerManagement,
                        onTap: () {},
                      ),
                      MenuWidget(
                        title: translation(context).backup,
                        onTap: () {
                          settingScreenController.displayBackUpService();
                        },
                      ),
                      MenuWidget(
                        title: translation(context).selectLanguage,
                        onTap: () {
                          settingScreenController.displaySelectLanguage();
                        },
                      ),
                      MenuWidget(
                        title: translation(context).technicalService,
                        onTap: () {
                          settingScreenController.displayTechnicalService();
                        },
                      ),
                    ],
                  ),

                  Obx(
                    () => settingScreenController.isIdle.value
                        ? Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.05),
                            child: imageWidget(
                              image: Strings.logoIModel,
                              height: screenHeight * 0.2,
                            ),
                          )
                          /// Servicio Tecnico
                        : settingScreenController.isTechnicalService.value
                            ? TechnicalService(
                                onCancel: () {
                                  settingScreenController.displayLogo();
                                },
                              )
                          /// Copia de seguridad
                        : settingScreenController.isBackUp.value
                                ? BackupWidget(
                                    onTapMakeCopy: () {
                                      settingScreenController.selectMakeCopy();
                                    },
                                    onTapReStoreCopy: () {
                                      settingScreenController
                                          .selectReStoreCopy();
                                    },
                                    onCancel: () {
                                      settingScreenController.displayLogo();
                                    },
                                    isMakeCopySelected: settingScreenController
                                        .isMakeCopySelected.value,
                                    isReStoreCopySelected:
                                        settingScreenController
                                            .isReStoreCopySelected.value,
                                    isYesSelected: settingScreenController.isYesSelected.value,
                                    isNoSelected: settingScreenController.isNoSelected.value,
                                    onTapYes: (){
                                      settingScreenController.selectYes();
                                      if(settingScreenController.isMakeCopySelected.value){
                                        /// Hacer Copia Codigo aqui
                                      }
                                      if(settingScreenController.isReStoreCopySelected.value){
                                        /// Restaurar copia codigo aqui
                                      }
                                    },
                                    onTapNo:(){
                                      settingScreenController.selectNo();
                                    },

                                  )
                        : settingScreenController.isSelectLanguage.value
                                ? SelectLanguage(
                                    onCancel: () {
                                      settingScreenController.displayLogo();
                                  },)
                        : Container(),
                  )

                  /// Displaying data based on click
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
