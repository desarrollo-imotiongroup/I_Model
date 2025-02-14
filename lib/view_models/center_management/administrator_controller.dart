import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/models/administrator_activity.dart';
import 'package:i_model/models/client/client_points.dart';
import 'package:i_model/models/client/clients.dart';
import 'package:i_model/views/dialogs/sucess_dialog.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:intl/intl.dart';

class AdministratorController extends GetxController{
  /// Administrator list values
  final TextEditingController administratorNameController = TextEditingController();
  List<String> statusOptions = [Strings.active, Strings.inactive, Strings.all];
  RxString selectedStatus = Strings.all.obs;
  var isDropdownOpen = false.obs;
  // RxString selectedAdministrator = ''.obs;
  RxMap selectedAdministrator = {}.obs;




  /// Personal data
  final TextEditingController perDataNameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController registrationDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  List<String> profileOptions = [Strings.administrator, Strings.beautician];
  List<String> genderOptions = [Strings.man, Strings.women];
  List<String> sessionControlOptions = [Strings.yes, Strings.no];
  List<String> timeControlOptions = [Strings.yes, Strings.no];
  RxString selectedProfile = ''.obs;
  RxString selectedSessionControl = ''.obs;
  RxString selectedTimeControl = ''.obs;
  RxString selectedGender = ''.obs;



  // setInitialNickName(){
  //   nickNameController.text = selectedAdministrator.value.toUpperCase();
  //   update();
  // }

  pickBirthDate(BuildContext context) async {
    String? birthDate = await HelperMethods.selectDate(context);
    if(birthDate != null){
      birthDateController.text = birthDate;
    }
    update();
  }

  pickRegistrationDate(BuildContext context) async {
    String? registrationDate = await HelperMethods.selectDate(context);
    if(registrationDate != null) {
      registrationDateController.text = registrationDate;
    }
    update();
  }

