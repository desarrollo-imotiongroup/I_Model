import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/client/clients.dart';
import 'package:i_model/models/program.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  /// Programs value percentages
  RxInt chestPercentage = 0.obs;
  RxInt armsPercentage = 0.obs;
  RxInt abdomenPercentage = 0.obs;
  RxInt legsPercentage = 0.obs;
  RxInt upperBackPercentage = 0.obs;
  RxInt middleBackPercentage = 0.obs;
  RxInt lumbarPercentage = 0.obs;
  RxInt buttocksPercentage = 0.obs;
  RxInt hamStringsPercentage = 0.obs;
  RxInt calvesPercentage = 0.obs;
  RxString selectedProgramType = Strings.individual.obs;
  RxString selectedProgramName = Strings.cellulite.obs;
  RxString selectedProgramImage = Strings.celluliteIcon.obs;

  RxBool isPantSelected = false.obs;
  RxBool isActive = false.obs;

  /// Handling program active, inactive and block states
  RxList<Program> programsStatus = <Program>[
    Program(name: Strings.chest, status: ProgramStatus.active.obs,),
    Program(name: Strings.arms, status: ProgramStatus.active.obs,),
    Program(name: Strings.abdomen, status: ProgramStatus.active.obs,),
    Program(name: Strings.legs, status: ProgramStatus.active.obs,),
    Program(name: Strings.upperBack, status: ProgramStatus.active.obs,),
    Program(name: Strings.middleBack, status: ProgramStatus.active.obs,),
    Program(name: Strings.lowerBack, status: ProgramStatus.active.obs,),
    Program(name: Strings.glutes, status: ProgramStatus.active.obs,),
    Program(name: Strings.hamstrings, status: ProgramStatus.active.obs,),
    Program(name: Strings.calves, status: ProgramStatus.active.obs,),
  ].obs;

  /// Individual program list
  List<Program> individualProgramsList(BuildContext context){
    return [
      Program(name: translation(context).cellulite, image: Strings.celluliteIcon),
      Program(name: translation(context).buttocks, image: Strings.buttocksIndividualIcon),
      Program(name: translation(context).contractures, image: Strings.contracturesIcon),
      Program(name: translation(context).drainage, image: Strings.drainageIcon),
      Program(name: translation(context).hypertrophy, image: Strings.hypertrophyIcon),
      Program(name: translation(context).pelvicFloor, image: Strings.pelvicFloorIcon),
      Program(name: translation(context).slim, image: Strings.slimIcon),
      Program(name: translation(context).toning, image: Strings.toningIcon),
      Program(name: translation(context).massage, image: Strings.massageIcon),
      Program(name: translation(context).metabolic, image: Strings.metabolicIcon),
      Program(name: translation(context).calibration, image: Strings.calibrationIcon),
      Program(name: translation(context).strength, image: Strings.strengthIcon),
    ];
  }

  List<Program> automaticProgramsList(BuildContext context){
    return [
      Program(name: translation(context).buttocks, image: Strings.buttocksAutoIcon),
      Program(name: translation(context).cellulite, image: Strings.celluliteAutoIcon,),
      Program(name: translation(context).hypertrophy, image: Strings.hypertrophyAutoIcon),
      Program(name: translation(context).pelvicFloor, image: Strings.pelvicFloorAutoIcon),
      Program(name: translation(context).slim, image: Strings.slimAutoIcon),
      Program(name: translation(context).toning, image: Strings.toningAutoIcon),
    ];
  }

  /// Update the status of a program
  void updateProgramStatus(String programName, ProgramStatus newStatus) {
    var program = programsStatus.firstWhereOrNull((p) => p.name == programName);
    if (program != null) {
      program.status!.value = newStatus;

    }
    update();

  }

  /// Intensity colors
  Color chestIntensityColor = AppColors.lowIntensityColor;
  Color armsIntensityColor = AppColors.lowIntensityColor;
  Color abdomenIntensityColor = AppColors.lowIntensityColor;
  Color legsIntensityColor = AppColors.lowIntensityColor;
  Color upperBackIntensityColor = AppColors.lowIntensityColor;
  Color middleBackIntensityColor = AppColors.lowIntensityColor;
  Color lumbarsIntensityColor = AppColors.lowIntensityColor;
  Color buttocksIntensityColor = AppColors.lowIntensityColor;
  Color hamstringsIntensityColor = AppColors.lowIntensityColor;
  Color calvesIntensityColor = AppColors.lowIntensityColor;

  /// Timer values
  RxInt remainingSeconds = 0.obs;
  RxInt minutes = 0.obs;
  RxBool isTimerPaused = true.obs;
  Timer? _timer;

  /// Timer Image
  RxString timerImage = Strings.min_25_icon.obs;

  int maxPercentage = 100;
  int minPercentage = 0;
  int maxMinutes = 30;
  double progressContractionValue = 1.0;
  double progressPauseValue = 1.0;
  RxBool isEKalWidgetVisible = true.obs;

  @override
  Future<void> onInit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int initialMinutes = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    remainingSeconds.value = initialMinutes * 60;
    super.onInit();
  }



  String formatTime(int totalSeconds) {
    minutes.value = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    timerImage.value = 'assets/counter/$minutes-MIN.png';
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void startTimer() {
    isTimerPaused.value = false;
    update();

    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerPaused.value) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value = remainingSeconds.value - 1;
        }
      } else {
        timer.cancel();
        print("Timer finished!");
      }
      update();
    });
  }

  pauseTimer() {
    isTimerPaused.value = true;
    update();
  }

  void increaseMinute() {
    if (minutes.value < maxMinutes) {
      remainingSeconds.value += 60;
    }
    update();
  }

  void decreaseMinute() {
    if (minutes.value > 0) {
      remainingSeconds.value -= 60;
    }
    update();
  }

  changeEKalMenuVisibility() {
    isEKalWidgetVisible.value = !isEKalWidgetVisible.value;
    update();
  }

  changeSuitSelection() {
    isPantSelected.value = !isPantSelected.value;
    update();
  }

  changeActiveState() {
    isActive.value = !isActive.value;
    update();
  }

  changeProgramType({bool isIndividual = true}){
    if(isIndividual){
      selectedProgramType.value = Strings.automatics;
    }
    else{
      selectedProgramType.value = Strings.individual;
    }
    update();
  }

  setProgramDetails({required String name, required String image}){
    selectedProgramName.value = name;
    selectedProgramImage.value = image;
    update();
  }

  calculateIntensityColor(int intensity,
      {bool isChest = false,
      isArms = false,
      isAbdomen = false,
      isLegs = false,
      isUpperBack = false,
      isMiddleBack = false,
      isLumbars = false,
      isButtocks = false,
      isHamstrings = false,
      isCalves = false
      }) {

    /// Chest intensity color
    if (isChest) {
      if (intensity > 0 && intensity < 10) {
        chestIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        chestIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        chestIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        chestIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Arms intensity color
    if (isArms) {
      if (intensity > 0 && intensity < 10) {
        armsIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        armsIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        armsIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        armsIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Upper back intensity colors
    if (isUpperBack) {
      if (intensity > 0 && intensity < 10) {
        upperBackIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        upperBackIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        upperBackIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        upperBackIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Middle back intensity colors
    if (isMiddleBack) {
      if (intensity > 0 && intensity < 10) {
        middleBackIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        middleBackIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        middleBackIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        middleBackIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Abdomen intensity colors
    if (isAbdomen) {
      if (intensity > 0 && intensity < 25) {
        abdomenIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 25 && intensity < 45) {
        abdomenIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 45 && intensity < 70) {
        abdomenIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 70) {
        abdomenIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Legs intensity color
    if (isLegs) {
      if (intensity > 0 && intensity < 20) {
        legsIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 20 && intensity < 40) {
        legsIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 40 && intensity < 60) {
        legsIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 60) {
        legsIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Lumbar intensity color
    if (isLumbars) {
      if (intensity > 0 && intensity < 15) {
        lumbarsIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        lumbarsIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        lumbarsIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        lumbarsIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Buttocks intensity color
    if (isButtocks) {
      if (intensity > 0 && intensity < 25) {
        buttocksIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 25 && intensity < 45) {
        buttocksIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 45 && intensity < 70) {
        buttocksIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 70) {
        buttocksIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Hamstrings intensity color
    if (isHamstrings) {
      if (intensity > 0 && intensity < 15) {
        hamstringsIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        hamstringsIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        hamstringsIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        hamstringsIntensityColor = AppColors.highIntensityColor;
      }
    }

    /// Calves intensity color
    if (isCalves) {
      if (intensity > 0 && intensity < 15) {
        calvesIntensityColor = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        calvesIntensityColor = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        calvesIntensityColor = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        calvesIntensityColor = AppColors.highIntensityColor;
      }
    }
    update();
  }

  int clampValue(int value, int min, int max) {
    return value.clamp(min, max);
  }

  /// Change individual program percentages
  void changeChestPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[0].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        chestPercentage.value = clampValue(chestPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        chestPercentage.value = clampValue(chestPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(chestPercentage.value, isChest: true);
      update();
    }
  }

  void changeArmsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[1].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        armsPercentage.value = clampValue(armsPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        armsPercentage.value = clampValue(armsPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(armsPercentage.value, isArms: true);
      update();
    }
  }

  void changeAbdomenPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[2].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        abdomenPercentage.value = clampValue(abdomenPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        abdomenPercentage.value = clampValue(abdomenPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(abdomenPercentage.value, isAbdomen: true);
      update();
    }
  }

  void changeLegsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[3].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        legsPercentage.value = clampValue(legsPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        legsPercentage.value = clampValue(legsPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(legsPercentage.value, isLegs: true);
      update();
    }
  }

  void changeUpperBackPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[4].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        upperBackPercentage.value = clampValue(upperBackPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        upperBackPercentage.value = clampValue(upperBackPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(upperBackPercentage.value, isUpperBack: true);
      update();
    }
  }

  void changeMiddleBackPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[5].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        middleBackPercentage.value = clampValue(middleBackPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        middleBackPercentage.value = clampValue(middleBackPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(middleBackPercentage.value, isMiddleBack: true);
      update();
    }
  }

  void changeLumbarPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[6].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        lumbarPercentage.value = clampValue(lumbarPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        lumbarPercentage.value = clampValue(lumbarPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(lumbarPercentage.value, isLumbars: true);
      update();
    }
  }

  void changeButtocksPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[7].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        buttocksPercentage.value = clampValue(buttocksPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        buttocksPercentage.value = clampValue(buttocksPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(buttocksPercentage.value, isButtocks: true);
      update();
    }
  }

  void changeHamStringsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[8].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        hamStringsPercentage.value = clampValue(hamStringsPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        hamStringsPercentage.value = clampValue(hamStringsPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(hamStringsPercentage.value, isHamstrings: true);
      update();
    }
  }

  void changeCalvesPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[9].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        calvesPercentage.value = clampValue(calvesPercentage.value + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        calvesPercentage.value = clampValue(calvesPercentage.value - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(calvesPercentage.value, isCalves: true);
      update();
    }
  }

  /// Change percentages of all programs
  void changeAllProgramsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (isIncrease || isDecrease) {
      int delta = isIncrease ? 1 : -1;

      for (var program in programsStatus) {
        if (program.status!.value == ProgramStatus.active) {
          switch (program.name) {
            case Strings.chest:
              chestPercentage.value = clampValue(chestPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.arms:
              armsPercentage.value = clampValue(armsPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.abdomen:
              abdomenPercentage.value = clampValue(abdomenPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.legs:
              legsPercentage.value = clampValue(legsPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.upperBack:
              upperBackPercentage.value = clampValue(upperBackPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.middleBack:
              middleBackPercentage.value = clampValue(middleBackPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.lowerBack:
              lumbarPercentage.value = clampValue(lumbarPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.glutes:
              buttocksPercentage.value = clampValue(buttocksPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.hamstrings:
              hamStringsPercentage.value = clampValue(hamStringsPercentage.value + delta, minPercentage, maxPercentage);
              break;
            case Strings.calves:
              calvesPercentage.value = clampValue(calvesPercentage.value + delta, minPercentage, maxPercentage);
              break;
          }
        }
      }
    }

    /// Update intensity colors based on the changed percentages
    for (var program in programsStatus) {
      if (program.status!.value == ProgramStatus.active) {
        switch (program.name) {
          case Strings.chest:
            calculateIntensityColor(chestPercentage.value, isChest: true);
            break;
          case Strings.arms:
            calculateIntensityColor(armsPercentage.value, isArms: true);
            break;
          case Strings.abdomen:
            calculateIntensityColor(abdomenPercentage.value, isAbdomen: true);
            break;
          case Strings.legs:
            calculateIntensityColor(legsPercentage.value, isLegs: true);
            break;
          case Strings.upperBack:
            calculateIntensityColor(upperBackPercentage.value, isUpperBack: true);
            break;
          case Strings.middleBack:
            calculateIntensityColor(middleBackPercentage.value, isMiddleBack: true);
            break;
          case Strings.lowerBack:
            calculateIntensityColor(lumbarPercentage.value, isLumbars: true);
            break;
          case Strings.glutes:
            calculateIntensityColor(buttocksPercentage.value, isButtocks: true);
            break;
          case Strings.hamstrings:
            calculateIntensityColor(hamStringsPercentage.value, isHamstrings: true);
            break;
          case Strings.calves:
            calculateIntensityColor(calvesPercentage.value, isCalves: true);
            break;
        }
      }
    }

    update();
  }

  // changeAllProgramsPercentage({bool isDecrease = false, bool isIncrease = false}) {
  //   if (isIncrease) {
  //     if(isPantSelected.value){
  //       armsPercentage.value = clampValue(armsPercentage.value + 1, minPercentage, maxPercentage);
  //       abdomenPercentage.value = clampValue(abdomenPercentage.value + 1, minPercentage, maxPercentage);
  //       legsPercentage.value = clampValue(legsPercentage.value + 1, minPercentage, maxPercentage);
  //       buttocksPercentage.value = clampValue(buttocksPercentage.value + 1, minPercentage, maxPercentage);
  //       hamStringsPercentage.value = clampValue(hamStringsPercentage.value + 1, minPercentage, maxPercentage);
  //       calvesPercentage.value = clampValue(calvesPercentage.value + 1, minPercentage, maxPercentage);
  //     }
  //     else {
  //       if(programsStatus[0].status!.value == ProgramStatus.active){
  //         chestPercentage.value = clampValue(chestPercentage.value + 1, minPercentage, maxPercentage);
  //       }
  //       armsPercentage.value = clampValue(armsPercentage.value + 1, minPercentage, maxPercentage);
  //       abdomenPercentage.value = clampValue(abdomenPercentage.value + 1, minPercentage, maxPercentage);
  //       legsPercentage.value = clampValue(legsPercentage.value + 1, minPercentage, maxPercentage);
  //       upperBackPercentage.value = clampValue(upperBackPercentage.value + 1, minPercentage, maxPercentage);
  //       middleBackPercentage.value = clampValue(middleBackPercentage.value + 1, minPercentage, maxPercentage);
  //       lumbarPercentage.value = clampValue(lumbarPercentage.value + 1, minPercentage, maxPercentage);
  //       buttocksPercentage.value = clampValue(buttocksPercentage.value + 1, minPercentage, maxPercentage);
  //       hamStringsPercentage.value = clampValue(hamStringsPercentage.value + 1, minPercentage, maxPercentage);
  //     }
  //   }
  //   if (isDecrease) {
  //     if(isPantSelected.value){
  //       armsPercentage.value = clampValue(armsPercentage.value - 1, minPercentage, maxPercentage);
  //       abdomenPercentage.value = clampValue(abdomenPercentage.value - 1, minPercentage, maxPercentage);
  //       legsPercentage.value = clampValue(legsPercentage.value - 1, minPercentage, maxPercentage);
  //       buttocksPercentage.value = clampValue(buttocksPercentage.value - 1, minPercentage, maxPercentage);
  //       hamStringsPercentage.value = clampValue(hamStringsPercentage.value - 1, minPercentage, maxPercentage);
  //       calvesPercentage.value = clampValue(calvesPercentage.value - 1, minPercentage, maxPercentage);
  //     }
  //     else {
  //       if(programsStatus[0].status!.value == ProgramStatus.active){
  //         chestPercentage.value = clampValue(chestPercentage.value - 1, minPercentage, maxPercentage);
  //       }
  //       armsPercentage.value = clampValue(armsPercentage.value - 1, minPercentage, maxPercentage);
  //       abdomenPercentage.value = clampValue(abdomenPercentage.value - 1, minPercentage, maxPercentage);
  //       legsPercentage.value = clampValue(legsPercentage.value - 1, minPercentage, maxPercentage);
  //       upperBackPercentage.value = clampValue(upperBackPercentage.value - 1, minPercentage, maxPercentage);
  //       middleBackPercentage.value = clampValue(middleBackPercentage.value - 1, minPercentage, maxPercentage);
  //       lumbarPercentage.value = clampValue(lumbarPercentage.value - 1, minPercentage, maxPercentage);
  //       buttocksPercentage.value = clampValue(buttocksPercentage.value - 1, minPercentage, maxPercentage);
  //       hamStringsPercentage.value = clampValue(hamStringsPercentage.value - 1, minPercentage, maxPercentage);
  //     }
  //   }
  //
  //   if(isPantSelected.value){
  //     calculateIntensityColor(armsPercentage.value, isArms: true);
  //     calculateIntensityColor(abdomenPercentage.value, isAbdomen: true);
  //     calculateIntensityColor(legsPercentage.value, isLegs: true);
  //     calculateIntensityColor(buttocksPercentage.value, isButtocks: true);
  //     calculateIntensityColor(hamStringsPercentage.value, isHamstrings: true);
  //     calculateIntensityColor(calvesPercentage.value, isCalves: true);
  //   }
  //   else{
  //     calculateIntensityColor(chestPercentage.value, isChest: true);
  //     calculateIntensityColor(armsPercentage.value, isArms: true);
  //     calculateIntensityColor(abdomenPercentage.value, isAbdomen: true);
  //     calculateIntensityColor(legsPercentage.value, isLegs: true);
  //     calculateIntensityColor(upperBackPercentage.value, isUpperBack: true);
  //     calculateIntensityColor(middleBackPercentage.value, isMiddleBack: true);
  //     calculateIntensityColor(lumbarPercentage.value, isLumbars: true);
  //     calculateIntensityColor(buttocksPercentage.value, isButtocks: true);
  //     calculateIntensityColor(hamStringsPercentage.value, isHamstrings: true);
  //   }
  //
  //   update();
  // }

  /// Select client
  var isDropdownOpen = false.obs;
  final TextEditingController nameController = TextEditingController();
  RxString selectedClient = ''.obs;
  RxString selectedStatus = Strings.active.obs;
  List<String> clientStatusList = [Strings.active, Strings.inactive, Strings.all];

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


  @override
  void onClose() {
    _timer?.cancel();
    nameController.dispose();
    super.onClose();
  }

}
