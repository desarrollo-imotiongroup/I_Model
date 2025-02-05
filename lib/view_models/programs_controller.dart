import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program.dart';

class ProgramsController extends GetxController{
  final TextEditingController programNameController = TextEditingController();

  /// Configuration
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController rampController = TextEditingController();
  final TextEditingController contractionController = TextEditingController();
  final TextEditingController pauseController = TextEditingController();
  List<String> equipmentOptions = [Strings.bioJacket, Strings.pant];
  RxString selectedEquipment = Strings.nothing.obs;

  List<Program> individualProgramsList = [
    Program(name: Strings.celluliteIndProgram, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.celluliteIcon),
    Program(name: Strings.buttocksIndProgram, frequency: 85, pulse: 350, ramp: 8, contraction: 4, pause: 2, image: Strings.buttocksIndividualIcon),
    Program(name: Strings.contractures, frequency: 85, pulse: 0, ramp: 10, contraction: 6, pause: 4, image: Strings.contracturesIcon),
    Program(name: Strings.drainage, frequency: 85, pulse: 350, ramp: 10, contraction: 4, pause: 2, image: Strings.drainageIcon),
    Program(name: Strings.hypertrophyIndProgram, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.hypertrophyIcon),
    Program(name: Strings.pelvicFloorIndProgram, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.pelvicFloorIcon),
    Program(name: Strings.slimIndProgram, frequency: 43, pulse: 450, ramp: 8, contraction: 6, pause: 3, image: Strings.slimIcon),
    Program(name: Strings.toningIndProgram, frequency: 85, pulse: 350, ramp: 8, contraction: 4, pause: 2, image: Strings.toningIcon),
    Program(name: Strings.massage, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.massageIcon),
    Program(name: Strings.metabolic, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.metabolicIcon),
    Program(name: Strings.calibration, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.calibrationIcon),
    Program(name: Strings.strength, frequency: 80, pulse: 350, ramp: 10, contraction: 4, pause: 1, image: Strings.strengthIcon),
  ];



  List<Program> automaticProgramsList = [
    Program(name: Strings.buttocks, image: Strings.buttocksAutoIcon),
    Program(name: Strings.cellulite, image: Strings.celluliteAutoIcon),
    Program(name: Strings.hypertrophy, image: Strings.hypertrophyAutoIcon),
    Program(name: Strings.pelvicFloor, image: Strings.pelvicFloorAutoIcon),
    Program(name: Strings.slim, image: Strings.slimAutoIcon),
    Program(name: Strings.toning, image: Strings.toningAutoIcon),
  ];

  /// Cronaxia
  final TextEditingController upperBackController = TextEditingController();
  final TextEditingController middleBackController = TextEditingController();
  final TextEditingController lowerBackController = TextEditingController();
  final TextEditingController glutesController = TextEditingController();
  final TextEditingController hamstringsController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController abdomenController = TextEditingController();
  final TextEditingController legsController = TextEditingController();
  final TextEditingController armsController = TextEditingController();
  final TextEditingController extraController = TextEditingController();

  setCronaxiaTextFieldsValues(){
    upperBackController.text = pulseController.text;
    middleBackController.text = pulseController.text;
    lowerBackController.text = pulseController.text;
    glutesController.text = pulseController.text;
    hamstringsController.text = pulseController.text;
    chestController.text = pulseController.text;
    abdomenController.text = pulseController.text;
    legsController.text = pulseController.text;
    armsController.text = pulseController.text;
    extraController.text = pulseController.text;
    update();
  }

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


  @override
  void onClose() {
    programNameController.dispose();
    frequencyController.dispose();
    pulseController.dispose();
    rampController.dispose();
    contractionController.dispose();
    pauseController.dispose();
    upperBackController.dispose();
    middleBackController.dispose();
    lowerBackController.dispose();
    glutesController.dispose();
    hamstringsController.dispose();
    chestController.dispose();
    abdomenController.dispose();
    legsController.dispose();
    armsController.dispose();
    extraController.dispose();
    super.onClose();
  }

}