  /// Administrators list
  RxList<dynamic> administratorsList = [
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

  /// Cards / bonos
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
  RxList<ClientPoints> consumedPoints = <ClientPoints>[].obs;

  /// Administrator activities
  RxList<AdministratorActivity> administratorActivity = [
    AdministratorActivity(date: '2025-02-01', start: '10:00', end: '12:00', bonuses: '200', client: 'Client 1'),
    AdministratorActivity(date: '2025-02-02', start: '11:15', end: '13:30', bonuses: '350', client: 'Client 2'),
    AdministratorActivity(date: '2025-02-03', start: '09:30', end: '11:45', bonuses: '150', client: 'Client 3'),
    AdministratorActivity(date: '2025-02-04', start: '14:00', end: '16:00', bonuses: '250', client: 'Client 4'),
    AdministratorActivity(date: '2025-02-05', start: '08:45', end: '10:15', bonuses: '100', client: 'Client 5'),
    AdministratorActivity(date: '2025-02-06', start: '16:30', end: '18:00', bonuses: '400', client: 'Client 6'),
    AdministratorActivity(date: '2025-02-07', start: '12:00', end: '14:00', bonuses: '300', client: 'Client 7'),
    AdministratorActivity(date: '2025-02-08', start: '10:30', end: '12:30', bonuses: '500', client: 'Client 8'),
    AdministratorActivity(date: '2025-02-09', start: '15:00', end: '17:00', bonuses: '450', client: 'Client 9'),
    AdministratorActivity(date: '2025-02-10', start: '13:15', end: '15:00', bonuses: '200', client: 'Client 10'),
  ].obs;

  @override
  void onClose() {
    administratorNameController.dispose();
    perDataNameController.dispose();
    nickNameController.dispose();
    birthDateController.dispose();
    registrationDateController.dispose();
    super.onClose();
  }

  /// Fetch administrators
  RxList<Map<String, dynamic>> allAdmins = <Map<String, dynamic>>[].obs; // Lista original de clientes
  RxList<Map<String, dynamic>> filteredAdmins = <Map<String, dynamic>>[].obs; // Lista filtrada

  Future<void> fetchAdmins() async {

    final dbHelper = DatabaseHelper();
    try {
      // Obtener los usuarios cuyo perfil es "Administrador" o "Ambos"
      final adminData =
      await dbHelper.getUsuariosPorTipoPerfil(Strings.administrator);
      allAdmins.value = adminData;

      // final adminDataEntrenador =
      // await dbHelper.getUsuariosPorTipoPerfil(Strings.beautician);

      print('allAdmins: $allAdmins');
      // print('BeauticianData: ${adminDataEntrenador.length}');
      // // También podemos obtener usuarios con el tipo de perfil 'Ambos' si es necesario
      // final adminDataAmbos = await dbHelper.getUsuariosPorTipoPerfil('Ambos');
      //
      // // Combina ambas listas
      // final allAdminData = [
      //   ...adminData,
      //   ...adminDataAmbos,
      //   ...adminDataEntrenador
      // ];


      //   allAdmins.value = allAdminData; // Asigna los usuarios filtrados
      //   filteredAdmins = allAdmins; // Inicializa la lista filtrada
      //
      //
      filterAdmins(); // Llama al filtro si es necesario
    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  Future<void> filterAdmins() async {
    String searchText = administratorNameController.text.toLowerCase();
    final dbHelper = DatabaseHelper();
    try {
      // Lista base para los filtros
      List<Map<String, dynamic>> admins;

      // Si el filtro de tipo no es 'Ambos', consulta la base de datos
      if (selectedStatus.value != Strings.all) {
        admins = await dbHelper.getUsuariosPorTipoPerfil(Strings.administrator);
        print('Call - Not todo');
      } else {
        // Usa todos los administradores si no se filtra por tipo
        admins = List<Map<String, dynamic>>.from(allAdmins);
        print('Call - All todo');
      }

      print('Admin: $admins');
      // Filtra por nombre
      admins = admins.where((admin) {
        final matchesName = admin['name']!.toLowerCase().contains(searchText.toLowerCase());
        final matchesStatus = selectedStatus == Strings.all ||
            admin['status']!.toLowerCase() == selectedStatus.toLowerCase();
        return matchesName && matchesStatus;
      }).toList();

      // Actualiza el estado con la lista filtrada

        filteredAdmins.value = admins;
      print('filteredAdmins: $filteredAdmins');

    } catch (e) {
      print("Error al filtrar administradores: $e");
    }
  }

  /// Administrator file
  /// Personal data --- Showing data from SQL
  Future<void> refreshControllers() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    int userId = selectedAdministrator['id'];
    // Obtener los datos del usuario desde la base de datos
    Map<String, dynamic>? updatedAdminData = await dbHelper.getUserById(userId);
    print('selectedAdmin: ${userId}');
    print('updatedAdminData: ${updatedAdminData}');

    if (updatedAdminData != null) {
      // Obtener el tipo de perfil asociado al usuario desde la base de datos
      String? tipoPerfil = await dbHelper.getTipoPerfilByUserId(userId);


      // Actualizar los campos del formulario con los datos del usuario
      perDataNameController.text = updatedAdminData['name'] ?? '';
      nickNameController.text = updatedAdminData['user'] ?? '';
      // _emailController.text = updatedAdminData['email'] ?? '';
      phoneController.text = updatedAdminData['phone'].toString();
      selectedGender.value = updatedAdminData['gender'];
      selectedProfile.value = tipoPerfil ?? ''; // Actualiza con el tipo de perfil obtenido
      selectedTimeControl.value = updatedAdminData['controltiempo'];
      selectedSessionControl.value = updatedAdminData['controlsesiones'];
      selectedStatus.value = updatedAdminData['status'];
      birthDateController.text = updatedAdminData['birthdate'];
      registrationDateController.text = updatedAdminData['altadate'];
    }
  }

  void updateUserData(BuildContext context) async {
    // Asegurarse de que todos los campos requeridos estén completos
    if (perDataNameController.text.isEmpty ||
        nickNameController.text.isEmpty ||
        // _emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedGender.value == Strings.nothing ||
        selectedStatus.value == Strings.nothing ||
        selectedSessionControl.value == Strings.nothing ||
        selectedTimeControl.value == Strings.nothing ||
        birthDateController.text.isEmpty ||
        registrationDateController.text.isEmpty
        // !_emailController.text.contains('@')
    ) {
      // Verificación de '@' en el correo
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Por favor, complete todos los campos correctamente'
      );
      return;
    }

    // Convertir la primera letra del nombre a mayúscula
    String name = perDataNameController.text.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1).toLowerCase();
    }

