import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/client/client_points.dart';

class CreateNewClientController extends GetxController {
  List<String> clientStatusList = [Strings.active, Strings.inactive, Strings.all];
  List<String> genderList = [Strings.man, Strings.women];
  RxString selectedStatus = Strings.active.obs;

  /// Client Personal data values
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientDobController = TextEditingController();
  final TextEditingController clientPhoneController = TextEditingController();
  final TextEditingController clientHeightController = TextEditingController();
  final TextEditingController clientWeightController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  RxString clientSelectedGender = Strings.nothing.obs;

  @override
  void onClose() {
    clientNameController.dispose();
    clientDobController.dispose();
    clientPhoneController.dispose();
    clientHeightController.dispose();
    clientWeightController.dispose();
    clientEmailController.dispose();
    super.onClose();
  }


  pickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      clientDobController.text = birthDate;
    }
    update();
  }


  /// Client bonos/points
  /// Available points list
  final TextEditingController pointsTextEditingController = TextEditingController();
  RxList<dynamic> availablePoints = [].obs;
  RxInt totalAvailablePoints = 0.obs;

  buyPoints(){
    availablePoints.add(ClientPoints(date: '01/02/25', quantity: int.parse(pointsTextEditingController.text)));
    totalAvailablePoints = totalAvailablePoints + int.parse(pointsTextEditingController.text);
    pointsTextEditingController.clear();
    update();
  }

  /// Consumed points list
  RxList<ClientPoints> consumedPoints = [
    ClientPoints(date: '01/01/2025', quantity: 50, hour: '08:30'),
    ClientPoints(date: '02/01/2025', quantity: 40, hour: '14:15'),
    ClientPoints(date: '03/01/2025', quantity: 30, hour: '09:45'),
    ClientPoints(date: '04/01/2025', quantity: 60, hour: '11:00'),
    ClientPoints(date: '05/01/2025', quantity: 20, hour: '16:20'),
    ClientPoints(date: '06/01/2025', quantity: 80, hour: '13:10'),
    ClientPoints(date: '07/01/2025', quantity: 35, hour: '17:50'),
    ClientPoints(date: '08/01/2025', quantity: 55, hour: '10:00'),
    ClientPoints(date: '09/01/2025', quantity: 45, hour: '12:30'),
    ClientPoints(date: '10/01/2025', quantity: 25, hour: '15:40'),
  ].obs;


  /// Active Groups
  RxBool isUpperBackChecked = false.obs;
  RxBool isMiddleBackChecked = false.obs;
  RxBool isLowerBackChecked = false.obs; /// Lumbares
  RxBool isGlutesChecked = false.obs;
  RxBool isHamstringsChecked = false.obs; /// isquios
  RxBool isChestChecked = false.obs;
  RxBool isAbdominalChecked = false.obs;
  RxBool isLegsChecked = false.obs;
  RxBool isArmsChecked = false.obs;
  RxBool isExtraChecked = false.obs;

  void toggleUpperBack() {
    isUpperBackChecked.value = !isUpperBackChecked.value;
    update();
  }

  void toggleMiddleBack() {
    isMiddleBackChecked.value = !isMiddleBackChecked.value;
    update();
  }

  void toggleLowerBack() {
    isLowerBackChecked.value = !isLowerBackChecked.value;
    update();
  }

  void toggleGlutes() {
    isGlutesChecked.value = !isGlutesChecked.value;
    update();
  }

  void toggleHamstrings() {
    isHamstringsChecked.value = !isHamstringsChecked.value;
    update();
  }

  void toggleChest() {
    isChestChecked.value = !isChestChecked.value;
    update();
  }

  void toggleAbdominal() {
    isAbdominalChecked.value = !isAbdominalChecked.value;
    update();
  }

  void toggleLegs() {
    isLegsChecked.value = !isLegsChecked.value;
    update();
  }

  void toggleArms() {
    isArmsChecked.value = !isArmsChecked.value;
    update();
  }

  void toggleExtra() {
    isExtraChecked.value = !isExtraChecked.value;
    update();
  }


}
