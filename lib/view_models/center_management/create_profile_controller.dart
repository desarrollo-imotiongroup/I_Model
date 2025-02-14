import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/views/dialogs/sucess_dialog.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:intl/intl.dart';

class CreateProfileController extends GetxController{
  /// Create profile - Crear nuevo
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController registrationDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  RxString selectedProfile = Strings.nothing.obs;
  RxString selectedSessionControl = Strings.nothing.obs;
  RxString selectedTimeControl = Strings.nothing.obs;
  RxString selectedGender = Strings.nothing.obs;
  RxString selectedStatus = Strings.nothing.obs;
  List<String> sessionControlOptions = [Strings.yes, Strings.no];
  List<String> statusOptions = [Strings.active, Strings.inactive];
  List<String> genderOptions = [Strings.man, Strings.women];
  List<String> profileOptions = [Strings.administrator, Strings.beautician];
  List<String> timeControlOptions = [Strings.yes, Strings.no];
  int? userId;



  createProfilePickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      birthDateController.text = birthDate;
    }
    update();
  }

  createProfilePickRegistrationDate(BuildContext context) async {
    String? registrationDate = await HelperMethods.selectDate(context);
    if(registrationDate != null) {
      registrationDateController.text = registrationDate;
    }
    update();
  }

  /// Cards / bonos
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


  /// Available points list
  RxList<ClientPoints> consumedPoints = <ClientPoints>[].obs;

  /// Create Profile - Personal data - SQL
  void collectUserData(BuildContext context) async {
    // Verificar que los campos no estén vacíos
    if (nameController.text.isEmpty ||
        // _emailController.text.isEmpty ||
        nickNameController.text.isEmpty || /// user name
        phoneController.text.isEmpty ||
        selectedGender.value == Strings.nothing ||
        selectedStatus.value == Strings.nothing ||
        selectedTimeControl.value == Strings.nothing ||
        selectedSessionControl.value == Strings.nothing ||
        selectedProfile.value == Strings.nothing ||
        registrationDateController.text.isEmpty ||
        birthDateController.text.isEmpty
        // || !_emailController.text.contains('@'
        ) {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Por favor, complete todos los campos correctamente'
      );
      return;
    }

    // Convertir la primera letra del nombre a mayúscula
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    // Datos del usuario
    final clientData = {
      'name': name, // Nombre con la primera letra en mayúscula
      'email': '',
      'phone': phoneController.text,
      'pwd': '0000',
      'user': nickNameController.text,
      'gender': selectedGender.value,
      'altadate': registrationDateController.text,
      'controlsesiones': selectedSessionControl.value,
      'controltiempo': selectedTimeControl.value,
      'status': selectedStatus.value,
      'birthdate': birthDateController.text,
    };

    DatabaseHelper dbHelper = DatabaseHelper();

    // Insertar usuario en la tabla `usuarios`
    int userId = await dbHelper.insertUser(clientData);

    // Insertar tipo de perfil en la tabla `tipos_perfil` si aún no existe
    int? perfilId = await dbHelper.getTipoPerfilId(selectedProfile.value);

    perfilId ??= await dbHelper.insertTipoPerfil(selectedProfile.value);

    // Imprimir el tipo de perfil que se ha insertado
    print('Tipo de perfil insertado: ${selectedProfile.value}');
    print('perfilId $perfilId');

    // Insertar la relación en la tabla `usuario_perfil`
    await dbHelper.insertUsuarioPerfil(userId, perfilId);

    print('Datos del cliente insertados: $clientData');

    showSuccessDialog(context, title: 'Usuario añadido correctamente');

  }

  /// Bonos
  int? lastUserId;
  RxList<Map<String, String>> availableBonos = <Map<String, String>>[].obs; // Cambiar el tipo aquí
  List<Map<String, String>> consumedBonos = [];
  RxInt totalBonosAvailables = 0.obs; // Total de bonos disponibles
  Map<String, dynamic>? selectedUser;

  Future<void> loadMostRecentUser() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getMostRecentUser();

    if (user != null) {
        selectedUser = user;
        lastUserId = user['id'];
        print('LAST user id: $lastUserId');
        // _indexController.text = lastUserId.toString();
        // nameController.text = user['name'] ?? '';
        // selectedStatus.value = user['status'];


      if (lastUserId != null) {
        loadAvailableBonos(lastUserId!);
      }
    }
  }

  Future<void> loadAvailableBonos(int userId) async {
    final dbHelper = DatabaseHelper();
    final bonosUser = await dbHelper.getAvailableBonosByUserId(userId);

    if (bonosUser.isEmpty) {
      print('No se encontraron bonos disponibles para el cliente $userId');
    }


      availableBonos.value = bonosUser.where((bonoUser) {
        return bonoUser['estado'] == 'Disponible';
      }).map((bonoUser) {
        return {
          'date': bonoUser['fecha']?.toString() ?? '',
          // Aseguramos que 'fecha' sea String
          'quantity': bonoUser['cantidad']?.toString() ?? '',
          // Aseguramos que 'cantidad' sea String
        };
      }).toList();

    // Recalcular el total de bonos
    totalBonosAvailables.value = calculateTotalBonos(availableBonos);
  }

  int calculateTotalBonos(List<Map<String, dynamic>> bonos) {
    return bonos.fold(0, (sum, bono) {
      return sum +
          (int.tryParse(bono['quantity']) ??
              0); // Garantizar que la cantidad sea int
    });
  }

  Future<void> saveBonosUser(int userId, int cantidadBonos) async {
    final dbHelper = DatabaseHelper();
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    await dbHelper.insertBonoUsuario({
      'usuario_id': userId,
      'cantidad': cantidadBonos,
      'estado': 'Disponible',
      'fecha': formattedDate,
    });

    loadAvailableBonos(userId);
  }

  @override
  void onClose() {
    nameController.dispose();
    nickNameController.dispose();
    birthDateController.dispose();
    registrationDateController.dispose();
    super.onClose();
  }
}