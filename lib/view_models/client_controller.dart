import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/client/bioimedancia.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/models/client/client_activity.dart';
import 'package:i_model/models/client/clients.dart';

class ClientController extends GetxController {
  List<String> clientStatusList = [Strings.active, Strings.inactive, Strings.all];
  List<String> genderList = [Strings.man, Strings.women];
  RxString selectedClient = ''.obs;

  /// Client screen values
  final TextEditingController nameController = TextEditingController();
  RxString selectedStatus = Strings.active.obs;
  var isDropdownOpen = false.obs;

  setClientName(){
    clientNameController.text = selectedClient.value.toUpperCase();
    update();
  }

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
    nameController.dispose();
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


  /// Client activity values
  RxList<ClientActivity> clientActivity = [
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
    ClientActivity(hour: '10:00', date: '12/11/2021', ekal: '1230', point: '450', card: '30'),
  ].obs;

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

  /// Bioimpedancia list
  RxBool showLineGraph = false.obs;
  RxBool showSpiderGraph = false.obs;
  RxString selectedDate = ''.obs;
  RxString selectedHour = ''.obs;

  RxList<ClientPoints> bioimpedanciaData = [
    ClientPoints(date: '02/01/2025', hour: '14:15'),
    ClientPoints(date: '03/01/2025', hour: '09:45'),
    ClientPoints(date: '04/01/2025', hour: '11:00'),
    ClientPoints(date: '05/01/2025', hour: '16:20'),
    ClientPoints(date: '06/01/2025', hour: '13:10'),
    ClientPoints(date: '07/01/2025', hour: '17:50'),
    ClientPoints(date: '08/01/2025', hour: '10:00'),
    ClientPoints(date: '09/01/2025', hour: '12:30'),
    ClientPoints(date: '10/01/2025', hour: '15:40'),
  ].obs;

  RxList<Bioimedancia> bioimpedanciaGraphData = [
    Bioimedancia(name: Strings.fatFreeHydration, calculatedValue: '324525', reference: '324525', result: '324525'),
    Bioimedancia(name: Strings.waterBalance, calculatedValue: '324525', reference: '324525', result: '324525'),
    Bioimedancia(name: Strings.imc, calculatedValue: '324525', reference: '324525', result: '324525'),
    Bioimedancia(name: Strings.bodyFat, calculatedValue: '324525', reference: '324525', result: '324525'),
    Bioimedancia(name: Strings.muscle, calculatedValue: '324525', reference: '324525', result: '324525'),
    Bioimedancia(name: Strings.skeleton, calculatedValue: '324525', reference: '324525', result: '324525'),
  ].obs;

  /// Sub tabs
  RxInt selectedSubTabsIndex = 0.obs;

  onSubTabSelected(int index) {
    selectedSubTabsIndex.value = index;
  }

  dismissGraphs(){
    showSpiderGraph.value = false;
    showLineGraph.value = false;
  }

  List<FlSpot> fatFreeHydrationFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];

  List<FlSpot> waterBalanceFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];

  List<FlSpot> imcFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];

  List<FlSpot> bodyFatFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];

  List<FlSpot> muscleFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];

  List<FlSpot> skeletonFlSpotList = const [
    FlSpot(0, 3),
    FlSpot(1, 1),
    FlSpot(2, 5),
    FlSpot(3, 4),
    FlSpot(4, 2),
    FlSpot(5, 3),
    FlSpot(6, 3),
    FlSpot(7, 5),
    FlSpot(8, 3),
    FlSpot(9, 1),
  ];


  RxList<dynamic> clientsListDetail = [
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
