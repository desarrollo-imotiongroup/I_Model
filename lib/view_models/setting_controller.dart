import 'package:get/get.dart';

class SettingController extends GetxController {
  RxBool isIdle = true.obs;
  RxBool isTechnicalService = false.obs;
  RxBool isBackUp = false.obs;
  RxBool isSelectLanguage = false.obs;
  RxBool isMakeCopySelected = false.obs;
  RxBool isReStoreCopySelected = false.obs;
  RxBool isYesSelected = false.obs;
  RxBool isNoSelected = false.obs;

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
  }

  void displaySelectLanguage() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isBackUp.value = false;
    isSelectLanguage.value = true;

  }

  void displayBackUpService() {
    isIdle.value = false;
    isTechnicalService.value = false;
    isSelectLanguage.value = true;
    isBackUp.value = true;
  }

  void selectMakeCopy() {
    isMakeCopySelected.value = true;
    isReStoreCopySelected.value = false;
    isNoSelected.value = false;
    isYesSelected.value = false;
  }

  void selectReStoreCopy(){
    isMakeCopySelected.value = false;
    isReStoreCopySelected.value = true;
    isNoSelected.value = false;
    isYesSelected.value = false;
  }

  void selectYes(){
    isYesSelected.value = true;
    isNoSelected.value = false;
  }

  void selectNo(){
    isYesSelected.value = false;
    isNoSelected.value = true;
  }
}
