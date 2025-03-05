import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/bluetooth/ble_command_service.dart';
import 'package:i_model/bluetooth/bluetooth_service.dart';
import 'package:i_model/core/app_state.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/enum/program_status.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/client/clients.dart';
import 'package:i_model/models/program.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardController extends GetxController {
  /// Programs value percentages
  RxList<int> chestPercentage = <int>[].obs;
  RxList<int> armsPercentage = <int>[].obs;
  RxList<int> abdomenPercentage = <int>[].obs;
  RxList<int> legsPercentage = <int>[].obs;
  RxList<int> upperBackPercentage = <int>[].obs;
  RxList<int> middleBackPercentage = <int>[].obs;
  RxList<int> lumbarPercentage = <int>[].obs;
  RxList<int> buttocksPercentage = <int>[].obs;
  RxList<int> hamStringsPercentage = <int>[].obs;
  RxList<int> calvesPercentage = <int>[].obs;

  // RxInt chestPercentage = 0.obs;
  // RxInt armsPercentage = 0.obs;
  // RxInt abdomenPercentage = 0.obs;
  // RxInt legsPercentage = 0.obs;
  // RxInt upperBackPercentage = 0.obs;
  // RxInt middleBackPercentage = 0.obs;
  // RxInt lumbarPercentage = 0.obs;
  // RxInt buttocksPercentage = 0.obs;
  // RxInt hamStringsPercentage = 0.obs;
  // RxInt calvesPercentage = 0.obs;
  // RxString selectedProgramType = Strings.individual.obs;
  // RxInt frequency = 0.obs;
  // RxInt pulse = 0.obs;
  // RxString selectedProgramName = Strings.nothing.obs;
  // RxString selectedMainProgramName = Strings.nothing.obs;
  // RxString selectedProgramImage = Strings.celluliteIcon.obs;
  // RxBool isProgramSelected = false.obs;
  // RxBool isActive = false.obs;
  // RxBool isElectroOn = false.obs;
  // RxBool isPantSelected = false.obs;
  // RxString errorMessage = Strings.nothing.obs;
  // RxMap<String, dynamic> selectedProgramDetails = <String, dynamic>{}.obs;
  // RxString selectedMacAddress = Strings.nothing.obs;
  // RxBool isTimerPaused = true.obs;
  // RxInt remainingSeconds = 0.obs;
  // RxInt minutes = 0.obs;
  // Timer? _timer;
  // RxString timerImage = Strings.min_25_icon.obs;
  // RxInt pauseSeconds = 0.obs;
  // RxInt contractionSeconds = 0.obs;
  // RxDouble contractionProgress = 0.0.obs;
  // RxDouble pauseProgress = 0.0.obs;
  // Timer? contractionCycleTimer;
  // Timer? pauseCycleTimer;
  // RxDouble remainingContractionSeconds = 0.0.obs;
  // RxDouble remainingPauseSeconds = 0.0.obs;
  // RxBool isContractionPauseCycleActive = false.obs;

  RxList<String> selectedProgramType = <String>[].obs;
  RxList<int> frequency = <int>[].obs;
  RxList<int> pulse = <int>[].obs;
  RxList<String> selectedProgramName = <String>[].obs;
  RxList<String> selectedMainProgramName = <String>[].obs;
  RxList<String> selectedProgramImage = <String>[].obs;
  RxList<bool> isProgramSelected = <bool>[].obs;
  List<Map<String, dynamic>> automaticProgramList = [];
  List<Map<String, dynamic>> individualProgramList = [];
  List<int> currentIndex = <int>[];
  List<Map<String, dynamic>> selectedProgramDetails = <Map<String, dynamic>>[];
  List<bool> isElectroOn = <bool>[];
  RxList<bool> isPantSelected = <bool>[].obs;
  RxList<bool> isActive = <bool>[].obs;

  // RxInt currentIndex = 0.obs;
  RxBool isBluetoothConnected = false.obs;
  RxBool isDashboardLoading = false.obs;
  RxInt selectedDeviceIndex = (-1).obs;
  RxList<String> selectedMacAddress = <String>[].obs;
  RxBool isUpdate = false.obs;

  /// Timer values
  RxList<int> remainingSeconds = <int>[].obs;
  RxList<int> minutes = <int>[].obs;
  RxList<bool> isTimerPaused = <bool>[].obs;
  RxList<bool> isDurationTimerPaused = <bool>[].obs;
  List<Timer?> timer = [];
  RxList<String> timerImage = <String>[].obs;

  int maxPercentage = 100;
  int minPercentage = 0;
  int maxMinutes = 30;
  RxBool isEKalWidgetVisible = true.obs;

  /// Contraction and pause line painters
  RxList<int> pauseSeconds = <int>[].obs;
  RxList<int> contractionSeconds = <int>[].obs;
  RxList<double> contractionProgress = <double>[].obs;
  RxList<double> pauseProgress = <double>[].obs;
  RxList<bool> isActiveRecovery = <bool>[].obs;

  ///  Timer? contractionCycleTimer;
  List<Timer?> contractionCycleTimer = [];
  List<Timer?> pauseCycleTimer = [];
  List<Timer?> remainingDurationTimer = [];
  RxList<double> remainingContractionSeconds = <double>[].obs;
  RxList<double> remainingPauseSeconds = <double>[].obs;
  RxList<bool> isContractionPauseCycleActive = <bool>[].obs;
  RxList<int> remainingProgramDuration = <int>[].obs;

  List<int> currentProgramIndex = <int>[];
  List<int> elapsedTime = <int>[];
  List<int> _remainingContractionTime = <int>[];
  List<int> _remainingPauseTime = <int>[];
  List<int> remainingSecondsAfterPause = <int>[];
  List<CyclePhase?> _currentCyclePhase = <CyclePhase?>[];


  RxList<List<Map<String, dynamic>>> automaticProgramValues = <List<Map<String, dynamic>>>[].obs;
  // RxList<Map<String, dynamic>> automaticProgramValues = <Map<String, dynamic>>[].obs;
  RxList<List<Program>> programsStatus = <List<Program>>[].obs;
  List<int> jumpSeconds = <int>[];
  List<DateTime?> programEndTime = <DateTime>[];


  /// DONE UNTIL HERE

  final AudioPlayer _audioPlayer = AudioPlayer();
  int totalMCIs = 0;
  /// Bluetooth connectivity
  BleConnectionService bleConnectionService = BleConnectionService();
  BleCommandService bleCommandService = BleCommandService();
  late StreamSubscription _subscription;
  ValueNotifier<List<String>> successfullyConnectedDevices = ValueNotifier([]);

  bool isFirstTime = true;

  @override
  Future<void> onInit() async {
    isDashboardLoading.value = true;
    if(isFirstTime) {
      initializeBluetoothConnection();
      isFirstTime = false;
    }
    print('onInit called');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // int initialMinutes = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    // remainingSeconds[selectedDeviceIndex.value == (-1) ? 0 : selectedDeviceIndex.value] = initialMinutes * 60;
    // remainingSeconds.value = initialMinutes * 60;
    automaticProgramList = await fetchAutoPrograms();
    individualProgramList = await fetchIndividualPrograms();
    await initProgramsAndTimers();
    Future.delayed(Duration(milliseconds: 300), () {
      isDashboardLoading.value = false;
    });
    super.onInit();
  }

  initProgramsAndTimers() async {
    totalMCIs = AppState.instance.mcis.length;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int initialMinutes = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    if(totalMCIs == 0){
      totalMCIs = 1;
    }
    print('totalMCIs: $totalMCIs');

    /// Programs percentage values
    chestPercentage.value = List.generate(totalMCIs, (index) => 0);
    armsPercentage.value = List.generate(totalMCIs, (index) => 0);
    abdomenPercentage.value = List.generate(totalMCIs, (index) => 0);
    legsPercentage.value = List.generate(totalMCIs, (index) => 0);
    upperBackPercentage.value = List.generate(totalMCIs, (index) => 0);
    middleBackPercentage.value = List.generate(totalMCIs, (index) => 0);
    lumbarPercentage.value = List.generate(totalMCIs, (index) => 0);
    buttocksPercentage.value = List.generate(totalMCIs, (index) => 0);
    hamStringsPercentage.value = List.generate(totalMCIs, (index) => 0);
    calvesPercentage.value = List.generate(totalMCIs, (index) => 0);

    /// Programs intensity colors
    chestIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    armsIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    abdomenIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    legsIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    upperBackIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    middleBackIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    lumbarsIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    buttocksIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    hamstringsIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);
    calvesIntensityColor.value = List.generate(totalMCIs, (index) => AppColors.lowIntensityColor);

    /// Program details like frequency, pulse, image, name
    selectedProgramType.value = List.generate(totalMCIs, (index) => Strings.individual);
    selectedProgramName.value = List.generate(totalMCIs, (index) => Strings.nothing);
    selectedMainProgramName.value = List.generate(totalMCIs, (index) => Strings.nothing);
    selectedProgramImage.value = List.generate(totalMCIs, (index) => Strings.celluliteIcon);
    frequency.value = List.generate(totalMCIs, (index) => 0);
    pulse.value = List.generate(totalMCIs, (index) => 0);

    isProgramSelected.value = List.generate(totalMCIs, (index) => false);
    isElectroOn = List.generate(totalMCIs, (index) => false);
    isPantSelected.value = List.generate(totalMCIs, (index) => false);
    isActive.value = List.generate(totalMCIs, (index) => false);
    selectedProgramDetails = List.generate(totalMCIs, (index) => {});


    /// Main Timer
    selectedMacAddress.value = List.generate(totalMCIs, (index) => Strings.nothing);
    remainingSeconds.value = List.generate(totalMCIs, (index) => initialMinutes * 60);
    minutes.value = List.generate(totalMCIs, (index) => 0);
    isTimerPaused.value = List.generate(totalMCIs, (index) => true);
    isDurationTimerPaused.value = List.generate(totalMCIs, (index) => false);
    timer = List.generate(totalMCIs, (index) => null);
    timerImage.value = List.generate(totalMCIs, (index) => Strings.min_25_icon);

    /// Contraction and pause Timers / Line painters
    contractionCycleTimer = List.generate(totalMCIs, (index) => null);
    pauseCycleTimer = List.generate(totalMCIs, (index) => null);
    remainingDurationTimer = List.generate(totalMCIs, (index) => null);
    pauseSeconds.value = List.generate(totalMCIs, (index) => 0);
    contractionSeconds.value = List.generate(totalMCIs, (index) => 0);
    contractionProgress.value = List.generate(totalMCIs, (index) => 0.0);
    pauseProgress.value = List.generate(totalMCIs, (index) => 0.0);
    isActiveRecovery.value = List.generate(totalMCIs, (index) => false);
    remainingContractionSeconds.value = List.generate(totalMCIs, (index) => 0.0);
    remainingPauseSeconds.value = List.generate(totalMCIs, (index) => 0.0);
    isContractionPauseCycleActive.value = List.generate(totalMCIs, (index) => false);
    remainingProgramDuration.value = List.generate(totalMCIs, (index) => 0);

    currentProgramIndex = List.generate(totalMCIs, (index) => 0);
    elapsedTime = List.generate(totalMCIs, (index) => 0);
    remainingSecondsAfterPause = List.generate(totalMCIs, (index) => 0);
    _remainingContractionTime = List.generate(totalMCIs, (index) => 0);
    _remainingPauseTime = List.generate(totalMCIs, (index) => 0);
    _currentCyclePhase = List.generate(totalMCIs, (index) => null);

    automaticProgramValues.value = List.generate(totalMCIs, (index) => []);
    currentIndex = List.generate(totalMCIs, (index) => 0);
    jumpSeconds = List.generate(totalMCIs, (index) => 1);
    programEndTime = List.generate(totalMCIs, (index) => null);

    programsStatus = RxList.generate(
      totalMCIs,
          (index) => <Program>[
        Program(name: Strings.chest, status: ProgramStatus.active.obs),
        Program(name: Strings.arms, status: ProgramStatus.active.obs),
        Program(name: Strings.abdomen, status: ProgramStatus.active.obs),
        Program(name: Strings.legs, status: ProgramStatus.active.obs),
        Program(name: Strings.upperBack, status: ProgramStatus.active.obs),
        Program(name: Strings.middleBack, status: ProgramStatus.active.obs),
        Program(name: Strings.lowerBack, status: ProgramStatus.active.obs),
        Program(name: Strings.glutes, status: ProgramStatus.active.obs),
        Program(name: Strings.hamstrings, status: ProgramStatus.active.obs),
        Program(name: Strings.calves, status: ProgramStatus.active.obs),
      ].obs,
    );

  }


  /// Handling program active, inactive and block states
  // RxList<Program> programsStatus = <Program>[
  //   Program(name: Strings.chest, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.arms, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.abdomen, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.legs, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.upperBack, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.middleBack, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.lowerBack, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.glutes, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.hamstrings, status: ProgramStatus.active.obs,),
  //   Program(name: Strings.calves, status: ProgramStatus.active.obs,),
  // ].obs;

  // /// Individual program list
  // List<Program> individualProgramsList(BuildContext context){
  //   return [
  //     Program(name: translation(context).cellulite, image: Strings.celluliteIcon),
  //     Program(name: translation(context).buttocks, image: Strings.buttocksIndividualIcon),
  //     Program(name: translation(context).contractures, image: Strings.contracturesIcon),
  //     Program(name: translation(context).drainage, image: Strings.drainageIcon),
  //     Program(name: translation(context).hypertrophy, image: Strings.hypertrophyIcon),
  //     Program(name: translation(context).pelvicFloor, image: Strings.pelvicFloorIcon),
  //     Program(name: translation(context).slim, image: Strings.slimIcon),
  //     Program(name: translation(context).toning, image: Strings.toningIcon),
  //     Program(name: translation(context).massage, image: Strings.massageIcon),
  //     Program(name: translation(context).metabolic, image: Strings.metabolicIcon),
  //     Program(name: translation(context).calibration, image: Strings.calibrationIcon),
  //     Program(name: translation(context).strength, image: Strings.strengthIcon),
  //   ];
  // }

  // List<Program> automaticProgramsList(BuildContext context){
  //   return [
  //     Program(name: translation(context).buttocks, image: Strings.buttocksAutoIcon),
  //     Program(name: translation(context).cellulite, image: Strings.celluliteAutoIcon,),
  //     Program(name: translation(context).hypertrophy, image: Strings.hypertrophyAutoIcon),
  //     Program(name: translation(context).pelvicFloor, image: Strings.pelvicFloorAutoIcon),
  //     Program(name: translation(context).slim, image: Strings.slimAutoIcon),
  //     Program(name: translation(context).toning, image: Strings.toningAutoIcon),
  //   ];
  // }

  /// Update the status of a program
  void updateProgramStatus(String programName, ProgramStatus newStatus) {
    var program = programsStatus[selectedDeviceIndex.value].firstWhereOrNull((p) => p.name == programName);
    if (program != null) {
      program.status!.value = newStatus;

    }
    update();

  }

  /// Intensity colors
  RxList<Color> chestIntensityColor = <Color>[].obs;
  RxList<Color> armsIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> abdomenIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> legsIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> upperBackIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> middleBackIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> lumbarsIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> buttocksIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> hamstringsIntensityColor = <Color>[AppColors.lowIntensityColor].obs;
  RxList<Color> calvesIntensityColor = <Color>[AppColors.lowIntensityColor].obs;

  // Color chestIntensityColor = AppColors.lowIntensityColor;
  // Color armsIntensityColor = AppColors.lowIntensityColor;
  // Color abdomenIntensityColor = AppColors.lowIntensityColor;
  // Color legsIntensityColor = AppColors.lowIntensityColor;
  // Color upperBackIntensityColor = AppColors.lowIntensityColor;
  // Color middleBackIntensityColor = AppColors.lowIntensityColor;
  // Color lumbarsIntensityColor = AppColors.lowIntensityColor;
  // Color buttocksIntensityColor = AppColors.lowIntensityColor;
  // Color hamstringsIntensityColor = AppColors.lowIntensityColor;
  // Color calvesIntensityColor = AppColors.lowIntensityColor;


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
    remainingSeconds[selectedDeviceIndex.value] = initialMinutes * 60;

    contractionCycleTimer[selectedDeviceIndex.value]?.cancel();
    pauseCycleTimer[selectedDeviceIndex.value]?.cancel();
    isContractionPauseCycleActive[selectedDeviceIndex.value] = false;
    contractionProgress[selectedDeviceIndex.value] = 0;
    pauseProgress[selectedDeviceIndex.value] = 0;
    remainingContractionSeconds[selectedDeviceIndex.value] = 0;
    remainingPauseSeconds[selectedDeviceIndex.value] = 0;
  }

  setActiveRecovery(int deviceIndex){
    isActiveRecovery[deviceIndex] = !isActiveRecovery[deviceIndex];
    update();
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

  void onAutoProgramSelected(Map<String, dynamic>? programA, int deviceIndex) async {
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
      remainingSeconds[deviceIndex] = (programA['duracionTotal'] * 60).toInt();
    } catch (e) {
      debugPrint("❌ Error en onAutoProgramSelected: $e");
    }
  }


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


  String formatTime(int totalSeconds, int widgetIndex) {
    final int minutesValue = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final formattedTime = "${minutesValue.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    // Defer state updates until after the build using the correct index.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (minutes[widgetIndex] != minutesValue) {
        minutes[widgetIndex] = minutesValue;
      }
      final newTimerImage = 'assets/counter/${minutesValue}-MIN.png';
      if (timerImage[widgetIndex] != newTimerImage) {
        timerImage[widgetIndex] = newTimerImage;
        // Optionally trigger a rebuild if needed, e.g., controller.update();
      }
    });

    return formattedTime;
  }


  /// Main Timer
  void startTimer(int deviceIndex, String macAddress) {
    isTimerPaused[deviceIndex] = false;
    // isDurationTimerPaused[deviceIndex] = true;
    update();

    if (timer[deviceIndex] != null) {
      timer[deviceIndex]!.cancel();
    }

    timer[deviceIndex] = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isTimerPaused[deviceIndex]) {
        if (remainingSeconds[deviceIndex] > 0) {
          print('remainingSeconds[deviceIndex]: ${remainingSeconds[deviceIndex]}');
          remainingSeconds[deviceIndex] = remainingSeconds[deviceIndex] - 1;
        }
        else{
          timer.cancel();
          // cancelTimersOnTimeUp(deviceIndex);
          resetProgramValues(macAddress, deviceIndex, isProgramFinished: true);
          playResetAudio();
        }
      } else {
        timer.cancel();

      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });

    });
  }


  /// Contraction time cycle
  Future<void> startContractionTimeCycle(int deviceIndex, String macAddress) async {
    isContractionPauseCycleActive[deviceIndex] = true;
    contractionProgress[deviceIndex] = 1.0;
    double decrementAmount = 1.0 / (contractionSeconds[deviceIndex] * 10);
    int totalDurationInSeconds = contractionSeconds[deviceIndex];


    // Start electrostimulation if needed.
    if (!isElectroOn[deviceIndex]) {
      startFullElectrostimulationTrajeProcess(
          macAddress,
          selectedProgramName[deviceIndex],
          deviceIndex
      ).then((success) {
        isElectroOn[deviceIndex] = true;
      });
    }

    // Immediately set UI to max value.
    remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();

    bool firstTick = true;

    contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (firstTick) {
        firstTick = false;
        remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
        return;
      }
      if (contractionProgress[deviceIndex] > 0) {
        remainingContractionSeconds[deviceIndex] = (totalDurationInSeconds * contractionProgress[deviceIndex]).ceilToDouble();
        contractionProgress[deviceIndex] -= decrementAmount;
      } else {
        contractionProgress[deviceIndex] = 0;
        remainingContractionSeconds[deviceIndex] = 0;
        contractionCycleTimer[deviceIndex]?.cancel();
        startPauseTimeCycle(deviceIndex, macAddress);
      }
    });
  }

  /// Pause time cycle
  Future<void> startPauseTimeCycle(int deviceIndex, String macAddress) async {

    pauseProgress[deviceIndex] = 1.0;
    double decrementAmount = 1.0 / (pauseSeconds[deviceIndex] * 10);
    int totalDurationInSeconds = pauseSeconds[deviceIndex];

    remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();

    bool firstTick = true;

    // Stop electrostimulation during pause.
    stopElectrostimulationProcess(macAddress, deviceIndex);

    pauseCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (firstTick) {
        firstTick = false;
        remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
        return;
      }
      if (pauseProgress[deviceIndex] > 0) {
        remainingPauseSeconds[deviceIndex] = (totalDurationInSeconds * pauseProgress[deviceIndex]).ceilToDouble();
        pauseProgress[deviceIndex] -= decrementAmount;
      }
      else {
        pauseProgress[deviceIndex] = 0;
        remainingPauseSeconds[deviceIndex] = 0;
        pauseCycleTimer[deviceIndex]?.cancel();
        startContractionTimeCycle(deviceIndex, macAddress);
      }
    });
  }

  /// Pulse cycle
  Future<void> startPulseCycle(var program) async {
    print("Starting pulse for ${program['subProgramName']} with frequency: ${program['frequency']} Hz and pulse: ${program['pulse']}");
    // Pulse logic here, you can implement your pulse method depending on the requirement
    await Future.delayed(Duration(seconds: 1)); // Simulate pulse cycle delay for now
  }




  cancelTimersOnTimeUp(int deviceIndex){
    contractionCycleTimer[deviceIndex]?.cancel();
    pauseCycleTimer[deviceIndex]?.cancel();
    isTimerPaused[deviceIndex] = true;
    isContractionPauseCycleActive[deviceIndex] = false;
    contractionProgress[deviceIndex] = 0;
    pauseProgress[deviceIndex] = 0;
    isContractionPauseCycleActive[deviceIndex] = false;
    selectedProgramImage[deviceIndex] = Strings.celluliteIcon;
    selectedMainProgramName[deviceIndex] = Strings.nothing;
    selectedProgramName[deviceIndex] = Strings.nothing;
    frequency[deviceIndex] = 0;
    pulse[deviceIndex] = 0;
    isProgramSelected[deviceIndex] = false;

  }
  int currentSeconds = 0;

  pauseTimer() {
    isTimerPaused[selectedDeviceIndex.value] = true;
    update();
  }

  void increaseMinute() {
    if (minutes[selectedDeviceIndex.value] < maxMinutes) {
      remainingSeconds[selectedDeviceIndex.value] += 60;
    }
    update();
  }

  void decreaseMinute() {
    if (minutes[selectedDeviceIndex.value] > 0) {
      remainingSeconds[selectedDeviceIndex.value] -= 60;
    }
    update();
  }

  changeEKalMenuVisibility() {
    isEKalWidgetVisible.value = !isEKalWidgetVisible.value;
    update();
  }

  changeSuitSelection() {
    isPantSelected[selectedDeviceIndex.value] = !isPantSelected[selectedDeviceIndex.value];
    update();
  }

  changeActiveState() {
    isActive[selectedDeviceIndex.value] = !isActive[selectedDeviceIndex.value];
    update();
  }

  changeProgramType({bool isIndividual = true}){
    if(isIndividual){
      selectedProgramType[selectedDeviceIndex.value] = Strings.automatics;
    }
    else{
      selectedProgramType[selectedDeviceIndex.value] = Strings.individual;
    }
    update();
  }

  setProgramDetails({required String programName, required String image, required String mainProgramName}){
    selectedProgramName[selectedDeviceIndex.value] = programName;
    selectedProgramImage[selectedDeviceIndex.value] = image;
    selectedMainProgramName[selectedDeviceIndex.value] = mainProgramName;
    isProgramSelected[selectedDeviceIndex.value] = true;
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
        chestIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        chestIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        chestIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        chestIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Arms intensity color
    if (isArms) {
      if (intensity > 0 && intensity < 10) {
        armsIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        armsIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        armsIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        armsIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Upper back intensity colors
    if (isUpperBack) {
      if (intensity > 0 && intensity < 10) {
        upperBackIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        upperBackIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        upperBackIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        upperBackIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Middle back intensity colors
    if (isMiddleBack) {
      if (intensity > 0 && intensity < 10) {
        middleBackIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 10 && intensity < 20) {
        middleBackIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 20 && intensity < 35) {
        middleBackIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 35) {
        middleBackIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Abdomen intensity colors
    if (isAbdomen) {
      if (intensity > 0 && intensity < 25) {
        abdomenIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 25 && intensity < 45) {
        abdomenIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 45 && intensity < 70) {
        abdomenIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 70) {
        abdomenIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Legs intensity color
    if (isLegs) {
      if (intensity > 0 && intensity < 20) {
        legsIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 20 && intensity < 40) {
        legsIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 40 && intensity < 60) {
        legsIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 60) {
        legsIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Lumbar intensity color
    if (isLumbars) {
      if (intensity > 0 && intensity < 15) {
        lumbarsIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        lumbarsIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        lumbarsIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        lumbarsIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Buttocks intensity color
    if (isButtocks) {
      if (intensity > 0 && intensity < 25) {
        buttocksIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 25 && intensity < 45) {
        buttocksIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 45 && intensity < 70) {
        buttocksIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 70) {
        buttocksIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Hamstrings intensity color
    if (isHamstrings) {
      if (intensity > 0 && intensity < 15) {
        hamstringsIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        hamstringsIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        hamstringsIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        hamstringsIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }

    /// Calves intensity color
    if (isCalves) {
      if (intensity > 0 && intensity < 15) {
        calvesIntensityColor[selectedDeviceIndex.value] = AppColors.lowIntensityColor;
      }
      if (intensity >= 15 && intensity < 30) {
        calvesIntensityColor[selectedDeviceIndex.value] = AppColors.lowMediumIntensityColor;
      }
      if (intensity >= 30 && intensity < 50) {
        calvesIntensityColor[selectedDeviceIndex.value] = AppColors.mediumHighIntensityColor;
      }
      if (intensity >= 50) {
        calvesIntensityColor[selectedDeviceIndex.value] = AppColors.highIntensityColor;
      }
    }
    update();
  }

  int clampValue(int value, int min, int max) {
    return value.clamp(min, max);
  }

  /// Change individual program percentages
  void changeChestPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][0].status!.value == ProgramStatus.active) {
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
    if (programsStatus[selectedDeviceIndex.value][1].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        armsPercentage[selectedDeviceIndex.value] = clampValue(
            armsPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        armsPercentage[selectedDeviceIndex.value] = clampValue(
            armsPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(armsPercentage[selectedDeviceIndex.value], isArms: true);
      update();
    }
  }


  void changeAbdomenPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][2].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        abdomenPercentage[selectedDeviceIndex.value] = clampValue(
            abdomenPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        abdomenPercentage[selectedDeviceIndex.value] = clampValue(
            abdomenPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(abdomenPercentage[selectedDeviceIndex.value], isAbdomen: true);
      update();
    }
  }

  void changeLegsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][3].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        legsPercentage[selectedDeviceIndex.value] = clampValue(
            legsPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        legsPercentage[selectedDeviceIndex.value] = clampValue(
            legsPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(legsPercentage[selectedDeviceIndex.value], isLegs: true);
      update();
    }
  }

  void changeUpperBackPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][4].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        upperBackPercentage[selectedDeviceIndex.value] = clampValue(
            upperBackPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        upperBackPercentage[selectedDeviceIndex.value] = clampValue(
            upperBackPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(upperBackPercentage[selectedDeviceIndex.value], isUpperBack: true);
      update();
    }
  }

  void changeMiddleBackPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][5].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        middleBackPercentage[selectedDeviceIndex.value] = clampValue(
            middleBackPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        middleBackPercentage[selectedDeviceIndex.value] = clampValue(
            middleBackPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(middleBackPercentage[selectedDeviceIndex.value], isMiddleBack: true);
      update();
    }
  }

  void changeLumbarPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][6].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        lumbarPercentage[selectedDeviceIndex.value] = clampValue(
            lumbarPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        lumbarPercentage[selectedDeviceIndex.value] = clampValue(
            lumbarPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(lumbarPercentage[selectedDeviceIndex.value], isLumbars: true);
      update();
    }
  }

  void changeButtocksPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][7].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        buttocksPercentage[selectedDeviceIndex.value] = clampValue(
            buttocksPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        buttocksPercentage[selectedDeviceIndex.value] = clampValue(
            buttocksPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(buttocksPercentage[selectedDeviceIndex.value], isButtocks: true);
      update();
    }
  }

  void changeHamStringsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][8].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        hamStringsPercentage[selectedDeviceIndex.value] = clampValue(
            hamStringsPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        hamStringsPercentage[selectedDeviceIndex.value] = clampValue(
            hamStringsPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(hamStringsPercentage[selectedDeviceIndex.value], isHamstrings: true);
      update();
    }
  }

  void changeCalvesPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (programsStatus[selectedDeviceIndex.value][9].status!.value == ProgramStatus.active) {
      if (isIncrease) {
        calvesPercentage[selectedDeviceIndex.value] = clampValue(
            calvesPercentage[selectedDeviceIndex.value] + 1, minPercentage, maxPercentage);
      }
      if (isDecrease) {
        calvesPercentage[selectedDeviceIndex.value] = clampValue(
            calvesPercentage[selectedDeviceIndex.value] - 1, minPercentage, maxPercentage);
      }
      calculateIntensityColor(calvesPercentage[selectedDeviceIndex.value], isCalves: true);
      update();
    }
  }


  /// Change percentages of all programs
  void changeAllProgramsPercentage({bool isDecrease = false, bool isIncrease = false}) {
    if (isIncrease || isDecrease) {
      int delta = isIncrease ? 1 : -1;

      for (var program in programsStatus[selectedDeviceIndex.value]) {
        if (program.status!.value == ProgramStatus.active) {
          switch (program.name) {
            case Strings.chest:
              chestPercentage[selectedDeviceIndex.value] = clampValue(
                  chestPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.arms:
              armsPercentage[selectedDeviceIndex.value] = clampValue(
                  armsPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.abdomen:
              abdomenPercentage[selectedDeviceIndex.value] = clampValue(
                  abdomenPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.legs:
              legsPercentage[selectedDeviceIndex.value] = clampValue(
                  legsPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.upperBack:
              upperBackPercentage[selectedDeviceIndex.value] = clampValue(
                  upperBackPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.middleBack:
              middleBackPercentage[selectedDeviceIndex.value] = clampValue(
                  middleBackPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.lowerBack:
              lumbarPercentage[selectedDeviceIndex.value] = clampValue(
                  lumbarPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.glutes:
              buttocksPercentage[selectedDeviceIndex.value] = clampValue(
                  buttocksPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.hamstrings:
              hamStringsPercentage[selectedDeviceIndex.value] = clampValue(
                  hamStringsPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
            case Strings.calves:
              calvesPercentage[selectedDeviceIndex.value] = clampValue(
                  calvesPercentage[selectedDeviceIndex.value] + delta, minPercentage, maxPercentage);
              break;
          }
        }
      }
    }

    /// Update intensity colors based on the changed percentages
    for (var program in programsStatus[selectedDeviceIndex.value]) {
      if (program.status!.value == ProgramStatus.active) {
        switch (program.name) {
          case Strings.chest:
            calculateIntensityColor(chestPercentage[selectedDeviceIndex.value], isChest: true);
            break;
          case Strings.arms:
            calculateIntensityColor(armsPercentage[selectedDeviceIndex.value], isArms: true);
            break;
          case Strings.abdomen:
            calculateIntensityColor(abdomenPercentage[selectedDeviceIndex.value], isAbdomen: true);
            break;
          case Strings.legs:
            calculateIntensityColor(legsPercentage[selectedDeviceIndex.value], isLegs: true);
            break;
          case Strings.upperBack:
            calculateIntensityColor(upperBackPercentage[selectedDeviceIndex.value], isUpperBack: true);
            break;
          case Strings.middleBack:
            calculateIntensityColor(middleBackPercentage[selectedDeviceIndex.value], isMiddleBack: true);
            break;
          case Strings.lowerBack:
            calculateIntensityColor(lumbarPercentage[selectedDeviceIndex.value], isLumbars: true);
            break;
          case Strings.glutes:
            calculateIntensityColor(buttocksPercentage[selectedDeviceIndex.value], isButtocks: true);
            break;
          case Strings.hamstrings:
            calculateIntensityColor(hamStringsPercentage[selectedDeviceIndex.value], isHamstrings: true);
            break;
          case Strings.calves:
            calculateIntensityColor(calvesPercentage[selectedDeviceIndex.value], isCalves: true);
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

  /// Reset all programs values
  resetProgramValues(macAddress, deviceIndex, {bool isProgramFinished = false}) {
    int index = isProgramFinished ? deviceIndex : selectedDeviceIndex.value;

    chestPercentage[index] = 0;
    armsPercentage[index] = 0;
    abdomenPercentage[index] = 0;
    legsPercentage[index] = 0;
    upperBackPercentage[index] = 0;
    middleBackPercentage[index] = 0;
    lumbarPercentage[index] = 0;
    buttocksPercentage[index] = 0;
    hamStringsPercentage[index] = 0;
    calvesPercentage[index] = 0;

    chestIntensityColor[index] = AppColors.lowIntensityColor;
    armsIntensityColor[index] = AppColors.lowIntensityColor;
    abdomenIntensityColor[index] = AppColors.lowIntensityColor;
    legsIntensityColor[index] = AppColors.lowIntensityColor;
    upperBackIntensityColor[index] = AppColors.lowIntensityColor;
    middleBackIntensityColor[index] = AppColors.lowIntensityColor;
    lumbarsIntensityColor[index] = AppColors.lowIntensityColor;
    buttocksIntensityColor[index] = AppColors.lowIntensityColor;
    hamstringsIntensityColor[index] = AppColors.lowIntensityColor;
    calvesIntensityColor[index] = AppColors.lowIntensityColor;

    selectedProgramType[index] = Strings.individual;
    selectedProgramName[index] = Strings.nothing;
    selectedMainProgramName[index] = Strings.nothing;
    selectedProgramImage[index] = Strings.celluliteIcon;
    frequency[index] = 0;
    pulse[index] = 0;
    isProgramSelected[index] = false;
    isPantSelected[index] = false;
    isContractionPauseCycleActive[index] = false;
    selectedProgramDetails[index] = {};
    contractionSeconds[index] = 0;
    pauseSeconds[index] = 0;
    isTimerPaused[index] = true;
    remainingProgramDuration[index] = 0;
    remainingSecondsAfterPause[index] = 0;
    jumpSeconds[index] = 1;
    programEndTime[index] = null;

    if (timer[index] != null) {
      timer[index]?.cancel();
    }
    stopElectrostimulationProcess(macAddress, index);
    playResetAudio();
    resetProgramTimerValue();

    update();
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


  // RxBool isLoading = false.obs;

  initializeBluetoothConnection() async {
    print('initializeBluetoothConnection (from inside function)');
    // isLoading.value = true;
    await initializeAndConnectBLE();
    // List<String> list = await bleConnectionService.scanTargetDevices();
    // print('list: $list');
    // if(list.isEmpty){
    //   isLoading.value = false;
    // }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  Future<void> initializeAndConnectBLE() async {

    print('initializeAndConnectBLE');
    debugPrint("🛠️ Inicializando BLE y conexiones...");

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
              // isLoading.value = false;
            },
            onError: (error) {
              debugPrint("❌ Error en la conexión de $macAddress: $error");

              deviceConnectionStatus[macAddress] = 'error';

            },
          );

      _connectionSubscriptions[macAddress] = subscription;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
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
    // if(availableDevices.isEmpty){
    //   isLoading.value = false;
    // }

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

  Map<String, dynamic> getProgramSettings(String? selectedProgram, int deviceIndex) {
    debugPrint("🔹 getProgramSettings() - Iniciando con selectedProgram: $selectedProgram");


    // print('selectedProgramType.value: ${selectedProgramType.value}');
    // print('selectedProgramDetails: $selectedProgramDetails');
    // Usando los valores actuales de los ValueNotifiers pasados desde ExpandedContentWidget
    double? frecuencia;
    double? rampa;
    double? pulso;
    double? pause;
    double? contraction;
    List<dynamic> cronaxias = [];
    List<dynamic> grupos = [];
    Map<String, dynamic>? selectedProgramData;

    if(selectedProgramType[deviceIndex] == Strings.individual){
      frecuencia = selectedProgramDetails[deviceIndex]['frecuencia'];
      rampa = selectedProgramDetails[deviceIndex]['rampa'];
      pulso = selectedProgramDetails[deviceIndex]['pulso'] == 'CX' ? 0.0 : selectedProgramDetails[deviceIndex]['pulso'];
      pause = selectedProgramDetails[deviceIndex]['pausa'];
      contraction = selectedProgramDetails[deviceIndex]['contraccion'];
      // double contraction = contractionSeconds.value.toDouble();

       cronaxias = selectedProgramDetails[deviceIndex]['cronaxias'] ?? [];
       grupos = selectedProgramDetails[deviceIndex]['grupos_musculares'] ?? [];
    }
    else if(selectedProgramType[deviceIndex] == Strings.automatics){
      if(selectedProgramDetails[deviceIndex]['subprogramas'] != null){
        frecuencia = selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['frecuencia'];
        rampa = selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['rampa'];
        pulso = selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['pulso'] == 'CX'
            ? 0.0
            : selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['pulso'];
        pause = selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['pausa'];
        contraction = selectedProgramDetails[deviceIndex]['subprogramas'][currentIndex[deviceIndex]]['contraccion'];
        // double contraction = contractionSeconds.value.toDouble();

        cronaxias = autoProgramCronaxias;
        grupos = autoProgramGrupos;
      }
    }

    selectedProgramData = selectedProgramDetails[deviceIndex];


    if(selectedProgramType[deviceIndex] == Strings.individual){
      if(cronaxias.isNotEmpty) {
        cronaxias = (selectedProgramData?['cronaxias'] as List<dynamic>?)
          ?.map((c) => {'id': c['id'], 'nombre': c['nombre'], 'valor': c['valor']})
          .toList() ?? selectedProgramDetails[selectedDeviceIndex.value]['cronaxias'];
      }

      if(grupos.isNotEmpty) {
        grupos = (selectedProgramData?['grupos_musculares'] as List<dynamic>?)
          ?.map((g) => {'id': g['id']})
          .toList() ?? selectedProgramDetails[selectedDeviceIndex.value]['grupos_musculares'];
      }
    }
    else{
      cronaxias = autoProgramCronaxias
          .map((c) => {'id': c['id'], 'nombre': c['nombre'], 'valor': c['valor']})
          .toList();

      grupos = autoProgramGrupos
          .map((g) => {'id': g['id']})
          .toList();
    }

    // if (selectedProgramData != null) {
    //   frecuencia = selectedProgramData['frecuencia'] ?? frecuencia;
    //   rampa = selectedProgramData['rampa'] ?? rampa;
    //   pulso = pulso ?? selectedProgramData['pulso'];
    //   print('selectedProgramData: $selectedProgramData');
    // }

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

  Future<void> playResetAudio() async {
    await _audioPlayer.play(AssetSource(Strings.beepAudio));
  }

  String formatProgramDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Deep seek solution

  // void logStateTransition(int deviceIndex, String fromPhase, String toPhase) {
  //   print("[Device $deviceIndex] Transitioning from $fromPhase to $toPhase");
  //   logDeviceState(deviceIndex, "State after transition:");
  // }


  // void logDeviceState(int deviceIndex, String message) {
  //   print("[Device $deviceIndex] $message");
  //   print("[Device $deviceIndex] elapsedTime: ${elapsedTime[deviceIndex]}");
  //   print("[Device $deviceIndex] _currentCyclePhase: ${_currentCyclePhase[deviceIndex]}");
  //   print("[Device $deviceIndex] _remainingContractionTime: ${_remainingContractionTime[deviceIndex]}");
  //   print("[Device $deviceIndex] _remainingPauseTime: ${_remainingPauseTime[deviceIndex]}");
  //   print("[Device $deviceIndex] isElectroOn: ${isElectroOn[deviceIndex]}");
  //   print("[Device $deviceIndex] isTimerPaused: ${isTimerPaused[deviceIndex]}");
  // }

  // Example of state initialization for each device
  void initializeStateForDevice(int deviceIndex) {
    contractionCycleTimer[deviceIndex] = null;
    pauseCycleTimer[deviceIndex] = null;
    isElectroOn[deviceIndex] = false;
    contractionProgress[deviceIndex] = 1.0;
    pauseProgress[deviceIndex] = 1.0;
    remainingContractionSeconds[deviceIndex] = 0;
    remainingPauseSeconds[deviceIndex] = 0;
    elapsedTime[deviceIndex] = 0;
    _currentCyclePhase[deviceIndex] = null;
    _remainingContractionTime[deviceIndex] = 0;
    _remainingPauseTime[deviceIndex] = 0;
  }
  /// Deep seek

  void cancelTimersForDevice(int deviceIndex) {
    contractionCycleTimer[deviceIndex]?.cancel();
    pauseCycleTimer[deviceIndex]?.cancel();
    contractionCycleTimer[deviceIndex] = null;
    pauseCycleTimer[deviceIndex] = null;
  }

  // calculateRemainingDuration(int deviceIndex, int totalProgramSeconds, bool shouldBreakWhileLoop){
  //   if(remainingSecondsAfterPause[deviceIndex] != 0){
  //     remainingProgramDuration[deviceIndex] = remainingSecondsAfterPause[deviceIndex];
  //   }
  //   else {
  //     remainingProgramDuration[deviceIndex] = totalProgramSeconds;
  //   }
  //
  //   remainingDurationTimer[deviceIndex] = Timer.periodic(Duration(seconds: 1), (timer) {
  //     if(isTimerPaused[deviceIndex]){
  //       timer.cancel();
  //     }
  //     if (!isTimerPaused[deviceIndex]) {
  //       // Subtract 1 second per tick
  //       remainingProgramDuration[deviceIndex]--;
  //       remainingSecondsAfterPause[deviceIndex] = remainingProgramDuration[deviceIndex];
  //
  //       // print("Remaining seconds for device $deviceIndex: ${remainingProgramDuration[deviceIndex]}");
  //
  //       if (remainingProgramDuration[deviceIndex] <= 0) {
  //         // print("Remaining seconds for device $deviceIndex: 0");
  //         shouldBreakWhileLoop = true;
  //         remainingSecondsAfterPause[deviceIndex] = 0;
  //         timer.cancel();
  //         return;
  //       }
  //     }
  //   });
  // }
  // int jumpSeconds = 1;


  Future<void> startContractionForMultiplePrograms(int deviceIndex, String macAddress) async {
    if (automaticProgramValues[deviceIndex].isEmpty) {
      print("No programs to process.");
      return;
    }

    initializeStateForDevice(deviceIndex);
    isContractionPauseCycleActive[deviceIndex] = true;
    // logDeviceState(deviceIndex, "Starting contraction for multiple programs.");

    for (; currentProgramIndex[deviceIndex] < automaticProgramValues[deviceIndex].length; currentProgramIndex[deviceIndex]++) {
      var program = automaticProgramValues[deviceIndex][currentProgramIndex[deviceIndex]];
      double durationInMinutes = program['duration'];
      int totalProgramSeconds = (durationInMinutes * 60).toInt();

      // logDeviceState(deviceIndex, "Starting program: ${program['subProgramName']} for $totalProgramSeconds seconds.");
      selectedProgramImage[deviceIndex] = program['image'];
      selectedProgramName[deviceIndex] = program['subProgramName'];
      frequency[deviceIndex] = program['frequency'].toInt();
      pulse[deviceIndex] = program['pulse'].toInt();

      await startPulseCycle(program);

      // Flag to signal the while loop to exit when time is up.
      bool shouldBreakWhileLoop = false;

      if(programEndTime[deviceIndex] != null){
        jumpSeconds[deviceIndex] =  DateTime.now().difference(programEndTime[deviceIndex]!).inSeconds;
        print('programStartTime: $jumpSeconds');
      }

      // Assume totalProgramSeconds is defined and used to initialize remainingProgramDuration.
      if(remainingSecondsAfterPause[deviceIndex] != 0){
        remainingProgramDuration[deviceIndex] = remainingSecondsAfterPause[deviceIndex] - 1;
      }
      else {
        remainingProgramDuration[deviceIndex] = totalProgramSeconds - jumpSeconds[deviceIndex];
      }



      remainingDurationTimer[deviceIndex] = Timer.periodic(Duration(seconds: 1), (timer) {
        if(isTimerPaused[deviceIndex]){
          timer.cancel();
        }
        if (!isTimerPaused[deviceIndex]) {
          // Subtract 1 second per tick
          remainingProgramDuration[deviceIndex]--;
          remainingSecondsAfterPause[deviceIndex] = remainingProgramDuration[deviceIndex];

          // print("Remaining seconds for device $deviceIndex: ${remainingProgramDuration[deviceIndex]}");

          if (remainingProgramDuration[deviceIndex] <= 0) {
            // print("Remaining seconds for device $deviceIndex: 0");
            shouldBreakWhileLoop = true;
            // jumpSeconds = 3;
            programEndTime[deviceIndex] = DateTime.now();
            remainingSecondsAfterPause[deviceIndex] = 0;
            timer.cancel();
            return;
          }
        }
      });


      // Main loop for processing contraction and pause cycles.
      while (elapsedTime[deviceIndex] < totalProgramSeconds && !shouldBreakWhileLoop) {
        // Your existing cycle logic goes here.
        // For example:
        if (_currentCyclePhase[deviceIndex] == CyclePhase.pause && _remainingPauseTime[deviceIndex] > 0) {
          print("[Device $deviceIndex] Transitioning from pause to contraction.");
          _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
          isElectroOn[deviceIndex] = true; // Ensure electrostimulation is on
          await runContractionCycle(program, _remainingContractionTime[deviceIndex], deviceIndex, macAddress);
          if (isTimerPaused[deviceIndex]) return;
          elapsedTime[deviceIndex] += _remainingContractionTime[deviceIndex];
          _remainingContractionTime[deviceIndex] = 0;
          continue;
        } else if (_currentCyclePhase[deviceIndex] == CyclePhase.contraction && _remainingContractionTime[deviceIndex] > 0) {
          // logStateTransition(deviceIndex, "contraction", "pause");
          await runContractionCycle(program, _remainingContractionTime[deviceIndex], deviceIndex, macAddress);
          if (isTimerPaused[deviceIndex]) return;
          elapsedTime[deviceIndex] += _remainingContractionTime[deviceIndex];
          _remainingContractionTime[deviceIndex] = 0;
          _currentCyclePhase[deviceIndex] = CyclePhase.pause;
          if (elapsedTime[deviceIndex] >= totalProgramSeconds) break;
          continue;
        } else if (_currentCyclePhase[deviceIndex] == null || _currentCyclePhase[deviceIndex] == CyclePhase.contraction) {
          int contractionDuration = program['contraction'].toInt();
          int remainingTime = totalProgramSeconds - elapsedTime[deviceIndex];
          int contractionRunTime = (remainingTime < contractionDuration) ? remainingTime : contractionDuration;
          _remainingContractionTime[deviceIndex] = contractionRunTime;
          _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
          // logStateTransition(deviceIndex, "null/contraction", "contraction");
          await runContractionCycle(program, contractionRunTime, deviceIndex, macAddress);
          if (isTimerPaused[deviceIndex]) return;
          elapsedTime[deviceIndex] += contractionRunTime;
          _remainingContractionTime[deviceIndex] = 0;
          _currentCyclePhase[deviceIndex] = CyclePhase.pause;
          if (elapsedTime[deviceIndex] >= totalProgramSeconds) break;
        }

        if (_currentCyclePhase[deviceIndex] == CyclePhase.pause) {
          int pauseDuration = program['pause'].toInt();
          if (pauseDuration == 0) {
            // logDeviceState(deviceIndex, "Pause duration is zero. Skipping pause cycle.");
            _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
            isElectroOn[deviceIndex] = false;
            continue;
          }
          int remainingTime = totalProgramSeconds - elapsedTime[deviceIndex];
          int pauseRunTime = (remainingTime < pauseDuration) ? remainingTime : pauseDuration;
          _remainingPauseTime[deviceIndex] = pauseRunTime;
          // logStateTransition(deviceIndex, "contraction", "pause");
          await startAutoPauseTimeCycle(program, pauseRunTime, deviceIndex, macAddress);
          if (isTimerPaused[deviceIndex]) return;
          elapsedTime[deviceIndex] += pauseRunTime;
          _remainingPauseTime[deviceIndex] = 0;
          _currentCyclePhase[deviceIndex] = CyclePhase.contraction;
        }

        // Optionally add a small delay if needed to avoid a tight loop:
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Ensure the timer is cancelled if it hasn't already.
      remainingDurationTimer[deviceIndex]?.cancel();

      // Reset your state for the next program iteration.
      elapsedTime[deviceIndex] = 0;
      _remainingContractionTime[deviceIndex] = 0;
      _remainingPauseTime[deviceIndex] = 0;
      _currentCyclePhase[deviceIndex] = null;
      currentIndex[deviceIndex]++;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
    // logDeviceState(deviceIndex, "All programs completed.");
  }

  Future<void> runContractionCycle(var program, int runTimeSeconds, int deviceIndex, String macAddress) async {
    try {
      print("[Device $deviceIndex] Entering contraction cycle for '${program['subProgramName']}' with duration $runTimeSeconds seconds.");

      if (!isElectroOn[deviceIndex]) {
        print("[Device $deviceIndex] Starting electrostimulation.");
        await startFullElectrostimulationTrajeProcess(
          macAddress,
          selectedProgramName[deviceIndex],
          deviceIndex,
        ).then((success) {
          if (success) {
            isElectroOn[deviceIndex] = true;
            print("[Device $deviceIndex] Electrostimulation started successfully.");
          } else {
            print("[Device $deviceIndex] Failed to start electrostimulation.");
            return; // Exit if electrostimulation fails
          }
        });
      }

      // Initialize variables
      contractionSeconds[deviceIndex] = runTimeSeconds;
      contractionProgress[deviceIndex] = 1.0;
      int totalDurationInSeconds = runTimeSeconds;
      double decrementAmount = 1.0 / (totalDurationInSeconds * 10); // Decrement per 100ms
      bool cycleCompleted = false;

      // Set initial UI values
      remainingContractionSeconds[deviceIndex] = totalDurationInSeconds.toDouble();

      // Timer for the contraction cycle
      print("[Device $deviceIndex] Starting contraction cycle timer.");
      contractionCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (isTimerPaused[deviceIndex]) {
          print("[Device $deviceIndex] Pause detected. Cancelling timer.");
          timer.cancel();
          // _remainingContractionTime[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).toInt();
          print("[Device $deviceIndex] Contraction paused with $_remainingContractionTime seconds remaining.");
          return;
        }

        // Update progress
        if (contractionProgress[deviceIndex] > 0) {
          contractionProgress[deviceIndex] -= decrementAmount;
          remainingContractionSeconds[deviceIndex] = (contractionProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
          // print("[Device $deviceIndex] Contraction tick -> progress: ${contractionProgress[deviceIndex]}, remaining seconds: ${remainingContractionSeconds[deviceIndex]}");
        } else {
          // Cycle completed
          contractionProgress[deviceIndex] = 0;
          remainingContractionSeconds[deviceIndex] = 0;
          timer.cancel();
          cycleCompleted = true;
          print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' completed.");
        }
      });

      // Wait for the cycle to complete
      while (!cycleCompleted) {
        if (isTimerPaused[deviceIndex]) {
          print("[Device $deviceIndex] Cycle paused. Exiting loop.");
          return;
        }
        await Future.delayed(Duration(milliseconds: 100));
      }

      print("[Device $deviceIndex] Contraction cycle for '${program['subProgramName']}' fully completed.");
    } catch (e) {
      print("[Device $deviceIndex] Error in contraction cycle: $e");
    }
  }

  Future<void> startAutoPauseTimeCycle(var program, int runTimeSeconds, int deviceIndex, String macAddress) async {
    pauseSeconds[deviceIndex] = runTimeSeconds;
    pauseProgress[deviceIndex] = 1.0;
    int totalDurationInSeconds = runTimeSeconds;

    if (totalDurationInSeconds == 0) {
      print("Pause duration is zero. Skipping pause cycle.");
      remainingPauseSeconds[deviceIndex] = 0;
      isElectroOn[deviceIndex] = false;
      return;
    }

    double decrementAmount = 1.0 / (totalDurationInSeconds * 10);
    bool cycleCompleted = false;

    // Stop electrostimulation during pause.
    stopElectrostimulationProcess(macAddress, deviceIndex);

    remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();

    print('remainingPauseSeconds: $remainingPauseSeconds');
    bool firstTick = true;

    pauseCycleTimer[deviceIndex] = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isTimerPaused[deviceIndex]) {
        timer.cancel();
        _remainingPauseTime[deviceIndex] = (pauseProgress[deviceIndex] * totalDurationInSeconds).toInt();
        print("Pause cycle paused with $_remainingPauseTime seconds remaining.");
        return;
      }
      if (firstTick) {
        firstTick = false;
        remainingPauseSeconds[deviceIndex] = totalDurationInSeconds.toDouble();
        return;
      }
      if (pauseProgress[deviceIndex] > 0) {
        pauseProgress[deviceIndex] -= decrementAmount;
        remainingPauseSeconds[deviceIndex] = (pauseProgress[deviceIndex] * totalDurationInSeconds).ceilToDouble();
      } else {
        pauseProgress[deviceIndex] = 0;
        remainingPauseSeconds[deviceIndex] = 0;
        timer.cancel();
        cycleCompleted = true;
      }
    });

    while (!cycleCompleted) {
      if (isTimerPaused[deviceIndex]) return;
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("Pause cycle for ${program['subProgramName']} completed.");
  }


  Future<bool> startFullElectrostimulationTrajeProcess(
      String macAddress, String? selectedProgram, int deviceIndex) async {
    // try {
      // Configurar los valores de los canales del traje
      List<int> valoresCanalesTraje = List.filled(10, 0);

      valoresCanalesTraje[0] = isPantSelected[deviceIndex] ? 0 : upperBackPercentage[deviceIndex];
      valoresCanalesTraje[1] = isPantSelected[deviceIndex] ? 0 : middleBackPercentage[deviceIndex];
      valoresCanalesTraje[2] = isPantSelected[deviceIndex] ? 0 : lumbarPercentage[deviceIndex];
      valoresCanalesTraje[3] = buttocksPercentage[deviceIndex];
      valoresCanalesTraje[4] = hamStringsPercentage[deviceIndex];
      valoresCanalesTraje[5] = isPantSelected[deviceIndex] ? 0 : chestPercentage[deviceIndex];
      valoresCanalesTraje[6] = legsPercentage[deviceIndex];
      valoresCanalesTraje[7] = abdomenPercentage[deviceIndex];
      valoresCanalesTraje[8] = armsPercentage[deviceIndex];
      valoresCanalesTraje[9] = isPantSelected[deviceIndex] ? calvesPercentage[deviceIndex] : 0;

      debugPrint("📊 Valores de canales configurados: $valoresCanalesTraje");

      // Obtener configuraciones del programa seleccionado
      Map<String, dynamic> settings = getProgramSettings(selectedProgram, deviceIndex);

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
    // } catch (e) {
    //   debugPrint("❌ Error en el proceso completo de electroestimulación: $e");
    //   return false;
    // }
  }


  Future<bool> stopElectrostimulationProcess(String macAddress, int deviceIndex) async {
    try {
      // Check if electrostimulation is active
      if (isElectroOn[deviceIndex]) {
        debugPrint(
            "🛑 Stopping electrostimulation on device ${macAddress}...");

        // Call the service to stop the electrostimulation session
        await bleCommandService
            .stopElectrostimulationSession(macAddress);


          // Update UI state

            isElectroOn[deviceIndex] = false; // Change the flag to reflect that it is stopped



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
    Future.delayed(Duration(milliseconds: 300), () {
      Get.delete<DashboardController>();
    });

    // Get.delete<DashboardController>();
  }

  @override
  void onClose() {
    for(int i=0; i<totalMCIs; i++){
      timer[i]?.cancel();
      contractionCycleTimer[i]?.cancel();
      pauseCycleTimer[i]?.cancel();
      remainingDurationTimer[i]?.cancel();
    }
    nameController.dispose();
    bleConnectionService.disconnectAllDevices();
    super.onClose();
  }

}

