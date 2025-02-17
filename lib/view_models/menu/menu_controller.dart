import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MenuScreenController extends GetxController{
  RxBool isBiomPedancia = false.obs;
  RxBool isBiomPedanciaDevice = true.obs;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController genderEditingController = TextEditingController();
  final TextEditingController heightEditingController = TextEditingController();
  final TextEditingController weightEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();

  dismissBiomPedanciaState(){
    isBiomPedancia.value = false;
  }

  setTextFieldsData(Map<String, dynamic> clientData){
    nameEditingController.text = clientData['name'];
    genderEditingController.text = clientData['gender'];
    heightEditingController.text = clientData['height'].toString();
    weightEditingController.text = clientData['weight'].toString();
    emailEditingController.text = clientData['email'];
    update();
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