    // Datos del usuario
    final clientData = {
      'name': name, // Nombre con la primera letra en mayúscula
      'email': '',
      'user': nickNameController.text,
      'phone': phoneController.text,
      'gender': selectedGender.value,
      'altadate': registrationDateController.text,
      'controlsesiones': selectedSessionControl.value,
      'controltiempo': selectedTimeControl.value,
      'status': selectedStatus.value,
      'birthdate': birthDateController.text,
    };

    // Update in the database
    DatabaseHelper dbHelper = DatabaseHelper();

    // Actualizar el usuario en la base de datos
    await dbHelper.updateUser(selectedAdministrator['id'], clientData);

    // Imprimir los datos actualizados del cliente
    print('Datos del cliente actualizados: $clientData');

    // Obtener el perfilId correspondiente al tipo de perfil seleccionado
    int? perfilId = await dbHelper.getTipoPerfilId(selectedProfile.value);

    // Si el perfilId no se encuentra, se crea uno nuevo
    perfilId ??= await dbHelper.insertTipoPerfil(selectedProfile.value);

    // Actualizar la relación entre el usuario y el tipo de perfil en la tabla usuario_perfil
    await dbHelper.updateUsuarioPerfil(selectedAdministrator['id'], perfilId);

    // Refrescar los controladores con los datos actualizados
    // await _refreshControllers();

    // Mostrar un SnackBar de éxito
    showSuccessDialog(context, title: 'Usuario actualizado correctamente');
  }

  /// Delete administrator
  Future<void> deleteAdmin(BuildContext context) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteUser(selectedAdministrator['id']);

    alertOverlay(
        context,
        heading: translation(context).alertCompleteForm,
        isOneButtonNeeded: true,
        description: 'Administrador borrado correctamente'
    );
  }

  /// Bonos
  RxList<Map<String, String>> availableBonos = <Map<String, String>>[].obs; // Cambiar el tipo aquí
  List<Map<String, String>> consumedBonos = [];
  RxInt totalBonosAvailables = 0.obs; //

  Future<void> loadAvailableBonos() async {
    final dbHelper = DatabaseHelper();
    int userId = selectedAdministrator['id'];
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
    totalBonosAvailables.value = _calculateTotalBonos(availableBonos);
  }

  int _calculateTotalBonos(List<Map<String, dynamic>> bonos) {
    return bonos.fold(0, (sum, bono) {
      return sum +
          (int.tryParse(bono['quantity']) ??
              0); // Garantizar que la cantidad sea int
    });
  }

  Future<void> saveBonosUser(cantidadBonos) async {
    int userId = selectedAdministrator['id'];
    final dbHelper = DatabaseHelper();
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    await dbHelper.insertBonoUsuario({
      'usuario_id': userId,
      'cantidad': cantidadBonos,
      'estado': 'Disponible',
      'fecha': formattedDate,
    });

    loadAvailableBonos();
  }

  /// Update password
  Future<void> updatePassword(BuildContext context) async {
    try {
      // Crear el mapa con solo el campo pwd
      final clientData = {'pwd': '0000'};

      // Actualizar el usuario en la base de datos
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.updateUser(selectedAdministrator['id']!, clientData);
    }
    catch (e) {
      print('Error al actualizar la contraseña: $e');
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Error al resetear la contraseña'
      );
    }
  }

}