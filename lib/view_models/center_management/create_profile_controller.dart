import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/client/client_points.dart';

class CreateProfileController extends GetxController{
  /// Create profile - Crear nuevo
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController registrationDateController = TextEditingController();

  RxString selectedProfile = ''.obs;
  RxString selectedSessionControl = ''.obs;
  RxString selectedTimeControl = ''.obs;
  RxString selectedGender = ''.obs;
  RxString selectedStatus = Strings.active.obs;
  List<String> sessionControlOptions = [Strings.yes, Strings.no];
  List<String> statusOptions = [Strings.active, Strings.inactive, Strings.all];
  List<String> genderOptions = [Strings.man, Strings.women];
  List<String> profileOptions = [Strings.administrator, Strings.beautician];
  List<String> timeControlOptions = [Strings.yes, Strings.no];


  createProfilePickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      birthDateController.text = birthDate;
    }
    update();
  }

  createProfilePickRegistrationDate(BuildContext context) async {
    String? registrationDate = await HelperMethods.selectDate(context);
    if(registrationDate != null) {
      registrationDateController.text = registrationDate;
    }
    update();
  }

  /// Cards / bonos
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



  /// Available points list
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

  @override
  void onClose() {
    nameController.dispose();
    nickNameController.dispose();
    birthDateController.dispose();
    registrationDateController.dispose();
    super.onClose();
  }
}