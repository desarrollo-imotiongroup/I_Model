import 'package:get/get.dart';

class LoginController extends GetxController{
  RxBool isObscured = true.obs;

  changeVisibility(){
    isObscured.value = !isObscured.value;
    update();
  }
}