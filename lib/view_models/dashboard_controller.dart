import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/bluetooth/ble_command_service.dart';
import 'package:i_model/bluetooth/bluetooth_service.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/app_state.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/client/clients.dart';
import 'package:i_model/models/program.dart';
import 'package:shared_preferences/shared_preferences.dart';
enum CyclePhase { contraction, pause }

class DashboardController extends GetxController {
  /// Programs value percentages
  RxList<int> chestPercentage = <int>[].obs;
  // RxInt chestPercentage = 0.obs;
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
  RxInt frequency = 0.obs;
  RxInt pulse = 0.obs;
  RxString selectedProgramName = Strings.nothing.obs;
  RxString selectedMainProgramName = Strings.nothing.obs;
  RxString selectedProgramImage = Strings.celluliteIcon.obs;
  List<Map<String, dynamic>> automaticProgramList = [];
  List<Map<String, dynamic>> individualProgramList = [];
  RxMap<String, dynamic> selectedProgramDetails = <String, dynamic>{}.obs;
  RxBool isElectroOn = false.obs;
  RxInt currentIndex = 0.obs;
  RxBool isBluetoothConnected = false.obs;
  RxBool isDashboardLoading = false.obs;

  RxBool isPantSelected = false.obs;
  RxBool isActive = false.obs;
  RxBool isProgramSelected = false.obs;
  RxBool isDeviceConnected = false.obs;
  RxInt selectedDeviceIndex = (-1).obs;
  RxString selectedMacAddress = Strings.nothing.obs;
  // RxString errorMessage = Strings.nothing.obs;
  RxBool isUpdate = false.obs;

  /// Testing multiple mci
  // RxList<int> testingPercentage = <int>[].obs;
  // RxList<int> testingPercentage = List.generate(2, (index) => 0).obs;
  //
  // incrementTestingPercentage(){
  //   testingPercentage[selectedDeviceIndex.value] = testingPercentage[selectedDeviceIndex.value] + 1;
  //   update();
  // }

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
  RxBool isEKalWidgetVisible = true.obs;

  @override
  Future<void> onInit() async {
    isDashboardLoading.value = true;
    initializeBluetoothConnection();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int initialMinutes = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    remainingSeconds.value = initialMinutes * 60;
    automaticProgramList = await fetchAutoPrograms();
    individualProgramList = await fetchIndividualPrograms();
    initProgramsAndTimers();
    super.onInit();
  }

  initProgramsAndTimers(){
    int totalMCIs = 0;
    totalMCIs = AppState.instance.mcis.length;

    chestPercentage.value = List.generate(totalMCIs, (index) => 0);

    Future.delayed(Duration(milliseconds: 300), () {
      isDashboardLoading.value = false;
    });

  }

  /// Fetching individual programs from SQL
  Future<List<Map<String, dynamic>>> fetchIndividualPrograms() async {
    List<Map<String, dynamic>> individualPrograms = [];
    final db = await DatabaseHelper().database;
    try {
      individualPrograms = await DatabaseHelper().obtenerProgramasPredeterminadosPorTipoIndividual(db);

    } catch (e) {
      print('❌ Error fetching programs: $e');
      return [];
    }
    return individualPrograms;
  }

  resetProgramTimerValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int initialMinutes = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    remainingSeconds.value = initialMinutes * 60;

