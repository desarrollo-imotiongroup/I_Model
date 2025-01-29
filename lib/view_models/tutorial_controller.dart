import 'package:get/get.dart';

class TutorialController extends GetxController{
  RxBool isFirstStep = false.obs;

  dismissFirstStepState(){
    isFirstStep.value = false;
  }

}