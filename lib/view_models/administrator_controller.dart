import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/administrator_activity.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/models/client/clients.dart';

class AdministratorController extends GetxController{
  /// Administrator list values
  final TextEditingController administratorNameController = TextEditingController();
  List<String> administratorStatusList = [Strings.active, Strings.inactive, Strings.all];
  RxString selectedStatus = Strings.active.obs;
  var isDropdownOpen = false.obs;
  RxString selectedAdministrator = ''.obs;

  /// Personal data
  final TextEditingController perDataNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController registrationDateController = TextEditingController();
  List<String> profileOptions = [Strings.administrator, Strings.beautician];
  List<String> genderOptions = [Strings.man, Strings.women];
  List<String> sessionControlOptions = [Strings.yes, Strings.no];
  List<String> timeControlOptions = [Strings.yes, Strings.no];
  RxString selectedProfile = ''.obs;
  RxString selectedSessionControl = ''.obs;
  RxString selectedTimeControl = ''.obs;
  RxString selectedGender = ''.obs;


  setInitialNickName(){
    nickNameController.text = selectedAdministrator.value.toUpperCase();
    update();
  }

  pickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      birthDateController.text = birthDate;
    }
    update();
  }

  pickRegistrationDate(BuildContext context) async {
    String? registrationDate = await HelperMethods.selectDate(context);
    if(registrationDate != null) {
      registrationDateController.text = registrationDate;
    }
    update();
  }

  /// Administrators list
  RxList<dynamic> administratorsDetail = [
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Monica', phone: '666 666 666', status: Strings.inactive),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Monica', phone: '666 666 666', status: Strings.inactive),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
    Client(id: '1', name: 'Laura', phone: '666 666 666', status: Strings.active),
  ].obs;

  /// Cards / bonos
  /// Available points list
  RxList<ClientPoints> availablePoints = [
    ClientPoints(date: '01/01/2025', quantity: 50),
    ClientPoints(date: '02/01/2025', quantity: 40),
    ClientPoints(date: '03/01/2025', quantity: 30),
    ClientPoints(date: '04/01/2025', quantity: 60),
    ClientPoints(date: '05/01/2025', quantity: 20),
    ClientPoints(date: '06/01/2025', quantity: 80),
    ClientPoints(date: '07/01/2025', quantity: 35),
    ClientPoints(date: '08/01/2025', quantity: 55),
    ClientPoints(date: '09/01/2025', quantity: 45),
    ClientPoints(date: '10/01/2025', quantity: 25),
  ].obs;


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

  /// Administrator activities
  RxList<AdministratorActivity> administratorActivity = [
    AdministratorActivity(date: '2025-02-01', start: '10:00', end: '12:00', bonuses: '200', client: 'Client 1'),
    AdministratorActivity(date: '2025-02-02', start: '11:15', end: '13:30', bonuses: '350', client: 'Client 2'),
    AdministratorActivity(date: '2025-02-03', start: '09:30', end: '11:45', bonuses: '150', client: 'Client 3'),
    AdministratorActivity(date: '2025-02-04', start: '14:00', end: '16:00', bonuses: '250', client: 'Client 4'),
    AdministratorActivity(date: '2025-02-05', start: '08:45', end: '10:15', bonuses: '100', client: 'Client 5'),
    AdministratorActivity(date: '2025-02-06', start: '16:30', end: '18:00', bonuses: '400', client: 'Client 6'),
    AdministratorActivity(date: '2025-02-07', start: '12:00', end: '14:00', bonuses: '300', client: 'Client 7'),
    AdministratorActivity(date: '2025-02-08', start: '10:30', end: '12:30', bonuses: '500', client: 'Client 8'),
    AdministratorActivity(date: '2025-02-09', start: '15:00', end: '17:00', bonuses: '450', client: 'Client 9'),
    AdministratorActivity(date: '2025-02-10', start: '13:15', end: '15:00', bonuses: '200', client: 'Client 10'),
  ].obs;

  /// Create profile - Crear nuevo
  final TextEditingController createProfileNameController = TextEditingController();
  final TextEditingController createProfileNickNameController = TextEditingController();
  final TextEditingController createProfileBirthDateController = TextEditingController();
  final TextEditingController createProfileRegistrationDateController = TextEditingController();
  List<String> createProfileOptions = [Strings.administrator, Strings.beautician];
  List<String> createProfileGenderOptions = [Strings.man, Strings.women];
  List<String> createProfileSessionControlOptions = [Strings.yes, Strings.no];
  List<String> createProfileTimeControlOptions = [Strings.yes, Strings.no];
  RxString createProfileSelectedProfile = ''.obs;
  RxString createProfileSelectedSessionControl = ''.obs;
  RxString createProfileSelectedTimeControl = ''.obs;
  RxString createProfileSelectedGender = ''.obs;
  RxString createProfileSelectedStatus = Strings.active.obs;

  createProfilePickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      createProfileBirthDateController.text = birthDate;
    }
    update();
  }

  createProfilePickRegistrationDate(BuildContext context) async {
    String? registrationDate = await HelperMethods.selectDate(context);
    if(registrationDate != null) {
      createProfileRegistrationDateController.text = registrationDate;
    }
    update();
  }

  @override
  void onClose() {
    administratorNameController.dispose();
    perDataNameController.dispose();
    nickNameController.dispose();
    birthDateController.dispose();
    registrationDateController.dispose();
    createProfileNameController.dispose();
    createProfileNickNameController.dispose();
    createProfileBirthDateController.dispose();
    createProfileRegistrationDateController.dispose();
    super.onClose();
  }

}