import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/db/db_helper.dart';
import 'package:i_model/db/db_helper_pc.dart';
import 'package:i_model/db/db_helper_web.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:i_model/views/overlays/reset_password_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoginController extends GetxController{
  RxBool isObscured = true.obs;
  List<Map<String, dynamic>> allAdmins = []; // Lista original de clientes
  List<Map<String, dynamic>> filteredAdmins = []; // Lista filtrada
  int? userId;
  RxBool isLoggedIn = false.obs;
  RxBool isLoading = true.obs;
  String? userTipoPerfil;
  RxString errorMessage = ''.obs;
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  changeVisibility(){
    isObscured.value = !isObscured.value;
    update();
  }

  @override
  void onInit() {
    initializeDatabase();
    _fetchAdmins();
    _checkUserProfile();
    checkUserLoginStatus();
    super.onInit();
  }


  Future<void> initializeDatabase() async {
    try {
      if (kIsWeb) {
        debugPrint("Inicializando base de datos para Web...");
        databaseFactory = databaseFactoryFfi;
        await DatabaseHelperWeb().initializeDatabase();
      } else if (Platform.isAndroid || Platform.isIOS) {
        debugPrint("Inicializando base de datos para Móviles...");
        await DatabaseHelper().initializeDatabase();
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        debugPrint("Inicializando base de datos para Desktop...");
        databaseFactory = databaseFactoryFfi;
        await DatabaseHelperPC().initializeDatabase();
      } else {
        throw UnsupportedError(
            'Plataforma no soportada para la base de datos.');
      }
      debugPrint("Base de datos inicializada correctamente.");
    } catch (e) {
      debugPrint("Error al inicializar la base de datos: $e");
    }
  }

  Future<void> _fetchAdmins() async {
    final dbHelper = DatabaseHelper();
    try {
      // Obtener los usuarios cuyo perfil es "Administrador" o "Ambos"
      final adminData =
      await dbHelper.getUsuariosPorTipoPerfil('Administrador');
      final adminDataEntrenador =
      await dbHelper.getUsuariosPorTipoPerfil('Esteticistas');
      // También podemos obtener usuarios con el tipo de perfil 'Ambos' si es necesario
      final adminDataAmbos = await dbHelper.getUsuariosPorTipoPerfil('Ambos');

      // Combina todas las listas
      final allAdminData = [
        ...adminData,
        ...adminDataAmbos,
        ...adminDataEntrenador
      ];

      // Imprime la información de todos los usuarios obtenidos
      print('Información de todos los usuarios:');
      for (var admin in allAdminData) {
        print(
            admin); // Asegúrate de que admin tenga un formato imprimible (e.g., Map<String, dynamic>)
      }


        allAdmins = allAdminData; // Asigna los usuarios filtrados
        filteredAdmins = allAdmins; // Inicializa la lista filtrada

    } catch (e) {
      print('Error fetching clients: $e');
    }
  }

  Future<void> _checkUserProfile() async {
    // Obtener el userId desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId =
        prefs.getInt('user_id'); // Guardamos el userId en la variable de clase

    if (userId != null) {
      // Obtener el tipo de perfil del usuario usando el userId
      DatabaseHelper dbHelper = DatabaseHelper();
      String? tipoPerfil = await dbHelper.getTipoPerfilByUserId(userId!);

        userTipoPerfil = tipoPerfil; // Guardamos el tipo de perfil en el estado

    } else {
      // Si no se encuentra el userId en SharedPreferences
      print('No se encontró el userId en SharedPreferences.');

      // Aquí puedes agregar un flujo para navegar al login si no hay usuario
      // widget.onNavigateToLogin();
    }
  }

  Future<void> validateLogin(BuildContext context) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String username = usernameEditingController.text.trim();
    String password = passwordEditingController.text.trim();

    // Verificar en la base de datos si las credenciales del usuario son correctas
    bool userExists = await dbHelper.checkUserCredentials(username, password);
    print('userExists: $userExists');

    if (userExists) {
      // Si las credenciales son correctas, limpiar el mensaje de error

        errorMessage.value = ''; // Limpiar error


      // Obtener el userId después de la autenticación
      int userId = await dbHelper.getUserIdByUsername(username);
      userId = userId;
      print('userID: $userId');

      // Obtener el tipo de perfil del usuario
      String? tipoPerfil = await dbHelper.getTipoPerfilByUserId(userId);

      // Imprimir el userId y el tipo de perfil en consola
      print('User ID: $userId');
      print('Tipo de Perfil: $tipoPerfil');

      // Guardar el userId y tipo de perfil en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Limpiar los valores anteriores antes de guardar nuevos datos
      await prefs.remove('user_id');
      await prefs.remove('user_tipo_perfil');

      // Guardar los nuevos valores
      prefs.setInt('user_id', userId); // Guardar el userId
      if (tipoPerfil != null) {
        prefs.setString(
            'user_tipo_perfil', tipoPerfil); // Guardar el tipo de perfil
      }

      // Imprimir los datos guardados para verificar
      print('Nuevo user_id guardado: ${prefs.getInt('user_id')}');
      print(
          'Nuevo user_tipo_perfil guardado: ${prefs.getString('user_tipo_perfil')}');

      // Si la contraseña es "0000", navega a cambiar la contraseña
      if (password == "0000") {
        resetPasswordOverlay(context, onTap: (){
          _updatePassword(context);
        });
      } else {
        // Retraso antes de navegar al menú principal
        await Future.delayed(
            const Duration(seconds: 1)); // Retraso de 1 segundo
        // Navegar al menú principal
        Navigator.pushNamed(context, Strings.menuScreen);
      }
    } else {
      // Si las credenciales son incorrectas, mostrar el mensaje de error

        errorMessage.value = Strings.inCorrectCredentials;// Mostrar error
        HelperMethods.showSnackBar(context, title: errorMessage.value);
    }
  }

  /// Change password
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  Future<void> _updatePassword(BuildContext context) async {
    if (userId == null) {
      print('UserId no disponible.');
      return;
    }

    // Verificamos si las contraseñas coinciden
    if (newPasswordController.text != repeatPasswordController.text) {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Las contraseñas no coinciden'
      );
      return;
    }

    // Verificamos que la nueva contraseña no sea "0000"
    if (newPasswordController.text == '0000') {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'La contraseña no puede ser "0000'
      );

      print('Intento de contraseña inválida: 0000');
      return;
    }

    try {
      // Crear el mapa con solo el campo pwd
      final clientData = {'pwd': newPasswordController.text};
      print('Datos a actualizar en la base de datos: $clientData');

      // Actualizar el usuario en la base de datos
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.updateUser(userId!, clientData);
      print(
          'Contraseña actualizada correctamente para el usuario con ID $userId.');

      // Guardar el userId y tipo de perfil en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('SharedPreferences obtenidas: ${prefs.getKeys()}');

      // Limpiar los valores anteriores antes de guardar nuevos datos
      await prefs.remove('user_id');
      await prefs.remove('user_tipo_perfil');
      print('Valores previos de user_id y user_tipo_perfil eliminados.');

      // Guardar el nuevo userId en SharedPreferences
      prefs.setInt('user_id', userId!); // Guardar el userId
      print('Nuevo user_id guardado: ${prefs.getInt('user_id')}');

      // Obtener el tipo de perfil actualizado para el usuario
      String? tipoPerfil = await dbHelper.getTipoPerfilByUserId(userId!);
      if (tipoPerfil != null) {
        prefs.setString(
            'user_tipo_perfil', tipoPerfil); // Guardar el tipo de perfil
        print(
            'Nuevo user_tipo_perfil guardado: ${prefs.getString('user_tipo_perfil')}');
      }

      // Mostrar mensaje de éxito antes de desmontar el widget
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Contraseña actualizada con éxito'
      );

      // Navegar al menú principal

    } catch (e) {
      alertOverlay(
          context,
          heading: translation(context).alertCompleteForm,
          isOneButtonNeeded: true,
          description: 'Error al resetear la contraseña'
      );
      print('Error al actualizar la contraseña: $e');

    }
  }


  Future<bool> checkUserLoginStatus() async {
    // Obtener el userId desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    // Navegar según la existencia del userId
    if (userId != null) {
      isLoggedIn.value = true;
    }
    isLoading.value = true;
    return isLoggedIn.value;
  }



}