    contractionCycleTimer?.cancel();
    pauseCycleTimer?.cancel();
    isContractionPauseCycleActive.value = false;
    contractionProgress.value = 0;
    pauseProgress.value = 0;
    remainingContractionSeconds.value = 0;
    remainingPauseSeconds.value = 0;

  }

  /// Fetching automatic programs from SQL
  Future<List<Map<String, dynamic>>> fetchAutoPrograms() async {
    // List<Map<String, dynamic>> allAutomaticPrograms = [];
    List<Map<String, dynamic>> autoProgramData = [];
    var db = await DatabaseHelper().database; // Obtener la instancia de la base de datos
    try {
      // Llamamos a la función que obtiene los programas automáticos y sus subprogramas
      autoProgramData = await DatabaseHelper().obtenerProgramasAutomaticosConSubprogramas(db);
      // autoProgramData = groupedPrograms; // Asigna los programas obtenidos a la lista
      //
      // List<Map<String, dynamic>> groupedPrograms =
      // _groupProgramsWithSubprograms(autoProgramData);
      //
      //
      //
      // List<Map<String, dynamic>> allAutomaticPrograms = groupedPrograms;
      // print('allAutomaticPrograms: $allAutomaticPrograms');
      // onAutoProgramSelected(allAutomaticPrograms[1]);


      // print('✅ Programas automáticos obtenidos:');
      // for (var program in autoProgramData) {
      //   print('📌 Programa: ${program['nombre']} (ID: ${program['id_programa_automatico']})');
      //   print('   📷 Imagen: ${program['imagen']}');
      //   print('   📝 Descripción: ${program['descripcion']}');
      //   print('   ⏳ Duración: ${program['duracionTotal']}');
      //   print('   🔧 Tipo de equipamiento: ${program['tipo_equipamiento']}');
      //
      //
      //
      //   List<Map<String, dynamic>> subprogramas = program['subprogramas'] ?? [];
      //   if (subprogramas.isNotEmpty) {
      //     print('   🔽 Subprogramas:');
      //     for (var subprogram in subprogramas) {
      //       print('      - ${subprogram['nombre']} (ID: ${subprogram['id_programa_relacionado']})');
      //     }
      //   } else {
      //     // print('   ❌ No hay subprogramas.');
      //   }
      // }

      // Agrupamos los subprogramas por programa automático
      // List<Map<String, dynamic>> groupedPrograms = _groupProgramsWithSubprograms(autoProgramData);
      // allAutomaticPrograms = groupedPrograms;

    } catch (e) {
      print('❌ Error fetching programs: $e');
    }
    return autoProgramData;
  }

   List<Map<String, dynamic>> autoProgramCronaxias = [];
   List<Map<String, dynamic>> autoProgramGrupos = [];
   List<Map<String, dynamic>> subprogramasNotifier = [];

  void onAutoProgramSelected(Map<String, dynamic>? programA) async {
    if (programA == null) return;

    // Debug: Check the programA structure
    print('programA: $programA');

    var db = await DatabaseHelper().database;
    try {
      List<Map<String, dynamic>> subprogramas =
          (programA['subprogramas'] as List<dynamic>?)
              ?.map((sp) => Map<String, dynamic>.from(sp))
              .toList() ??
              [];

      // Debug: Log subprogramas to see the contents
      print('subprogramas: $subprogramas');

      for (var i = 0; i < subprogramas.length; i++) {
        var subprograma = Map<String, dynamic>.from(subprogramas[i]);

        var idPrograma = subprograma['id_programa_relacionado'];

        // Debug: Check each subprograma
        print('Processing subprograma $i: $subprograma');

        if (idPrograma == null) {
          print("Warning: id_programa_relacionado is null for subprograma: $subprograma");
          continue; // Skip this subprogram if no valid id_programa_relacionado
        }

        List<Map<String, dynamic>> cronaxias = (await DatabaseHelper().obtenerCronaxiasPorPrograma(db, idPrograma))
            .map((c) => {
          'id': c['id'],  // 'id' will no longer be null
          'nombre': c['nombre'],
          'valor': c['valor']
        })
            .toList();

        List<Map<String, dynamic>> grupos = (await DatabaseHelper()
            .obtenerGruposPorPrograma(db, idPrograma))
            .map((g) => {
          'id': g['id'],
          'nombre': g['nombre'] ?? 'Desconocido'
        })
            .toList();


        subprogramas[i] = {
          ...subprograma,
          'cronaxias': cronaxias,
          'grupos': grupos
        };
      }

      autoProgramCronaxias = subprogramas.isNotEmpty
          ? subprogramas.first['cronaxias'] ?? []
          : [];
      autoProgramGrupos = subprogramas.isNotEmpty
          ? subprogramas.first['grupos'] ?? []
          : [];
      subprogramasNotifier = subprogramas;

      // Debug: Check the final values
      print('cronaxiasNotifier: $autoProgramCronaxias');
      print('gruposMuscularesNotifier: $autoProgramGrupos');
      print('subprogramasNotifier: $subprogramasNotifier');
    } catch (e) {
      debugPrint("❌ Error en onAutoProgramSelected: $e");
    }
  }


  // void onAutoProgramSelected(Map<String, dynamic>? programA) async {
  //   if (programA == null) return;
  //
  //   // Debug: Check the programA structure
  //   // print('programA: $programA');
  //
  //   final List<Map<String, dynamic>> cronaxiasNotifier;
  //   final List<Map<String, dynamic>> gruposMuscularesNotifier;
  //   final List<Map<String, dynamic>> subprogramasNotifier;
  //
  //   var db = await DatabaseHelper().database;
  //   try {
  //     List<Map<String, dynamic>> subprogramas =
  //         (programA['subprogramas'] as List<dynamic>?)
  //             ?.map((sp) => Map<String, dynamic>.from(sp))
  //             .toList() ??
  //             [];
  //
  //     // Debug: Log subprogramas to see the contents
  //     // print('subprogramas: $subprogramas');
  //
  //     for (var i = 0; i < subprogramas.length; i++) {
  //       var subprograma = Map<String, dynamic>.from(subprogramas[i]);
  //
  //       var idPrograma = subprograma['id_programa_relacionado'];
  //
  //       // Debug: Check each subprograma
  //       // print('subprograma: $subprograma');
  //
  //       if (idPrograma == null) {
  //         print("Warning: id_programa_relacionado is null for subprograma: $subprograma");
  //         continue; // Skip this subprogram if no valid id_programa_relacionado
  //       }
  //
  //       List<Map<String, dynamic>> cronaxias =
  //       (await DatabaseHelper().obtenerCronaxiasPorPrograma(db, idPrograma))
  //           .map((c) => {
  //         'id': c['id'],
  //         'nombre': c['nombre'],
  //         'valor': c['valor']
  //       })
  //           .toList();
  //
  //       List<Map<String, dynamic>> grupos = (await DatabaseHelper()
  //           .obtenerGruposPorPrograma(db, idPrograma))
  //           .map((g) => {
  //         'id': g['id'],
  //         'nombre': g['nombre'] ?? 'Desconocido'
  //       })
  //           .toList();
  //
  //       subprogramas[i] = {
  //         ...subprograma,
  //         'cronaxias': cronaxias,
  //         'grupos': grupos
  //       };
  //     }
  //
  //     cronaxiasNotifier = subprogramas.isNotEmpty
  //         ? subprogramas.first['cronaxias']
  //         : [];
  //     gruposMuscularesNotifier = subprogramas.isNotEmpty
  //         ? subprogramas.first['grupos']
  //         : [];
  //     subprogramasNotifier = subprogramas;
  //
  //     print('cronaxiasNotifier: $cronaxiasNotifier');
  //     print('gruposMuscularesNotifier: $gruposMuscularesNotifier');
  //     print('subprogramasNotifier: $subprogramasNotifier');
  //   } catch (e) {
  //     debugPrint("❌ Error en onAutoProgramSelected: $e");
  //   }
  // }


  List<Map<String, dynamic>> _groupProgramsWithSubprograms(List<Map<String, dynamic>> autoProgramData) {
    List<Map<String, dynamic>> groupedPrograms = [];

    for (var autoProgram in autoProgramData) {
      List<Map<String, dynamic>> subprogramas =
          autoProgram['subprogramas'] ?? [];

      Map<String, dynamic> groupedProgram = {
        'id_programa_automatico': autoProgram['id_programa_automatico'],
        'nombre_programa_automatico': autoProgram['nombre'],
        'imagen': autoProgram['imagen'],
        'descripcion_programa_automatico': autoProgram['descripcion'],
        'duracionTotal': autoProgram['duracionTotal'],
        'tipo_equipamiento': autoProgram['tipo_equipamiento'],
        'subprogramas': subprogramas,
      };

      print('subprogramas: $subprogramas');
      groupedPrograms.add(groupedProgram);
    }

    return groupedPrograms;
  }


  // void handleIndividualSelection(String macAddress) {
  //   print("📱❌ $macAddress no pertenece a ningún grupo");
  //
  //   // Deseleccionamos todos los dispositivos
  //   isSelected.forEach((key, value) {
  //     if (value == true) {
  //       isSelected[key] = false;
  //       print("✖️ El dispositivo $key ha sido deseleccionado.");
  //     }
  //   });
  //
  //   // Seleccionamos el dispositivo individual
  //   isSelected[macAddress] = true;
  //   selectedKey = macAddress;
  //   print("📱 $macAddress ha sido seleccionado.");
  //   print("🔑 Clave asignada (dispositivo individual): $selectedKey");
  //
  //   // Actualizamos la selección del dispositivo individual
  //   updateDeviceSelection(macAddress, ''); // El grupo es vacío para selección individual
  // }
  //
  // void updateDeviceSelection(String mac, String group) {
  //
  //     macAddress = mac; // Actualizamos el macAddress
  //     grupoKey =
  //         group; // Actualizamos la clave del grupo (vacío para selección individual)
  //
  //
  //   if (group.isEmpty) {
  //     print("🔄 Dispositivo individual seleccionado: $mac");
  //   } else {
  //     print("🔄 Dispositivo $mac del grupo $group seleccionado.");
  //   }
  // }


  String formatTime(int totalSeconds) {
    minutes.value = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    timerImage.value = 'assets/counter/$minutes-MIN.png';
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  /// Main Timer
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
        else{
          timer.cancel();
          cancelTimersOnTimeUp();
        }
      } else {
        timer.cancel();

      }
      update();
    });
  }

  /// Contraction and pause line painters
  RxInt pauseSeconds = 0.obs;
  RxInt contractionSeconds = 0.obs;
  RxDouble contractionProgress = 0.0.obs;
  RxDouble pauseProgress = 0.0.obs;
  Timer? contractionCycleTimer;
  Timer? pauseCycleTimer; /// TTT
  ///  Timer? contractionCycleTimer;
  RxBool isContractionPauseCycleActive = false.obs;
  RxDouble remainingContractionSeconds = 0.0.obs;
  RxDouble remainingPauseSeconds = 0.0.obs;
  RxList<Map<String, dynamic>> automaticProgramValues = <Map<String, dynamic>>[].obs;

  /// Contraction time cycle
  Future<void> startContractionTimeCycle() async {
    isContractionPauseCycleActive.value = true;
    contractionProgress.value = 1.0;
    double decrementAmount = 1.0 / (contractionSeconds.value * 10);
    int totalDurationInSeconds = contractionSeconds.value;

    print('In contraction cycle: ${isElectroOn.value}');

    // Start electrostimulation if needed.
    if (!isElectroOn.value) {
      startFullElectrostimulationTrajeProcess(
          selectedMacAddress.value, selectedProgramName.value)
          .then((success) {
        isElectroOn.value = true;
      });
    }

    // Immediately set UI to max value.
    remainingContractionSeconds.value = totalDurationInSeconds.toDouble();

    // Introduce firstTick flag to skip first decrement.
    bool firstTick = true;

    /// Calculate the seconds while decreasing progress value to show on line painters
    contractionCycleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (firstTick) {
        firstTick = false;
        // Ensure the UI remains at the max value for the first tick.
        remainingContractionSeconds.value = totalDurationInSeconds.toDouble();
        return;
      }
      if (contractionProgress.value > 0) {
        // Update UI
        remainingContractionSeconds.value = (totalDurationInSeconds * contractionProgress.value).ceilToDouble();
        contractionProgress.value -= decrementAmount;
      } else {
        contractionProgress.value = 0;
        remainingContractionSeconds.value = 0;
        contractionCycleTimer!.cancel();
        startPauseTimeCycle();
      }
    });
  }

  /// Pause time cycle
  Future<void> startPauseTimeCycle() async {
    pauseProgress.value = 1.0;
    double decrementAmount = 1.0 / (pauseSeconds.value * 10);
    int totalDurationInSeconds = pauseSeconds.value;

    // Immediately set UI to max value.
    remainingPauseSeconds.value = totalDurationInSeconds.toDouble();

    // Introduce firstTick flag to skip first decrement.
    bool firstTick = true;

    // Stop electrostimulation during pause.
    stopElectrostimulationProcess(selectedMacAddress.value);

    pauseCycleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (firstTick) {
        firstTick = false;
        // Ensure the UI remains at the max value for the first tick.
        remainingPauseSeconds.value = totalDurationInSeconds.toDouble();
        return;
      }
      if (pauseProgress.value > 0) {
        remainingPauseSeconds.value = (totalDurationInSeconds * pauseProgress.value).ceilToDouble();
        pauseProgress.value -= decrementAmount;
      } else {
        pauseProgress.value = 0;
        remainingPauseSeconds.value = 0;
        pauseCycleTimer!.cancel();
        startContractionTimeCycle();
      }
    });
  }

  /// Pulse cycle
  Future<void> startPulseCycle(var program) async {
    print("Starting pulse for ${program['subProgramName']} with frequency: ${program['frequency']} Hz and pulse: ${program['pulse']}");
    // Pulse logic here, you can implement your pulse method depending on the requirement
    await Future.delayed(Duration(seconds: 1)); // Simulate pulse cycle delay for now
  }


  int currentProgramIndex = 0;
  int elapsedTime = 0;
  int _remainingContractionTime = 0; // Remaining seconds in current contraction cycle
  int _remainingPauseTime = 0;       // Remaining seconds in current pause cycle
  // bool _isContractionPhase = false;  // true if we’re in a contraction cycle
  // bool _isPausePhase = false;
  CyclePhase? _currentCyclePhase;    // indicates which cycle was active



  /// Auto Programs
  Future<void> startContractionForMultiplePrograms() async {
    if (automaticProgramValues.isEmpty) {
      print("No programs to process.");
      return;
    }
    isContractionPauseCycleActive.value = true;

    // DO NOT reset elapsedTime here if we're resuming mid-program.
    for (; currentProgramIndex < automaticProgramValues.length; currentProgramIndex++) {
      var program = automaticProgramValues[currentProgramIndex];

      // Convert fractional minutes to seconds.
      double durationInMinutes = program['duration'];
      int totalProgramSeconds = (durationInMinutes * 60).toInt();

      print("Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");

      // Set UI values.
      selectedProgramImage.value = program['image'];
      selectedProgramName.value = program['subProgramName'];
      frequency.value = program['frequency'].toInt();
      pulse.value = program['pulse'].toInt();

      // Start the pulse cycle.
      await startPulseCycle(program);

      // Continue until the program's total duration is reached.
      while (elapsedTime < totalProgramSeconds) {
        // If a pause cycle was interrupted, resume it.
        if (_currentCyclePhase == CyclePhase.pause && _remainingPauseTime > 0) {
          print("Resuming pause cycle for $_remainingPauseTime seconds.");
          await startAutoPauseTimeCycle(program, _remainingPauseTime);
          if (isTimerPaused.value) return; // pause again if needed
          elapsedTime += _remainingPauseTime;
          _remainingPauseTime = 0;
          _currentCyclePhase = CyclePhase.contraction;
          continue;
        }
        // If a contraction cycle was interrupted, resume it.
        else if (_currentCyclePhase == CyclePhase.contraction && _remainingContractionTime > 0) {
          print("Resuming contraction cycle for $_remainingContractionTime seconds.");
          await runContractionCycle(program, _remainingContractionTime);
          if (isTimerPaused.value) return;
          elapsedTime += _remainingContractionTime;
          _remainingContractionTime = 0;
          _currentCyclePhase = CyclePhase.pause;
          if (elapsedTime >= totalProgramSeconds) break;
          continue;
        }
        // If no cycle was interrupted, start a new contraction cycle.
        else if (_currentCyclePhase == null || _currentCyclePhase == CyclePhase.contraction) {
          int contractionDuration = program['contraction'].toInt();
          int remainingTime = totalProgramSeconds - elapsedTime;
          int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
          _remainingContractionTime = contractionRunTime;
          _currentCyclePhase = CyclePhase.contraction;
          print("Starting contraction cycle for $contractionRunTime seconds.");
          await runContractionCycle(program, contractionRunTime);
          if (isTimerPaused.value) return;
          elapsedTime += contractionRunTime;
          _remainingContractionTime = 0;
          _currentCyclePhase = CyclePhase.pause;
          if (elapsedTime >= totalProgramSeconds) break;
        }
        // Start a new pause cycle.
        if (_currentCyclePhase == CyclePhase.pause) {
          int pauseDuration = program['pause'].toInt();
          int remainingTime = totalProgramSeconds - elapsedTime;
          int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
          _remainingPauseTime = pauseRunTime;
          print("Starting pause cycle for $pauseRunTime seconds.");
          await startAutoPauseTimeCycle(program, pauseRunTime);
          if (isTimerPaused.value) return;
          elapsedTime += pauseRunTime;
          _remainingPauseTime = 0;
          _currentCyclePhase = CyclePhase.contraction;
        }
      }

      // When a program finishes, reset state for the next program.
      elapsedTime = 0;
      _remainingContractionTime = 0;
      _remainingPauseTime = 0;
      _currentCyclePhase = null;
    }

    update();
    print("All programs completed.");
  }

  /// Modified contraction cycle.
  Future<void> runContractionCycle(var program, int runTimeSeconds) async {
    contractionSeconds.value = runTimeSeconds;
    contractionProgress.value = 1.0;
    int totalDurationInSeconds = runTimeSeconds;
    double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
    bool cycleCompleted = false;

    // Start electrostimulation if not already on.
    if (!isElectroOn.value) {
      await startFullElectrostimulationTrajeProcess(
          selectedMacAddress.value, selectedProgramName.value
      ).then((success) {
        isElectroOn.value = true;
      });
    }

    // Immediately set UI to maximum.
    remainingContractionSeconds.value = totalDurationInSeconds.toDouble();

    bool firstTick = true;

    contractionCycleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isTimerPaused.value) {
        timer.cancel();
        _remainingContractionTime = (contractionProgress.value * totalDurationInSeconds).toInt();
        print("Contraction paused with $_remainingContractionTime seconds remaining.");
        return;
      }
      if (firstTick) {
        firstTick = false;
        remainingContractionSeconds.value = totalDurationInSeconds.toDouble();
        return;
      }
      if (contractionProgress.value > 0) {
        contractionProgress.value -= decrementAmount;
        remainingContractionSeconds.value = (contractionProgress.value * totalDurationInSeconds).ceilToDouble();
      } else {
        contractionProgress.value = 0;
        remainingContractionSeconds.value = 0;
        timer.cancel();
        cycleCompleted = true;
      }
    });

    while (!cycleCompleted) {
      if (isTimerPaused.value) return;
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("Contraction cycle for ${program['subProgramName']} completed.");
  }

  /// Modified pause cycle.
  Future<void> startAutoPauseTimeCycle(var program, int runTimeSeconds) async {
    pauseSeconds.value = runTimeSeconds;
    pauseProgress.value = 1.0;
    int totalDurationInSeconds = runTimeSeconds;
    double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
    bool cycleCompleted = false;

    // Stop electrostimulation during pause.
    stopElectrostimulationProcess(selectedMacAddress.value);

    remainingPauseSeconds.value = totalDurationInSeconds.toDouble();

    bool firstTick = true;

    pauseCycleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isTimerPaused.value) {
        timer.cancel();
        _remainingPauseTime = (pauseProgress.value * totalDurationInSeconds).toInt();
        print("Pause cycle paused with $_remainingPauseTime seconds remaining.");
        return;
      }
      if (firstTick) {
        firstTick = false;
        remainingPauseSeconds.value = totalDurationInSeconds.toDouble();
        return;
      }
      if (pauseProgress.value > 0) {
        pauseProgress.value -= decrementAmount;
        remainingPauseSeconds.value = (pauseProgress.value * totalDurationInSeconds).ceilToDouble();
      } else {
        pauseProgress.value = 0;
        remainingPauseSeconds.value = 0;
        timer.cancel();
        cycleCompleted = true;
      }
    });

    while (!cycleCompleted) {
      if (isTimerPaused.value) return;
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("Pause cycle for ${program['subProgramName']} completed.");
  }


  cancelTimersOnTimeUp(){
    contractionCycleTimer?.cancel();
    pauseCycleTimer?.cancel();
    isTimerPaused.value = true;
    contractionProgress.value = 0;
    pauseProgress.value = 0;
    isContractionPauseCycleActive.value = false;
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

  setProgramDetails({required String programName, required String image, required String mainProgramName}){
    selectedProgramName.value = programName;
    selectedProgramImage.value = image;
    selectedMainProgramName.value = mainProgramName;
    isProgramSelected.value = true;
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
        chestPercentage[selectedDeviceIndex.value] = clampValue(chestPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        chestPercentage[selectedDeviceIndex.value] = clampValue(chestPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(chestPercentage[selectedDeviceIndex.value], isChest: true);
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
              chestPercentage[selectedDeviceIndex.value] = clampValue(chestPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
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
            calculateIntensityColor(chestPercentage[selectedDeviceIndex.value], isChest: true);
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

  /// Select client
  var isDropdownOpen = false.obs;
  final TextEditingController nameController = TextEditingController();
  RxMap<int, Map<String, dynamic>> selectedClients = RxMap<int, Map<String, dynamic>>();
  RxList<String> selectedClientNames = <String>[].obs;
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

  /// Reset all programs value and intensity colors
  resetProgramValues() {
    chestPercentage[selectedDeviceIndex.value] = 0;
    armsPercentage.value = 0;
    abdomenPercentage.value = 0;
    legsPercentage.value = 0;
    upperBackPercentage.value = 0;
    middleBackPercentage.value = 0;
    lumbarPercentage.value = 0;
    buttocksPercentage.value = 0;
    hamStringsPercentage.value = 0;
    calvesPercentage.value = 0;
    chestIntensityColor = AppColors.lowIntensityColor;
    armsIntensityColor = AppColors.lowIntensityColor;
    abdomenIntensityColor = AppColors.lowIntensityColor;
    legsIntensityColor = AppColors.lowIntensityColor;
    upperBackIntensityColor = AppColors.lowIntensityColor;
    middleBackIntensityColor = AppColors.lowIntensityColor;
    lumbarsIntensityColor = AppColors.lowIntensityColor;
    buttocksIntensityColor = AppColors.lowIntensityColor;
    hamstringsIntensityColor = AppColors.lowIntensityColor;
    calvesIntensityColor = AppColors.lowIntensityColor;
  }


  // void setClientInfoForDevice(int deviceIndex, dynamic clientData) {
  //   selectedClients[deviceIndex] = clientData;
  //   String newName = selectedClients[deviceIndex]!['name'];
  //
  //   // If the device index already exists in the list, update it.
  //   if (deviceIndex < selectedClientNames.length) {
  //     // Only update if the new name is different at that device index.
  //     if (selectedClientNames[deviceIndex] != newName) {
  //       selectedClientNames[deviceIndex] = newName;
  //     }
  //   }
  //   // If the device index equals the current length, simply append.
  //   else if (deviceIndex == selectedClientNames.length) {
  //     selectedClientNames.add(newName);
  //   }
  //   // If the deviceIndex is greater than the list length (a gap), you might decide how to handle it.
  //   else {
  //     // Optionally fill the gap with nulls or placeholders then add.
  //     for (int i = selectedClientNames.length; i < deviceIndex; i++) {
  //        selectedClientNames.add(''); // or null if you prefer
  //     }
  //     selectedClientNames.add(newName);
  //   }
  //
  //   update();
  // }


  setClientInfoForDevice(int deviceIndex, dynamic clientData) {
    selectedClients[deviceIndex] = clientData;
    String newName = selectedClients[deviceIndex]!['name'];
    // Only add if the name isn't already in the list
    if (!selectedClientNames.contains(newName)) {
      selectedClientNames.add(newName);
    }
    update();
  }

  /// Bluetooth connectivity

  BleConnectionService bleConnectionService = BleConnectionService();
  BleCommandService bleCommandService = BleCommandService();
  late StreamSubscription _subscription;
  bool isDisconnected = true;
  bool isConnected = false;
  String? selectedKey;
  String? macAddress;
  String? grupoKey;
  int? selectedIndex = 0;
  int? totalBonosSeleccionados = 0;
  String connectionStatus = "desconectado";
  double scaleFactorBack = 1.0;
  Map<String, int> equipSelectionMap = {};
  // Set<String> processedDevices = {};

  ValueNotifier<List<String>> successfullyConnectedDevices = ValueNotifier([]);
  List<String> connectedDevices = [];


  // final Map<String, String> deviceConnectionStatus = {};
  Map<String, String> clientsNames = {};
  Map<String, String> bluetoothNames = {};
  Map<String, int> batteryStatuses = {};
  Map<String, Key> mciKeys = {};
  Map<String, String?> mciSelectionStatus = {};
  Map<String, String?> temporarySelectionStatus = {};
  Map<String, bool> isSelected = {};
  final Map<String, StreamSubscription<bool>> _connectionSubscriptions = {};
  RxList<String> newMacAddresses = <String>[].obs;
  RxMap<String, String> deviceConnectionStatus = <String, String>{}.obs;
  RxList<String> processedDevices = <String>[].obs;


  RxBool isLoading = false.obs;

  initializeBluetoothConnection() async {
    isLoading.value = true;
    await initializeAndConnectBLE();
    List<String> list = await bleConnectionService.scanTargetDevices();
    print('list: $list');
    if(list.isEmpty){
      isLoading.value = false;
    }
    _subscription = bleConnectionService.deviceUpdates.listen((update) {
      isUpdate.value = false;
      final macAddress = update['macAddress'];

        if (update.containsKey('bluetoothName')) {
          bluetoothNames[macAddress] = update['bluetoothName'];
          print('bluetoothNames: ${bluetoothNames[macAddress]}');
        }
        if (update.containsKey('batteryStatus')) {
          batteryStatuses[macAddress] = update['batteryStatus'];
          print('batteryStatus: ${batteryStatuses[macAddress]}');
        }

    });
    print('Subscription called');
    isUpdate.value = true;
    update();
  }

  Future<void> initializeAndConnectBLE() async {

    print('initializeAndConnectBLE');
    debugPrint("🛠️ Inicializando BLE y conexiones...");
    bleConnectionService.isWidgetActive = true;
    try {
      await AppState.instance.loadState().timeout(Duration(seconds: 5));
    }
    catch (e) {
      debugPrint("❌ Error al cargar el estado de la app: $e");
      return;
    }

    List<String> macAddresses =
    AppState.instance.mcis.map((mci) => mci['mac'] as String).toList();
    debugPrint("🔍 Direcciones MAC obtenidas: $macAddresses");


    newMacAddresses.value = macAddresses
        .where((mac) => !bleConnectionService.connectedDevices.contains(mac))
        .toList();

    if (newMacAddresses.isNotEmpty) {
      bleConnectionService.updateMacAddresses(newMacAddresses);
    }

    successfullyConnectedDevices.value.clear();
    deviceConnectionStatus.clear();

    for (final macAddress in macAddresses) {
      deviceConnectionStatus[macAddress] = 'desconectado';

      StreamSubscription<bool>? subscription;
      subscription =
          bleConnectionService.connectionStateStream(macAddress).listen(
                (isConnected) {
                  print('Connected');
              if (isConnected) {
                if (!successfullyConnectedDevices.value.contains(macAddress)) {
                  successfullyConnectedDevices.value = [
                    ...successfullyConnectedDevices.value,
                    macAddress,
                  ];
                }
              }
              else {
                successfullyConnectedDevices.value = successfullyConnectedDevices
                    .value
                    .where((device) => device != macAddress)
                    .toList();
              }

                  deviceConnectionStatus[macAddress] =
                  isConnected ? 'conectado' : 'desconectado';
              print('Mac Addresses: ${newMacAddresses}');
              print('ConnectadoONo: ${deviceConnectionStatus[newMacAddresses[0]]}');
              print('ConnectadoONo: ${deviceConnectionStatus[newMacAddresses[1]]}');
              print('macAddress: $macAddress');
              isLoading.value = false;
              print('isLoading.value: ${isLoading.value}');
            },
            onError: (error) {
              debugPrint("❌ Error en la conexión de $macAddress: $error");

                  deviceConnectionStatus[macAddress] = 'error';

            },
          );

      _connectionSubscriptions[macAddress] = subscription;
    }
    update();
  }

  Future<void> selectDevice(String macAddress) async {
    if (deviceConnectionStatus[macAddress] == 'conectado' || deviceConnectionStatus[macAddress] == 'connected') {
    // if (deviceConnectionStatus[macAddress] == 'connected') {
      // Process the device if it's connected
      if (!processedDevices.contains(macAddress)) {
        await bleConnectionService.processConnectedDevices(macAddress);
        processedDevices.add(macAddress);
        isBluetoothConnected.value = true;
      } else {
        print("✅ El dispositivo $macAddress ya fue procesado.");
      }
    } else {
      // Handle logic when the device is not connected
      /// mac address, but not connected/off
      print("❌ El dispositivo $macAddress no está conectado.");
      if (!successfullyConnectedDevices.value.contains(macAddress)) {
        onTapConnectToDevice(macAddress);
      }
      else {
        print("✅ El dispositivo $macAddress ya está conectado exitosamente.");
      }
    }
    isUpdate.value = true;
    // Notify GetX that the state has changed
    update();  // Ensure UI is updated after selecting the device
  }

  void onTapConnectToDevice(String macAddress) async {
    debugPrint("🛠️ Scanning device $macAddress before attempting connection...");

    // Scan for available devices before attempting to connect
    List<String> availableDevices = await bleConnectionService.scanTargetDevices();
    if(availableDevices.isEmpty){
      isLoading.value = false;
    }

    // Check if the specific device is available
    if (!availableDevices.contains(macAddress)) {
      debugPrint("❌ The device $macAddress was not found in the scan. Cannot connect.");
      // errorMessage.value = 'The device $macAddress was not found in the scan. Cannot connect.';
      return;
    }

    // Check if already connected before trying to connect
    if (bleConnectionService.connectedDevices.contains(macAddress)) {
      debugPrint("✅ The device $macAddress is already connected.");
      return;
    }

    // Add a 500ms delay before connecting
    await Future.delayed(Duration(milliseconds: 500));

    // Change the status to "connecting"
    deviceConnectionStatus[macAddress] = 'connecting';
     // Update UI if necessary

    // Try to connect
    bool success = await bleConnectionService.connectToDeviceByMac(macAddress);

    if (success) {
      // Subscribe to the connection stream to update the status in real time
      bleConnectionService.connectionStateStream(macAddress).listen(
            (isConnected) {
          if (isConnected) {
            if (!successfullyConnectedDevices.value.contains(macAddress)) {
              successfullyConnectedDevices.value = [
                ...successfullyConnectedDevices.value,
                macAddress,
              ];
            }
            print('Bluetooth connected');
            isBluetoothConnected.value = true;
          } else {
            successfullyConnectedDevices.value = successfullyConnectedDevices.value
                .where((device) => device != macAddress)
                .toList();
          }


              deviceConnectionStatus[macAddress] = isConnected ? 'connected' : 'disconnected';


        },
        onError: (error) {
          debugPrint("❌ Error connecting to $macAddress: $error");
              deviceConnectionStatus[macAddress] = 'error';
        },
      );
    } else {
      debugPrint("⚠️ Could not connect to $macAddress. Trying to reconnect...");
    }

    debugPrint("✅ Connection process to $macAddress completed.");
  }

  Map<String, dynamic> getProgramSettings(String? selectedProgram) {
    debugPrint("🔹 getProgramSettings() - Iniciando con selectedProgram: $selectedProgram");


    print('selectedProgramType.value: ${selectedProgramType.value}');
    print('selectedProgramDetails: $selectedProgramDetails');
    // Usando los valores actuales de los ValueNotifiers pasados desde ExpandedContentWidget
    double? frecuencia;
    double? rampa;
    double? pulso;
    double? pause;
    double? contraction;
    List<dynamic> cronaxias;
    List<dynamic> grupos;
    Map<String, dynamic>? selectedProgramData;

    if(selectedProgramType.value == Strings.individual){
      frecuencia = selectedProgramDetails['frecuencia'];
      rampa = selectedProgramDetails['rampa'];
      pulso = selectedProgramDetails['pulso'] == 'CX' ? 0.0 : selectedProgramDetails['pulso'];
      pause = selectedProgramDetails['pausa'];
      contraction = selectedProgramDetails['contraccion'];
      // double contraction = contractionSeconds.value.toDouble();

       cronaxias = selectedProgramDetails['cronaxias'];
       grupos = selectedProgramDetails['grupos_musculares'];
    }
    else{
      frecuencia = selectedProgramDetails['subprogramas'][currentIndex.value]['frecuencia'];
      rampa = selectedProgramDetails['subprogramas'][currentIndex.value]['rampa'];
      pulso = selectedProgramDetails['subprogramas'][currentIndex.value]['pulso'] == 'CX'
          ? 0.0
          : selectedProgramDetails['subprogramas'][currentIndex.value]['pulso'];
      pause = selectedProgramDetails['subprogramas'][currentIndex.value]['pausa'];
      contraction = selectedProgramDetails['subprogramas'][currentIndex.value]['contraccion'];
      // double contraction = contractionSeconds.value.toDouble();

      cronaxias = autoProgramCronaxias;
      grupos = autoProgramGrupos;
    }

    selectedProgramData = selectedProgramDetails;


    if(selectedProgramType.value == Strings.individual){
      cronaxias = (selectedProgramData?['cronaxias'] as List<dynamic>?)
          ?.map((c) => {'id': c['id'], 'nombre': c['nombre'], 'valor': c['valor']})
          .toList() ?? selectedProgramDetails['cronaxias'];

      grupos = (selectedProgramData?['grupos_musculares'] as List<dynamic>?)
          ?.map((g) => {'id': g['id']})
          .toList() ?? selectedProgramDetails['grupos_musculares'];
    }
    else{
      cronaxias = autoProgramCronaxias
          .map((c) => {'id': c['id'], 'nombre': c['nombre'], 'valor': c['valor']})
          .toList();

      grupos = autoProgramGrupos
          .map((g) => {'id': g['id']})
          .toList();

    }

    if (selectedProgramData != null) {
      frecuencia = selectedProgramData['frecuencia'] ?? frecuencia;
      rampa = selectedProgramData['rampa'] ?? rampa;
      pulso = pulso ?? selectedProgramData['pulso'];
    }

    // 🔥 Evitar devolver `selectedClient` si ya fue eliminado
    // Map<String, dynamic>? clienteData = selectedClient;
    // if (selectedClient == null || !widget.clientSelectedMap.value.containsValue(selectedClient)) {
    //   clienteData = null;
    // }

    debugPrint("📊 Datos obtenidos en getProgramSettings:");
    // debugPrint("   - Cliente: ${clienteData != null ? clienteData['name'] : 'Ninguno'}");
    debugPrint("   - Frecuencia: $frecuencia");
    debugPrint("   - Rampa: $rampa");
    debugPrint("   - Pulso: $pulso");
    debugPrint("   - Pausa: $pause");
    debugPrint("   - Contracción: $contraction");
    debugPrint("   - Cronaxias: $cronaxias");
    debugPrint("   - Grupos musculares: $grupos");

    return {
      // 'cliente': clienteData,
      'frecuencia': frecuencia,
      'rampa': rampa,
      'pulso': pulso,
      'pausa': pause,
      'contraccion': contraction,
      'cronaxias': cronaxias,
      'grupos_musculares': grupos,
    };
  }

  Future<bool> startFullElectrostimulationTrajeProcess(
      String macAddress, String? selectedProgram) async {
    try {
      // Configurar los valores de los canales del traje
      List<int> valoresCanalesTraje = List.filled(10, 0);

      valoresCanalesTraje[0] = isPantSelected.value ? 0 : upperBackPercentage.value;
      valoresCanalesTraje[1] = isPantSelected.value ? 0 : middleBackPercentage.value;
      valoresCanalesTraje[2] = isPantSelected.value ? 0 : lumbarPercentage.value;
      valoresCanalesTraje[3] = buttocksPercentage.value;
      valoresCanalesTraje[4] = hamStringsPercentage.value;
      valoresCanalesTraje[5] = isPantSelected.value ? 0 : chestPercentage[selectedDeviceIndex.value];
      valoresCanalesTraje[6] = legsPercentage.value;
      valoresCanalesTraje[7] = abdomenPercentage.value;
      valoresCanalesTraje[8] = armsPercentage.value;
      valoresCanalesTraje[9] = isPantSelected.value ? calvesPercentage.value : 0;

      debugPrint("📊 Valores de canales configurados: $valoresCanalesTraje");

      // Obtener configuraciones del programa seleccionado
      Map<String, dynamic> settings = getProgramSettings(selectedProgram);

      // Log program settings to make sure they are correct
      debugPrint("⚙️ Program Settings: $settings");

      double frecuencia = settings['frecuencia'] ?? 50;
      double rampa = settings['rampa'] ?? 30;
      double pulso = settings['pulso'] ?? 20;

      // Ajustes de conversión
      rampa *= 1000;
      pulso /= 5;

      debugPrint(
          "⚙️ Configuración del programa: Frecuencia: $frecuencia Hz, Rampa: $rampa ms, Pulso: $pulso µs");

      // Verify that macAddress is valid and the device is connected
      debugPrint("🔌 Checking BLE connection status for $macAddress...");


      // Iniciar sesión de electroestimulación
      print('macAddress: $macAddress');
      print('valoresCanalesTraje: $valoresCanalesTraje');
      print('frecuencia: $frecuencia');
      print('rampa: $rampa');
      print('pulso: $pulso');

      final isElectroOn = await bleCommandService.startElectrostimulationSession(
        macAddress,
        valoresCanalesTraje,
        frecuencia,
        rampa,
        pulso: pulso,
      );

      if (!isElectroOn) {
        debugPrint("❌ Error al iniciar la electroestimulación en $macAddress.");
        return false;
      }

      // Controlar todos los canales del dispositivo
      final response = await bleCommandService.controlAllChannels(
        macAddress,
        1, // Endpoint
        0, // Modo
        valoresCanalesTraje,
      );

      // Check response from controlAllChannels method
      debugPrint("💬 Control All Channels response: $response");

      if (response['resultado'] != "OK") {
        debugPrint("❌ Error al configurar los canales: $response");
        return false;
      }

      debugPrint(
          "✅ Proceso completo de electroestimulación iniciado correctamente en $macAddress.");
      return true;
    } catch (e) {
      debugPrint("❌ Error en el proceso completo de electroestimulación: $e");
      return false;
    }
  }


  Future<bool> stopElectrostimulationProcess(String macAddress) async {
    try {
      // Check if electrostimulation is active
      if (isElectroOn.value) {
        debugPrint(
            "🛑 Stopping electrostimulation on device ${macAddress}...");

        // Call the service to stop the electrostimulation session
        await bleCommandService
            .stopElectrostimulationSession(macAddress);


          // Update UI state

            isElectroOn.value = false; // Change the flag to reflect that it is stopped



        debugPrint(
            "✅ Electrostimulation stopped successfully at ${macAddress}.");
        return true; // Operation successful
      } else {
        debugPrint(
            "⚠️ There are no active electrostimulation sessions to stop.");
        return false; // There was no active session to stop
      }
    } catch (e) {
      debugPrint(
          "❌ Error stopping electrostimulation on ${macAddress}: $e");
      return false; // Error during operation
    }
  }



  resetEverything() {
    Get.delete<DashboardController>();
  }

  @override
  void onClose() {
    _timer?.cancel();
    contractionCycleTimer?.cancel();
    pauseCycleTimer?.cancel();
    nameController.dispose();
    bleConnectionService.removeBluetoothConnection();
    super.onClose();
  }

}

