import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/client/bioimedancia.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/models/client/client_activity.dart';
import 'package:i_model/models/client/clients.dart';
import 'package:i_model/views/dialogs/sucess_dialog.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ClientController extends GetxController {
  List<String> clientStatusList = [Strings.active, Strings.inactive, Strings.all];
  List<String> genderList = [Strings.man, Strings.women];
  // RxString selectedClient = ''.obs;
  RxMap selectedClient = {}.obs;
  RxString selectedClientName = Strings.nothing.obs;
  RxBool isShowTabs = false.obs;

  /// Client screen values
  final TextEditingController nameController = TextEditingController();
  RxString selectedStatus = Strings.all.obs;
  var isDropdownOpen = false.obs;
  RxList<Map<String, dynamic>> allClients = <Map<String, dynamic>>[].obs; // Lista original de clientes
  RxList<Map<String, dynamic>> filteredClients = <Map<String, dynamic>>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();


  @override
  Future<void> onInit() async {
  _fetchClients();
    super.onInit();
  }

  /// Client Personal data values
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientDobController = TextEditingController();
  final TextEditingController clientPhoneController = TextEditingController();
  final TextEditingController clientHeightController = TextEditingController();
  final TextEditingController clientWeightController = TextEditingController();
  final TextEditingController clientEmailController = TextEditingController();
  FocusNode weightFocusNode = FocusNode();
  FocusNode heightFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  RxString clientSelectedGender = Strings.nothing.obs;
  List<String> statusList = [Strings.active, Strings.inactive];
  RxString fetchedStatus = Strings.active.obs;

  resetEverything(){
    isUpperBackChecked.value = false;
    isMiddleBackChecked.value = false;
    isLowerBackChecked.value = false;
    isGlutesChecked.value = false;
    isHamstringsChecked.value = false;
    isChestChecked.value = false;
    isAbdominalChecked.value = false;
    isLegsChecked.value = false;
    isArmsChecked.value = false;
    isExtraChecked.value = false;
    selectedStatus.value = Strings.all;
  }

  @override
  void onClose() {
    nameController.dispose();
    clientNameController.dispose();
    clientDobController.dispose();
    clientPhoneController.dispose();
    clientHeightController.dispose();
    clientWeightController.dispose();
    clientEmailController.dispose();
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  unFocus(){
    weightFocusNode.unfocus();
    heightFocusNode.unfocus();
    emailFocusNode.unfocus();
    weightFocusNode.unfocus();
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
  // RxList<dynamic> availablePoints = [].obs;
  RxInt totalAvailablePoints = 0.obs;

  // buyPoints(){
  //   availablePoints.add(ClientPoints(date: '01/02/25', quantity: int.parse(pointsTextEditingController.text)));
  //   totalAvailablePoints = totalAvailablePoints + int.parse(pointsTextEditingController.text);
  //   pointsTextEditingController.clear();
  //   update();
  // }

  /// Consumed points list
  RxList<ClientPoints> consumedPoints = <ClientPoints>[].obs;

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

  // RxList<Bioimedancia> bioimpedanciaGraphData = [
  //   Bioimedancia(name: Strings.fatFreeHydration, calculatedValue: '324525', reference: '324525', result: '324525'),
  //   Bioimedancia(name: Strings.waterBalance, calculatedValue: '324525', reference: '324525', result: '324525'),
  //   Bioimedancia(name: Strings.imc, calculatedValue: '324525', reference: '324525', result: '324525'),
  //   Bioimedancia(name: Strings.bodyFat, calculatedValue: '324525', reference: '324525', result: '324525'),
  //   Bioimedancia(name: Strings.muscle, calculatedValue: '324525', reference: '324525', result: '324525'),
  //   Bioimedancia(name: Strings.skeleton, calculatedValue: '324525', reference: '324525', result: '324525'),
  // ].obs;

  RxList<Bioimedancia> getbioimpedanciaGraphData(BuildContext context){
    return [
      Bioimedancia(name: translation(context).fatFreeHydration, calculatedValue: '324525', reference: '324525', result: '324525'),
      Bioimedancia(name: translation(context).waterBalance, calculatedValue: '324525', reference: '324525', result: '324525'),
      Bioimedancia(name: translation(context).imc, calculatedValue: '324525', reference: '324525', result: '324525'),
      Bioimedancia(name: translation(context).bodyFat, calculatedValue: '324525', reference: '324525', result: '324525'),
      Bioimedancia(name: translation(context).muscle, calculatedValue: '324525', reference: '324525', result: '324525'),
      Bioimedancia(name: translation(context).skeleton, calculatedValue: '324525', reference: '324525', result: '324525'),
    ].obs;
  }

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


  List<int> checkedPrograms = <int>[];

  List<int> getSelectedActiveGroups() {
    checkedPrograms.clear();

    /// Check which programs are checked and add the corresponding program number to the list
    if (isUpperBackChecked.value) checkedPrograms.add(2); // Upper Back
    if (isMiddleBackChecked.value) checkedPrograms.add(3); // Middle Back
    if (isLowerBackChecked.value) checkedPrograms.add(6); // Lower Back
    if (isGlutesChecked.value) checkedPrograms.add(4); // Glutes
    if (isHamstringsChecked.value) checkedPrograms.add(5); // Hamstrings
    if (isChestChecked.value) checkedPrograms.add(1); // Chest
    if (isAbdominalChecked.value) checkedPrograms.add(7 ); // Abdominal
    if (isLegsChecked.value) checkedPrograms.add(8); // Legs
    if (isArmsChecked.value) checkedPrograms.add(9); // Arms
    if (isExtraChecked.value) checkedPrograms.add(10); // Extra

    return checkedPrograms;
  }


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

  /// Client List - Fetch clients from SQL
  Future<void> _fetchClients() async {
    final dbHelper = DatabaseHelper();

    try {
      // Obtener el userId desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        // Manejar el caso de usuario no autenticado
        // HelperMethods.showSnackBar(context, title: 'Error: Usuario no autenticado');
        print('No users found / Usuario no autenticado');
      }

      // Obtener clientes: si userId es 1, mostrar todos; si no, filtrar por userId
      List<Map<String, dynamic>> clientData;
      if (userId == 1) {
        // Obtener todos los clientes sin filtrar
        clientData = await dbHelper.getClients();
      } else {
        // Obtener clientes asociados al usuario
        clientData = await dbHelper.getClientsByUserId(userId!);
      }


        allClients.value = clientData; // Asigna a la lista original
        filteredClients.value = allClients; // Inicializa la lista filtrada

      print('AllClients: $allClients');

      filterClients(); // Aplica cualquier filtrado adicional
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  void filterClients() {
      String searchText = nameController.text.toLowerCase();

      filteredClients.value = allClients.where((client) {
        final matchesName = client['name']!.toLowerCase().contains(searchText);


        // Filtra por estado basado en la selección del dropdown
        final matchesStatus =
            selectedStatus.value == Strings.all || client['status'] == selectedStatus.value;

        return matchesName && matchesStatus;
      }).toList();

      for(int i=0; i<filteredClients.length ; i++){
        print('Filter: ${filteredClients[i]}');
      }
      update();
  }

  /// Client File
  /// Get data
  Future<void> refreshControllers() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Fetch the updated client data from the database
    Map<String, dynamic>? updatedClientData = await dbHelper
        .getClientById(selectedClient['id']!); // Create this method in your DatabaseHelper

    if (updatedClientData != null) {
        clientNameController.text = updatedClientData['name'] ?? '';
        clientHeightController.text = updatedClientData['height'].toString() ?? '';
        clientEmailController.text = updatedClientData['email'] ?? '';
        clientPhoneController.text = updatedClientData['phone'].toString() ?? '';
        clientWeightController.text = updatedClientData['weight']?.toString() ?? '';
        clientSelectedGender.value = updatedClientData['gender'];
        fetchedStatus.value = updatedClientData['status'];
        clientDobController.text = updatedClientData['birthdate'];
        print('fetchedStatus: $fetchedStatus');
    }
  }

  /// -- Update data in datos personales
  void updateData(BuildContext context) async {
    // Ensure all required fields are filled
    if (clientNameController.text.isEmpty ||
        clientEmailController.text.isEmpty ||
        clientPhoneController.text.isEmpty ||
        clientHeightController.text.isEmpty ||
        clientWeightController.text.isEmpty ||
        clientDobController.text.isEmpty ||
        clientSelectedGender.value == Strings.nothing ||
        selectedClient['id'] == null ||
        !clientEmailController.text.contains('@')) {
      // Show error Snackbar
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Por favor, complete todos los campos correctamente'
      );
      return; // Exit method if there are empty fields
    }

    // Obtener el userId desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Error: Usuario no autenticado'
      );
      return;
    }

    // Convertir la primera letra del nombre a mayúscula
    String name = clientNameController.text.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    final clientData = {
      'usuario_id': userId, // Asociar el cliente con el usuario
      'name': name,
      'email': clientEmailController.text,
      'phone': int.tryParse(clientPhoneController.text),
      'height': int.tryParse(clientHeightController.text), // Convert to int
      'weight': int.tryParse(clientWeightController.text), // Convert to int
      'gender': clientSelectedGender.value,
      'status': fetchedStatus.value,
      'birthdate': clientDobController.text,
    };

    // Update in the database
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.updateClient(selectedClient['id'], clientData); // Pass the ID and client data

    // Print updated data
    print('Datos del cliente actualizados: $clientData');

    // Refresh the text controllers with the updated data
    // await _refreshControllers();

    unFocus();
    showSuccessDialog(context, title: 'Cliente actualizado correctamente');
  }

  /// Delete client
  deleteClient(BuildContext context) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteClient(selectedClient['id']); // Borrar cliente
    showSuccessDialog(context, title: 'Cliente borrado correctamente');
    resetEverything();
  }

  RxList<Map<String, String>> availableBonos = <Map<String, String>>[].obs; // Cambiar el tipo aquí
  int totalBonosAvailables = 0; // To

  Future<void> loadAvailableBonos() async {
    final dbHelper = DatabaseHelper();

    final bonos = await dbHelper.getAvailableBonosByClientId(selectedClient['id']);

    if (bonos.isEmpty) {
      print('No se encontraron bonos disponibles para el cliente ${selectedClient['id']}');
    }


      availableBonos.value = bonos.where((bono) {
        return bono['estado'] == 'Disponible';
      }).map((bono) {
        return {
          'date': bono['fecha']?.toString() ?? '',
          // Aseguramos que 'fecha' sea String
          'quantity': bono['cantidad']?.toString() ?? '',
          // Aseguramos que 'cantidad' sea String
        };
      }).toList();

    print('Client id from Ficha Client: ${selectedClient['id']}');

    // Recalcular el total de bonos
    totalBonosAvailables = _calculateTotalBonos(availableBonos);
  }

  int _calculateTotalBonos(List<Map<String, dynamic>> bonos) {
    return bonos.fold(0, (sum, bono) {
      return sum +
          (int.tryParse(bono['quantity']) ??
              0); // Garantizar que la cantidad sea int
    });
  }

  Future<void> saveBonos(int cantidadBonos) async {
    final dbHelper = DatabaseHelper();
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    await dbHelper.insertBono({
      'cliente_id': selectedClient['id'],
      'cantidad': cantidadBonos,
      'estado': 'Disponible',
      'fecha': formattedDate,
    });

    loadAvailableBonos();
  }

  /// Active groups
  Future<void> loadMuscleGroups() async {
    final db = await openDatabase('my_database.db');

    // 1. Obtener todos los grupos musculares disponibles
    final List<Map<String, dynamic>> result =
    await db.query('grupos_musculares');

    // 2. Obtener los grupos musculares asociados a este cliente
    final List<Map<String, dynamic>> clientGroupsResult = await db.rawQuery('''
    SELECT g.id, g.nombre
    FROM grupos_musculares g
    INNER JOIN clientes_grupos_musculares cg ON g.id = cg.grupo_muscular_id
    WHERE cg.cliente_id = ?
  ''', [selectedClient['id']]);

    // Actualizar el estado de los grupos y sus colores

      // selectedGroups = {for (var row in result) row['nombre']: false};
      // // hintColors = {for (var row in result) row['nombre']: Colors.white};
      // groupIds = {for (var row in result) row['nombre']: row['id']};
      // imagePaths = {for (var row in result) row['nombre']: row['imagen']};

      // Marcar los grupos asociados al cliente como seleccionados
      // for (var group in clientGroupsResult) {
      //   final groupName = group['nombre'];
      //   if (groupName != null) {
      //     selectedGroups[groupName] = true;
      //     hintColors[groupName] =
      //     const Color(0xFF2be4f3); // Color para los grupos seleccionados
      //   }
      // }


    // Imprimir los grupos asociados al cliente (clientGroupsResult)
    print("Grupos musculares asociados al cliente ${selectedClient['id']}:");
    clientGroupsResult.forEach((group) {
      switch (group['id']) {
        case 1:
          isChestChecked.value = true; // Chest
          break;
        case 2:
          isUpperBackChecked.value = true; // Upper Back
          break;
        case 3:
          isMiddleBackChecked.value = true; // Middle Back
          break;
        case 4:
          isGlutesChecked.value = true; // Glutes
          break;
        case 5:
          isHamstringsChecked.value = true; // Hamstrings
          break;
        case 6:
          isLowerBackChecked.value = true; // Lower Back
          break;
        case 7:
          isAbdominalChecked.value = true; // Abdominal
          break;
        case 8:
          isLegsChecked.value = true; // Legs
          break;
        case 9:
          isArmsChecked.value = true; // Arms
          break;
        case 10:
          isExtraChecked.value = true; // Extra
          break;
        default:
        // Handle cases for unknown IDs if needed
          break;
      }

      print("- ${group['nombre']} (ID: ${group['id']})");
    });
  }

  // Función para actualizar los grupos musculares del cliente
  Future<void> updateClientGroups(BuildContext context) async {
    List<int> selectedGroupIds = getSelectedActiveGroups(); // Obtener los IDs de los grupos seleccionados

    // Llamar al método en DatabaseHelper para actualizar la relación en la tabla
    await dbHelper.updateClientGroups(selectedClient['id'], selectedGroupIds);

    // Imprimir los grupos actualizados
    print("Grupos musculares actualizados para el cliente ${selectedClient['id']}:");
    selectedGroupIds.forEach((groupId) {
     print(groupId);
    });
    showSuccessDialog(context, title: 'Grupos actualizados correctamente');

  }

}
