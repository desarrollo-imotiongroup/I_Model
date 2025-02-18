import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/views/dialogs/sucess_dialog.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class CreateNewClientController extends GetxController {
  List<String> clientStatusList = [Strings.active, Strings.inactive];
  List<String> genderList = [Strings.man, Strings.women];
  RxString selectedStatus = Strings.active.obs;
  RxInt recentClientId = 0.obs;
  RxBool isDataSaved = false.obs;


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
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<void> onInit() async {
    if (clientId != null) {
      _loadAvailableBonos();
    }
    loadMuscleGroups();
    super.onInit();
  }

  moveFocusTo(BuildContext context, FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
  }

  unFocus(){
    weightFocusNode.unfocus();
    heightFocusNode.unfocus();
    emailFocusNode.unfocus();
    weightFocusNode.unfocus();
  }


  resetEverything() {
    // Resetting personal data fields
    clientNameController.clear();
    clientDobController.clear();
    clientPhoneController.clear();
    clientHeightController.clear();
    clientWeightController.clear();
    clientEmailController.clear();
    clientSelectedGender.value = Strings.nothing;
    selectedStatus.value = Strings.active;

    // Resetting checkboxes for muscle groups
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

    // Resetting selected groups
    checkedPrograms.clear();

    // Resetting other reactive variables
    recentClientId.value = 0;
    isDataSaved.value = false;

    // Resetting client bonos/points
    consumedPoints.clear();
    availableBonos.clear();
    totalBonosAvailables = 0;

    // Resetting groupIds and other database-related values
    groupIds.clear();
  }


  pickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      clientDobController.text = birthDate;
    }
    update();
  }


  /// Client bonos/points
  /// Available points list
  final TextEditingController pointsTextEditingController = TextEditingController();
  // RxList<dynamic> availablePoints = [].obs;
  // RxInt totalAvailablePoints = 0.obs;
  //
  // buyPoints(){
  //   availablePoints.add(ClientPoints(date: '01/02/25', quantity: int.parse(pointsTextEditingController.text)));
  //   totalAvailablePoints = totalAvailablePoints + int.parse(pointsTextEditingController.text);
  //   pointsTextEditingController.clear();
  //   update();
  // }

  /// Consumed points list
  RxList<ClientPoints> consumedPoints = <ClientPoints>[].obs;


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

  /// Create new client - personal data
  void collectData(BuildContext context) async {
    // Verificar que los campos no estén vacíos
    if (clientNameController.text.isEmpty ||
        clientEmailController.text.isEmpty ||
        clientPhoneController.text.isEmpty ||
        clientHeightController.text.isEmpty ||
        clientWeightController.text.isEmpty ||
        clientDobController.text.isEmpty ||
        clientSelectedGender.value == Strings.nothing ||
        !clientEmailController.text.contains('@')) {
      // Verificación de '@' en el correo
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Por favor, complete todos los campos correctamente'
      );
      return;
    }

    // Obtener el userId desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      HelperMethods.showSnackBar(context, title: 'Error: Usuario no autenticado');
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
      'phone': clientPhoneController.text,
      'height': int.parse(clientHeightController.text),
      'weight': int.parse(clientWeightController.text),
      'gender': clientSelectedGender.value,
      'status': selectedStatus.value,
      'birthdate': clientDobController.text,
    };
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertClient(clientData);

      print('Datos del cliente insertados: $clientData');
      // isConfigurationSaved.value = true;
      showSuccessDialog(context, title: 'Cliente añadido correctamente');

      unFocus();
      isDataSaved.value = true;
      print('HERE');
      // print( isConfigurationSaved.value);
    }catch(e){
      print(e);
    }
  }

  /// Create new client - Bonos
  Map<String, dynamic>? selectedClient;
  String? selectedOption;
  int? clientId;
  int? lastClientId;
  final _indexController = TextEditingController();

  Future<void> loadMostRecentClient() async {
    final dbHelper = DatabaseHelper();
    final client = await dbHelper.getMostRecentClient();
    print('clientTTTT: $client');
    if (client != null) {

        selectedClient = client;
        lastClientId = client['id'];
        _indexController.text = lastClientId.toString();
        // clientNameController.text = client['name'] ?? '';
        selectedOption = client['status'];


      if (lastClientId != null) {
        _loadAvailableBonos();
      }

      recentClientId.value = selectedClient!['id'];
    }
  }

  RxList<Map<String, String>> availableBonos = <Map<String, String>>[].obs; // Cambiar el tipo aquí
  int totalBonosAvailables = 0; // Total de bon

  Future<void> _loadAvailableBonos() async {
    final dbHelper = DatabaseHelper();
    final bonos = await dbHelper.getAvailableBonosByClientId(recentClientId.value);

    if (bonos.isEmpty) {
      print('No se encontraron bonos disponibles para el cliente ${recentClientId.value}');
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

    print('Client id from Create Client: ${recentClientId.value}');
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

  Future<void> saveBonos(int clienteId, int cantidadBonos) async {
    final dbHelper = DatabaseHelper();
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    await dbHelper.insertBono({
      'cliente_id': clienteId,
      'cantidad': cantidadBonos,
      'estado': 'Disponible',
      'fecha': formattedDate,
    });

    print('ClientID: ${clienteId}');
    _loadAvailableBonos();
  }

  /// Grupos Activos from SQL
  Map<String, int> groupIds = {};
  // Método para obtener los grupos musculares desde la base de datos

  Future<void> loadMuscleGroups() async {
    final db = await openDatabase(
        'my_database.db'); // Asegúrate de tener la ruta correcta de la base de datos
    final List<Map<String, dynamic>> result =
    await db.query('grupos_musculares');

    // Inicializar selectedGroups y hintColors con los grupos musculares obtenidos

      // selectedGroups = {for (var row in result) row['nombre']: true};
      // hintColors = {
      //   for (var row in result) row['nombre']: const Color(0xFF2be4f3)
      // };
      groupIds = {for (var row in result) row['nombre']: row['id']};
      print('groupIds: $groupIds');
      // imagePaths = {for (var row in result) row['nombre']: row['imagen']};
  }

  /// YAAD
// Función para insertar la relación entre cliente y grupos musculares
  Future<void> insertClientGroups({required BuildContext context}) async {
    // Variable para acumular el éxito de las inserciones
    bool allSuccess = true;

    // Imprimir los datos antes de intentar insertar las relaciones

    List<int> selectedGroup  = getSelectedActiveGroups();
    for (int grupoMuscularId in selectedGroup){
      bool success =
      await dbHelper.insertClientGroup(recentClientId.value, grupoMuscularId);

      if (!success) {
        allSuccess = false; // Si alguna inserción falla, cambiamos el estado
        break; // Salimos del bucle si alguna inserción falla
      }
      print(
          "Intentando insertar relaciones: Cliente ID: ${recentClientId.value}, Grupos Musculares IDs: $grupoMuscularId");
    }

    if (allSuccess) {
      showSuccessDialog(context, title: 'Grupos Musculares añadidos correctamente', isCloseDialog: true);
      resetEverything();

    } else {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'No se han podido añadir todos los grupos'
      );
    }
  }

  disposeController(){
    Get.delete<CreateNewClientController>();
  }

  @override
  void onClose() {
    print('Client New Client onClose');

    // Dispose of all TextEditingControllers to release resources
    clientNameController.dispose();
    clientDobController.dispose();
    clientPhoneController.dispose();
    clientHeightController.dispose();
    clientWeightController.dispose();
    clientEmailController.dispose();
    pointsTextEditingController.dispose(); // Dispose of pointsTextEditingController if used

    // Dispose of FocusNodes (if applicable)
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    emailFocusNode.dispose();

    super.onClose();  // Always call super.onClose() for proper cleanup
  }
}
