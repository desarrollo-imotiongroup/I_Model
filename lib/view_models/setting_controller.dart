import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';

class SettingController extends GetxController {
  RxBool isIdle = true.obs;
  RxBool isTechnicalService = false.obs;
  RxBool isSecurityVerification = false.obs;
  RxBool isContactSupport = false.obs;
  RxBool isBackUp = false.obs;
  RxBool isSelectLanguage = false.obs;
  RxBool isMakeCopySelected = false.obs;
  RxBool isReStoreCopySelected = false.obs;
  RxBool isYesSelected = false.obs;
  RxBool isNoSelected = false.obs;

  @override
  void onInit() {
    generateRandomNumbers();
    super.onInit();
  }

  void displayLogo() {
    isIdle.value = true;
    isTechnicalService.value = false;
    isTechnicalService.value = false;
    isBackUp.value = false;
    isMakeCopySelected.value = false;
    isReStoreCopySelected.value = false;
    isYesSelected.value = false;
    isNoSelected.value = false;
  }

  void displayTechnicalService() {
    isIdle.value = false;
    isTechnicalService.value = true;
    isBackUp.value = false;
    isSelectLanguage.value = false;
    isSecurityVerification.value = false;
    isContactSupport.value = false;
  }

  void displaySecurityVerification() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isBackUp.value = false;
    isSelectLanguage.value = false;
    isSecurityVerification.value = true;
    isContactSupport.value = false;
  }

  void displayContactSupport() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isBackUp.value = false;
    isSelectLanguage.value = false;
    isSecurityVerification.value = false;
    isContactSupport.value = true;
  }


  void displaySelectLanguage() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isBackUp.value = false;
    isSelectLanguage.value = true;
    isSecurityVerification.value = false;
    isContactSupport.value = false;

  }

  void displayBackUpService() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isSelectLanguage.value = true;
    isBackUp.value = true;
    isSecurityVerification.value = false;
    isContactSupport.value = false;
  }

  void selectMakeCopy() {
    isMakeCopySelected.value = true;
    isReStoreCopySelected.value = false;
    isNoSelected.value = false;
    isYesSelected.value = false;
    isSecurityVerification.value = false;
    isContactSupport.value = false;
  }

  void selectReStoreCopy(){
    isMakeCopySelected.value = false;
    isReStoreCopySelected.value = true;
    isNoSelected.value = false;
    isYesSelected.value = false;
    isSecurityVerification.value = false;
    isContactSupport.value = false;
  }

  void selectYes(){
    isYesSelected.value = true;
    isNoSelected.value = false;
  }

  void selectNo(){
    isYesSelected.value = false;
    isNoSelected.value = true;
  }

  /// Security verification
  final TextEditingController textEditingController = TextEditingController();
  RxList<int> randomNumbers = <int>[].obs;
  RxInt sum = 0.obs;


  void generateRandomNumbers() {
    Random random = Random();
    randomNumbers.value = List.generate(4, (index) => random.nextInt(15) + 1);
    sum.value = randomNumbers.fold(0, (previousValue, element) => previousValue + element);
  }

  verify(BuildContext context){
    if(textEditingController.text.isEmpty){
      alertOverlay(
          context,
          isOneButtonNeeded: true,
          heading: translation(context).alertCompleteForm,
          description: translation(context).emptySecurityVerifyNumber
      );
    }
    else if(sum.value != int.parse(textEditingController.text)){
      HelperMethods.showSnackBar(
          context,
          title: translation(context).incorrectResult
      );
    }
    else{
      displayContactSupport();
    }
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

}
