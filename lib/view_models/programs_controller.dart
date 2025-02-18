import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/colors.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/program.dart';
import 'package:i_model/models/program_details.dart';
import 'package:i_model/models/programs/automatic/sub_program.dart';
import 'package:i_model/models/programs/individual/cronaxia.dart';
import 'package:i_model/models/programs/individual/individual_program.dart';
import 'package:i_model/models/programs/individual/muscle_group.dart';
import 'package:i_model/views/dialogs/sucess_dialog.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:sqflite/sqflite.dart';

import '../models/programs/automatic/automatic_program.dart';

class ProgramsController extends GetxController{
  final TextEditingController individualProgramNameController = TextEditingController();
  final TextEditingController automaticProgramNameController = TextEditingController();
  FocusNode autoProgramFocusNode = FocusNode();
  FocusNode orderFocusNode = FocusNode();
  FocusNode durationFocusNode = FocusNode();
  FocusNode adjustmentFocusNode = FocusNode();
  RxList<AutomaticProgramModel> automaticProgramsList = <AutomaticProgramModel>[].obs;
  List<IndividualProgramModel> individualProgramsList = [];
  List<Map<String, dynamic>> individualDropDownPrograms = [];
  RxBool isConfigurationSubmitted = false.obs;
  List<Map<String, dynamic>> secuencias = [];
  final DatabaseHelper dbHelper = DatabaseHelper();
  RxBool isConfigurationSaved = false.obs;


  /// Configuration
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController rampController = TextEditingController();
  final TextEditingController contractionController = TextEditingController();
  final TextEditingController pauseController = TextEditingController();
  List<String> equipmentOptions = [Strings.bioJacket, Strings.bioShape];
  RxString selectedEquipment = Strings.nothing.obs;
  RxString selectedAutoEquipment = Strings.nothing.obs;
  FocusNode pulseFocusNode = FocusNode();
  FocusNode rampFocusNode = FocusNode();
  FocusNode contractionFocusNode = FocusNode();
  FocusNode pauseFocusNode = FocusNode();

  List<Map<String, dynamic>> gruposBioJacket = [];
  List<Map<String, dynamic>> gruposBioShape = [];

  Map<String, TextEditingController> controllersJacket = {};
  Map<String, TextEditingController> controllersShape = {};

  Map<String, bool> selectedJacketGroups = {};
  Map<String, bool> selectedShapeGroups = {};

  Map<String, int> groupJacketIds = {};
  Map<String, int> groupShapeIds = {};


  @override
  Future<void> onInit() async {
    print('onInit called');
    automaticProgramsList.value = await fetchAutoPrograms();
    individualProgramsList = await fetchIndividualPrograms();
    for(var program in individualProgramsList){
      print('IndProgram: ${program.name}');
    }
    fetchCronaxias();
    fetchGruposMusculares();
    super.onInit();
  }

  moveFocusTo(BuildContext context, FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
  }

  unFocus(){
    pulseFocusNode.unfocus();
    rampFocusNode.unfocus();
    contractionFocusNode.unfocus();
    pauseFocusNode.unfocus();
  }

  resetEverything() {
    individualProgramNameController.clear();
    automaticProgramNameController.clear();
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
    totalDuration.value = 0;

    // Reset selection values
    selectedEquipment.value = Strings.nothing;
    selectedAutoEquipment.value = Strings.nothing;
    selectedProgram.value = Strings.nothing;
    selectedProgramName.value = Strings.nothing;
    selectedProgramImage.value = Strings.nothing;
    individualProgramSequenceList.clear();
    secuencias.clear();

    // Reset the checkboxes for active groups
    isUpperBackChecked.value = true;
    isMiddleBackChecked.value = true;
    isLowerBackChecked.value = true;
    isGlutesChecked.value = true;
    isHamstringsChecked.value = true;
    isChestChecked.value = true;
    isAbdominalChecked.value = true;
    isLegsChecked.value = true;
    isArmsChecked.value = true;
    isExtraChecked.value = true;
    isCalvesChecked.value = true;

    // Reset configuration submission status
    isConfigurationSubmitted.value = false;
    isConfigurationSaved.value = false;
  }


