import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program.dart';
import 'package:i_model/models/program_details.dart';

class ProgramsController extends GetxController{
  final TextEditingController individualProgramNameController = TextEditingController();
  final TextEditingController automaticProgramNameController = TextEditingController();

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
    Program(name: Strings.cellulite, image: Strings.celluliteAutoIcon,),
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

  /// Automatic program tab
  RxList<dynamic> individualProgramSequenceList = [].obs;

  removeProgram(int index){
    individualProgramSequenceList.removeAt(index);
    update();
  }

  /// Create sequence
  final TextEditingController orderController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController adjustmentController = TextEditingController();
  RxString selectedProgram = Strings.nothing.obs;

  List<String> individualProgramOptionList = [
    Strings.celluliteIndProgram,
    Strings.buttocksIndProgram,
    Strings.contractures,
    Strings.drainage,
    Strings.hypertrophyIndProgram,
    Strings.pelvicFloorIndProgram,
    Strings.slimIndProgram,
    Strings.toningIndProgram,
    Strings.massage,
    Strings.metabolic,
    Strings.calibration,
    Strings.strength,
  ];

  createSequence(BuildContext context) {
    if (orderController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        adjustmentController.text.isNotEmpty &&
        selectedProgram.value != Strings.nothing) {

      individualProgramSequenceList.add(
        ProgramDetails(
          name: selectedProgram.value,
          order: int.parse(orderController.text),
          duration: int.parse(durationController.text),
          adjustment: int.parse(adjustmentController.text),
        ),
      );
      clearSequenceFields();
      Navigator.pop(context);
    }
  }

  /// Automatic program from program screen
  RxString selectedProgramName = Strings.nothing.obs;
  RxString selectedProgramImage = Strings.nothing.obs;

  setProgramDetails({required String name, required String image}){
    selectedProgramName.value = name;
    selectedProgramImage.value = image;
    update();
  }
  
  /// Selected Program 
  RxList<ProgramDetails> selectedProgramDetails = [
    ProgramDetails(order: 1, name: 'CALIBRACIÓN', duration: 1, adjustment: 0),
    ProgramDetails(order: 2, name: 'METABOLIC', duration: 1, adjustment: 7),
    ProgramDetails(order: 3, name: 'CELLULITE', duration: 1, adjustment: -5),
    ProgramDetails(order: 4, name: 'CARDIO', duration: 1, adjustment: 2),
    ProgramDetails(order: 5, name: 'STRENGTH', duration: 1, adjustment: 3),
    ProgramDetails(order: 6, name: 'RELAXATION', duration: 1, adjustment: -2),
    ProgramDetails(order: 7, name: 'PILATES', duration: 1, adjustment: 4),
    ProgramDetails(order: 8, name: 'YOGA', duration: 1, adjustment: 0),
    ProgramDetails(order: 9, name: 'MASSAGE', duration: 1, adjustment: 1),
    ProgramDetails(order: 10, name: 'DETOX', duration: 1, adjustment: -3),
  ].obs;



  void clearAllFields() {
    individualProgramNameController.clear();
    frequencyController.clear();
    pulseController.clear();
    rampController.clear();
    contractionController.clear();
    pauseController.clear();
    upperBackController.clear();
    middleBackController.clear();
    lowerBackController.clear();
    glutesController.clear();
    hamstringsController.clear();
    chestController.clear();
    abdomenController.clear();
    legsController.clear();
    armsController.clear();
    extraController.clear();
    orderController.clear();
    durationController.clear();
    adjustmentController.clear();
  }

  clearSequenceFields(){
    orderController.clear();
    durationController.clear();
    adjustmentController.clear();
    selectedProgram.value = Strings.nothing;
  }

  @override
  void onClose() {
    individualProgramNameController.dispose();
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
    orderController.dispose();
    durationController.dispose();
    adjustmentController.dispose();
    super.onClose();
  }

}