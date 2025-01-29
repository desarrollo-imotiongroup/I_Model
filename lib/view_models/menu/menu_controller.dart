import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MenuScreenController extends GetxController{
  RxBool isBiomPedancia = false.obs;
  RxBool isBiomPedanciaDevice = false.obs;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController genderEditingController = TextEditingController();
  final TextEditingController heightEditingController = TextEditingController();
  final TextEditingController weightEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();

  dismissBiomPedanciaState(){
    isBiomPedancia.value = false;
  }

  @override
  void onClose() {
    nameEditingController.dispose();
    genderEditingController.dispose();
    heightEditingController.dispose();
    weightEditingController.dispose();
    emailEditingController.dispose();
  }
}