  /// Fetching individual programs
  RxBool isFetchIndividualProgramsLoading = false.obs;
  Future<List<IndividualProgramModel>> fetchIndividualPrograms() async {
    isFetchIndividualProgramsLoading.value = true;
    List<IndividualProgramModel> individualPrograms = [];
    final db = await DatabaseHelper().database;

    try {
      // Fetching the raw data from the database
      List<Map<String, dynamic>> individualProgramData = await DatabaseHelper().obtenerProgramasPredeterminadosPorTipoIndividual(db);

      // To hold the programs in the map to group them
      Map<int, IndividualProgramModel> programMap = {};

      // Iterate through the fetched data
      for (var row in individualProgramData) {
        int programId = row['id_programa'];

        individualDropDownPrograms.add({
          'id': row['id_programa'],
          'name': row['nombre'],
        });

        // If the program is not yet in the map, create a new one
        if (!programMap.containsKey(programId)) {
          programMap[programId] = IndividualProgramModel(
            id: row['id_programa'],
            name: row['nombre'],
            image: row['imagen'],
            frequency: row['frecuencia'].toDouble(),
            pulse: row['pulso'] is String ? 0.0 : row['pulso'].toDouble(), // Handling potential string values
            ramp: row['rampa'].toDouble(),
            contraction: row['contraccion'].toDouble(),
            pause: row['pausa'].toDouble(),
            type: row['tipo'],
            equipmentType: row['tipo_equipamiento'],
            cronaxias: [],
            muscleGroups: [],
          );
        }

        // Adding cronaxia if available
        if (row['cronaxia_id'] != null) {
          programMap[programId]!.cronaxias.add(CronaxiaModel(
            id: row['cronaxia_id'],
            name: row['nombre_cronaxia'],
            value: row['valor_cronaxia'],
          ));
        }

        // Adding muscle group if available
        if (row['grupo_muscular_id'] != null) {
          programMap[programId]!.muscleGroups.add(MuscleGroupModel(
            id: row['grupo_muscular_id'],
            name: row['nombre_grupo_muscular'],
          ));
        }
      }

      // Convert the map into a list of programs
      individualPrograms = programMap.values.toList();

      print('Fetched and mapped individual programs');

    } catch (e) {
      print('❌ Error fetching programs: $e');
      return [];
    }

    isFetchIndividualProgramsLoading.value = false;
    return individualPrograms;
  }

  /// Fetching automatic programs from SQL and mapping them to models
  RxBool isFetchAutoProgramsLoading = false.obs;
  Future<List<AutomaticProgramModel>> fetchAutoPrograms() async {
    isFetchAutoProgramsLoading.value = true;
    List<AutomaticProgramModel> autoPrograms = [];
    var db = await DatabaseHelper().database;
    try {
      // Fetching raw data from the database
      List<Map<String, dynamic>> autoProgramData = await
      DatabaseHelper().obtenerProgramasAutomaticosConSubprogramas(db);

      print('All program data fetched $autoProgramData');

      // Now, we need to map this data to AutomaticProgram model
      for (var program in autoProgramData) {
        // Assuming each record in `autoProgramData` has a field 'subprogramas' as a list
        var subprogramsData = program['subprogramas'] as List<dynamic>;

        List<Subprogram> subprograms = subprogramsData.map((subprogram) {
          return Subprogram.fromJson(subprogram);
        }).toList();

        // Creating the AutomaticProgram object from the fetched data
        autoPrograms.add(AutomaticProgramModel(
          automaticProgramId: program['id_programa_automatico'],
          name: program['nombre'],
          image: program['imagen'],
          description: program['descripcion'],
          totalDuration: program['duracionTotal'].toDouble(),
          equipmentType: program['tipo_equipamiento'],
          subprograms: subprograms,
        ));
      }

      print('Program data mapped to models');
    } catch (e) {
      print('❌ Error fetching programs: $e');
    }

    print('AutoProgramFromModel: ${autoPrograms.length}');
    isFetchAutoProgramsLoading.value = false;
    update();
    return autoPrograms;
  }

  Future<void> fetchCronaxias() async {
    try {
      Database db = await DatabaseHelper().database;

      // Obtener grupos musculares para BIO-JACKET
      var gruposJacket = await DatabaseHelper()
          .obtenerCronaxiaPorEquipamiento(db, 'BIO-JACKET');

      // Asignar datos para BIO-JACKET
        gruposBioJacket = gruposJacket;
        // Inicializar controladores para cada grupo muscular de BIO-JACKET
        controllersJacket = {
          for (var row in gruposJacket) row['nombre']: TextEditingController(),
        };


      // Obtener grupos musculares para BIO-SHAPE
      var gruposShape = await DatabaseHelper()
          .obtenerCronaxiaPorEquipamiento(db, 'BIO-SHAPE');

      // Asignar datos para BIO-SHAPE

        gruposBioShape = gruposShape;
        controllersShape = {
          for (var row in gruposShape) row['nombre']: TextEditingController(),
        };

    } catch (e) {
      print('Error al obtener los grupos musculares: $e');
    }
  }

  Future<void> fetchGruposMusculares() async {
    try {
      DatabaseHelper db = DatabaseHelper();

      // Obtener grupos musculares para BIO-JACKET
      var gruposJacket = await db.getGruposMuscularesEquipamiento('BIO-JACKET');

      // Asignar datos para BIO-JACKET

        gruposBioJacket = gruposJacket;
        selectedJacketGroups = {
          for (var row in gruposJacket) row['nombre']: true // Cambiado a true
        };
        // hintJacketColors = {
        //   for (var row in gruposJacket)
        //     row['nombre']: const Color(0xFF2be4f3) // Color de selección
        // };
        groupJacketIds = {
          for (var row in gruposJacket) row['nombre']: row['id']
        };
        // imageJacketPaths = {
        //   for (var row in gruposJacket) row['nombre']: row['imagen']
        // };


      // Obtener grupos musculares para BIO-SHAPE
      var gruposShape = await db.getGruposMuscularesEquipamiento('BIO-SHAPE');


      // Asignar datos para BIO-SHAPE

        gruposBioShape = gruposShape;
        selectedShapeGroups = {
          for (var row in gruposShape) row['nombre']: true // Cambiado a true
        };
        // hintShapeColors = {
        //   for (var row in gruposShape)
        //     row['nombre']: const Color(0xFF2be4f3) // Color de selección
        // };
        // groupShapeIds = {for (var row in gruposShape) row['nombre']: row['id']};
        // imageShapePaths = {
        //   for (var row in gruposShape) row['nombre']: row['imagen']
        // };

    } catch (e) {
      print('Error al obtener los grupos musculares: $e');
    }
  }

  Future<void> actualizarCronaxias(BuildContext context) async {
    try{
    DatabaseHelper dbHelper = DatabaseHelper();

    // Llamar al método de instancia para obtener el programa más reciente
    Map<String, dynamic>? programa =
    await dbHelper.getMostRecentPrograma();

    if (programa != null) {
      int programaId = programa['id_programa'];
      String tipoEquipamiento = programa['tipo_equipamiento'];

      print('El último id_programa es: $programaId');
      print('El tipo de equipamiento es: $tipoEquipamiento');

      // Llamar a la función actualizarCronaxias pasando ambos valores
      print('Cronaxias actualizadas al hacer tap.');

      if(selectedEquipment.value == Strings.bioShape) {
        await DatabaseHelper().updateCronaxia(programaId, 11,
            double.tryParse(lowerBackController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 12,
            double.tryParse(glutesController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 13,
            double.tryParse(hamstringsController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 14,
            double.tryParse(abdomenController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 15,
            double.tryParse(legsController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 16,
            double.tryParse(armsController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 17,
            double.tryParse(extraController.text) ?? 0.0);



      }

      if(selectedEquipment.value == Strings.bioJacket){

        await DatabaseHelper().updateCronaxia(programaId, 1,
            double.tryParse(upperBackController.text) ?? 0.0); /// Done

        await DatabaseHelper().updateCronaxia(programaId, 3, /// Done
            double.tryParse(middleBackController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 2, /// Done
            double.tryParse(lowerBackController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 6, ///
            double.tryParse(chestController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 4, /// Done
            double.tryParse(glutesController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 5,
            double.tryParse(hamstringsController.text) ?? 0.0); /// Done

        await DatabaseHelper().updateCronaxia(programaId, 7,
            double.tryParse(abdomenController.text) ?? 0.0); /// Done

        await DatabaseHelper().updateCronaxia(programaId, 8,
            double.tryParse(legsController.text) ?? 0.0); /// Done

        await DatabaseHelper().updateCronaxia(programaId, 9, /// Done
            double.tryParse(armsController.text) ?? 0.0);

        await DatabaseHelper().updateCronaxia(programaId, 10, /// Done
            double.tryParse(extraController.text) ?? 0.0);



      }

      showSuccessDialog(context);
    } else {
      print(
          'No se encontraron programas en la base de datos');
    }}

    catch(e){
      print(e);
    }
  }

  Future<void> actualizarGruposEnPrograma(BuildContext context) async {
    try {
      // Crear una instancia de DatabaseHelper
      DatabaseHelper dbHelper = DatabaseHelper();

      // Llamar al método de instancia para obtener el programa más reciente
      Map<String, dynamic>? programa = await dbHelper.getMostRecentPrograma();

      if (programa != null) {
        int programaId = programa['id_programa'];
        String tipoEquipamiento = programa['tipo_equipamiento'];

        print('El último id_programa es: $programaId');
        print('El tipo de equipamiento es: $tipoEquipamiento');

        List<int> selectedPrograms = getSelectedActiveGroups();
        // Asegurarnos de que hay elementos en selectedGroupIds antes de actualizar
        if (selectedPrograms.isNotEmpty) {
          // Llamamos a la función para actualizar los grupos musculares en la base de datos
          await dbHelper.actualizarGruposMusculares(
              programaId, selectedPrograms);
        } else {
          print('No se seleccionaron grupos musculares.');
        }
      } else {
        print('No se encontraron programas en la base de datos');
      }
      showSuccessDialog(context, isCloseDialog: true);
      resetEverything();

    }catch(e){
      print(e);
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

      groupedPrograms.add(groupedProgram);
    }

    return groupedPrograms;
  }

  /// Create program - submitting form
  Future<void> createProgramAndSave(BuildContext context, ) async {
    try {
      if (individualProgramNameController.text.isEmpty ||
          selectedEquipment.value == Strings.nothing) {
        // Verificación de '@' en el correo
        alertOverlay(
            context,
            heading: translation(context).alertCompleteForm,
            isOneButtonNeeded: true,
            description: Strings.emptyConfigurationError
        );
        return;
      }

      // Recoger los valores de los controladores de texto
      String nombrePrograma = individualProgramNameController.text;
      String equipamiento = selectedEquipment.value;
      double frecuencia = double.tryParse(frequencyController.text) ?? 0.0;
      double pulso = double.tryParse(pulseController.text) ?? 0.0;
      double contraccion = double.tryParse(contractionController.text) ?? 0.0;
      double pausa = double.tryParse(pauseController.text) ?? 0.0;
      int rampa = int.tryParse(rampController.text) ?? 0;

      // Crear el mapa con los datos del programa
      Map<String, dynamic> programa = {
        'nombre': nombrePrograma,
        'imagen': Strings.selectProgramIcon,
        'frecuencia': frecuencia,
        'pulso': pulso,
        'contraccion': contraccion,
        'rampa': rampa,
        'pausa': pausa,
        'tipo': 'Individual',
        // Puedes actualizar esto según el tipo de programa que quieras
        'tipo_equipamiento': equipamiento,
      };

      // Insertar el programa en la base de datos
      int programaId =
      await DatabaseHelper().insertarProgramaPredeterminado(programa);

      // Insertar las cronaxias y grupos musculares por defecto
      await DatabaseHelper()
          .insertarCronaxiasPorDefecto(programaId, equipamiento);
      await DatabaseHelper()
          .insertarGruposMuscularesPorDefecto(programaId, equipamiento);

      isConfigurationSaved.value = true;
      showSuccessDialog(context);
      unFocus();
      update();
    }
    catch(e){
      print(e);
    }

  }

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
  RxBool isUpperBackChecked = true.obs;
  RxBool isMiddleBackChecked = true.obs;
  RxBool isLowerBackChecked = true.obs; /// Lumbares
  RxBool isGlutesChecked = true.obs;
  RxBool isHamstringsChecked = true.obs; /// isquios
  RxBool isChestChecked = true.obs;
  RxBool isAbdominalChecked = true.obs;
  RxBool isLegsChecked = true.obs;
  RxBool isArmsChecked = true.obs;
  RxBool isExtraChecked = true.obs;
  RxBool isCalvesChecked = true.obs;

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

  void toggleCalves() {
    isCalvesChecked.value = !isCalvesChecked.value;
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

  List<int> checkedPrograms = <int>[];

  List<int> getSelectedActiveGroups() {
    checkedPrograms.clear();

    if(selectedEquipment.value == Strings.bioJacket){
      // Check which programs are checked and add the corresponding program number to the list
      if (isUpperBackChecked.value) checkedPrograms.add( 1); // Upper Back
      if (isMiddleBackChecked.value) checkedPrograms.add(2); // Middle Back
      if (isLowerBackChecked.value) checkedPrograms.add(3); // Lower Back
      if (isGlutesChecked.value) checkedPrograms.add(selectedEquipment.value == Strings.bioJacket ? 4 : 12); // Glutes
      if (isHamstringsChecked.value) checkedPrograms.add(selectedEquipment.value == Strings.bioJacket ? 5 : 13); // Hamstrings
      if (isChestChecked.value) checkedPrograms.add(6); // Chest
      if (isAbdominalChecked.value) checkedPrograms.add(selectedEquipment.value == Strings.bioJacket ? 7 : 14); // Abdominal
      if (isLegsChecked.value) checkedPrograms.add(selectedEquipment.value == Strings.bioJacket ? 8 : 15); // Legs
      if (isArmsChecked.value) checkedPrograms.add(selectedEquipment.value == Strings.bioJacket ? 9 : 16); // Arms
      if (isExtraChecked.value) checkedPrograms.add(10); // Extra
    }
    else if(selectedEquipment.value == Strings.bioShape){
      if (isGlutesChecked.value) checkedPrograms.add(12); // Glutes
      if (isHamstringsChecked.value) checkedPrograms.add(13); // Hamstrings
      if (isAbdominalChecked.value) checkedPrograms.add(14); // Abdominal
      if (isLegsChecked.value) checkedPrograms.add(15); // Legs
      if (isArmsChecked.value) checkedPrograms.add(16); // Arms
      if (isCalvesChecked.value) checkedPrograms.add(17); // Extra
    }

    return checkedPrograms;
  }

  /// Automatic program tab
  RxList<dynamic> individualProgramSequenceList = [].obs;

  removeProgram(int index){
    individualProgramSequenceList.removeAt(index);
    update();
  }

  Future<void> crearProgramaAutomatico(BuildContext context) async {
    if (automaticProgramNameController.text.isEmpty ||
        // durationController.text.isEmpty ||
        selectedAutoEquipment.value == Strings.nothing ||
        secuencias.isEmpty) {
      // Verificación de '@' en el correo
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Por favor, introduzca todos los campos y secuencias'
      );
      return; // Esto previene la ejecución del código posterior
    }

    // Datos del programa automático
    Map<String, dynamic> programaAuto = {
      'nombre': automaticProgramNameController.text,
      'imagen': Strings.selectProgramIcon,
      'descripcion': '',
      'duracionTotal': totalDuration.value,
      'tipo_equipamiento': selectedAutoEquipment.value == Strings.nothing ? Strings.bioJacket : Strings.bioShape,
    };

    // Mostrar los datos del programa antes de insertar
    print("Datos del programa automático:");
    print(programaAuto);

    // Insertar el programa automático y obtener su ID
    int programaId = await dbHelper.insertarProgramaAutomatico(programaAuto);

    // Verificar si se insertó correctamente el programa
    if (programaId > 0) {
      print("Programa insertado con éxito, ID: $programaId");

      List<Map<String, dynamic>> subprogramas = secuencias.map((sec) {
        // Obtener el ID del programa seleccionado desde el dropdown
        int? idProgramaSeleccionado = sec['id_programa']; // Asumiendo que en sec tienes el id del programa

        var subprograma = {
          'id_programa_automatico': programaId,
          'id_programa_relacionado': idProgramaSeleccionado,
          'orden': int.tryParse(sec['orden'].toString()) ?? 0,
          'ajuste': double.tryParse(sec['ajuste'].toString()) ?? 0.0,
          'duracion': double.tryParse(sec['duracion'].toString()) ?? 0.0,
        };

        print("Subprograma creado: $subprograma"); // Mostrar cada subprograma creado
        return subprograma;
      }).toList();

// Sorting the list by 'orden' in ascending order
      subprogramas.sort((a, b) => a['orden'].compareTo(b['orden']));

      print(subprogramas); // Display the sorted list


      // Verificar el contenido de la lista de subprogramas
      print("Lista de subprogramas:");
      print(subprogramas);

      bool success =
      await dbHelper.insertAutomaticProgram(programaId, subprogramas);

      // Notificar al usuario sobre el resultado
      if (success) {
          showSuccessDialog(context, isCloseDialog: true);
          disposeController();
          // resetEverything();
          print("Subprogramas insertados con éxito.");
        } else {
          print("Error al insertar los subprogramas.");
        }

    } else {
      print("Error al insertar el programa automático.");
    }
  }

  /// Create sequence
  final TextEditingController orderController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  RxInt totalDuration = 0.obs;
  final TextEditingController adjustmentController = TextEditingController();
  RxString selectedProgram = Strings.nothing.obs;

  // List<Map<String, dynamic>> allPrograms = [];
  // Future<void> _fetchAllPrograms() async {
  //   var db = await DatabaseHelper()
  //       .database; // Obtener la instancia de la base de datos
  //   try {
  //     // Llamamos a la función que obtiene los programas de la base de datos filtrados por tipo 'Individual'
  //     final programData = await DatabaseHelper().getAllPrograms();
  //
  //     // Verifica el contenido de los datos obtenidos
  //     print('Programas obtenidos: $programData');
  //
  //     // Actualizamos el estado con los programas obtenidos
  //       allPrograms = programData; // Asignamos los programas obtenidos a la lista
  //   } catch (e) {
  //     print('Error fetching programs: $e');
  //   }
  // }


  unFocusSequenceFields(){
    orderFocusNode.unfocus();
    adjustmentFocusNode.unfocus();
    durationFocusNode.unfocus();
    autoProgramFocusNode.unfocus();
  }

  clearSequenceTextFields(){
    autoProgramFocusNode.unfocus();
    orderController.clear();
    durationController.clear();
    adjustmentController.clear();
    selectedProgram.value = Strings.nothing;
  }

  createSequence(BuildContext context) {
    if (orderController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        adjustmentController.text.isNotEmpty &&
        selectedProgram.value != Strings.nothing) {

      // Add the new program sequence to the list
      individualProgramSequenceList.add(
        ProgramDetails(
          name: selectedProgram.value,
          order: int.parse(orderController.text),
          duration: int.parse(durationController.text),
          adjustment: int.parse(adjustmentController.text),
        ),
      );

      // Sort individualProgramSequenceList by 'order' in ascending order


      // Add the new sequence to secuencias
      var program = individualDropDownPrograms.firstWhere(
              (element) => element['name'] == selectedProgram.value,
          orElse: () => {} // Return an empty map if no match is found
      );

      secuencias.add({
        'programa': selectedProgram.value,
        'id_programa': program['id'],
        'orden': orderController.text,
        'duracion': durationController.text,
        'ajuste': adjustmentController.text,
      });
      totalDuration.value = totalDuration.value + int.parse(durationController.text);

      individualProgramSequenceList.sort((a, b) {
        return a.order.compareTo(b.order);
      });

      unFocusSequenceFields();
      Navigator.pop(context);
    } else {
      alertOverlay(
        context,
        heading: translation(context).alertCompleteForm,
        isOneButtonNeeded: true,
        description: Strings.emptySequenceError,
      );
    }
  }


  // createSequence(BuildContext context) {
  //   if (orderController.text.isNotEmpty &&
  //       durationController.text.isNotEmpty &&
  //       adjustmentController.text.isNotEmpty &&
  //       selectedProgram.value != Strings.nothing) {
  //
  //     individualProgramSequenceList.add(
  //       ProgramDetails(
  //         name: selectedProgram.value,
  //         order: int.parse(orderController.text),
  //         duration: int.parse(durationController.text),
  //         adjustment: int.parse(adjustmentController.text),
  //       ),
  //     );
  //     var program = individualDropDownPrograms.firstWhere(
  //             (element) => element['name'] == selectedProgram.value,
  //         orElse: () => {} // Return an empty map if no match is found
  //     );
  //
  //     secuencias.add({
  //       'programa': selectedProgram.value,
  //       'id_programa': program['id'],
  //       'orden': orderController.text,
  //       'duracion': durationController.text,
  //       'ajuste': adjustmentController.text,
  //     });
  //     secuencias.sort((a, b) {
  //       return int.parse(a['orden']).compareTo(int.parse(b['orden']));
  //     });
  //     print('secuencias: $secuencias');
  //     Navigator.pop(context);
  //   }
  //   else{
  //     alertOverlay(
  //       context,
  //       heading: translation(context).alertCompleteForm,
  //       isOneButtonNeeded: true,
  //       description: Strings.emptySequenceError,
  //     );
  //   }
  // }

  // void createSequence(BuildContext context) {
  //   if (orderController.text.isNotEmpty &&
  //       durationController.text.isNotEmpty &&
  //       adjustmentController.text.isNotEmpty &&
  //       selectedProgram.value != Strings.nothing) {
  //
  //     // Add the new sequence to the list
  //     secuencias.add({
  //       'programa': selectedProgram.value,
  //       'id_programa': 'some_id', // Your ID logic here
  //       'orden': orderController.text,
  //       'duracion': durationController.text,
  //       'ajuste': adjustmentController.text,
  //     });
  //
  //     // Sort the secuencias by 'orden' in ascending order
  //     secuencias.sort((a, b) {
  //       return int.parse(a['orden']).compareTo(int.parse(b['orden']));
  //     });
  //
  //     // Clear the text fields after adding the sequence
  //     orderController.clear();
  //     durationController.clear();
  //     adjustmentController.clear();
  //   }
  //   else{
  //     alertOverlay(
  //       context,
  //       heading: translation(context).alertCompleteForm,
  //       isOneButtonNeeded: true,
  //       description: Strings.emptySequenceError,
  //     );
  //   }
  // }

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

  disposeController(){
    Get.delete<ProgramsController>();
  }

  @override
  void onClose() {
    print('Programs controller onClose');
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

