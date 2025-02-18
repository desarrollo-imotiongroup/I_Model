import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/app_state.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/license.dart';
import 'package:platform/platform.dart';
import 'package:http/http.dart' as http;

class LicenseController extends GetxController{
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController directionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode directionFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode provinceFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  RxList<License> mciLicenseList = <License>[].obs;
  RxList<Map<String, dynamic>> mcis = <Map<String, dynamic>>[].obs;
  RxString licenseStatus = Strings.nothing.obs;

  /// Session control
  RxInt maxTimeValue = 25.obs;


  @override
  Future<void> onInit() async{

    AppState.instance.loadState().then((_) {
      // Una vez cargado el estado, actualizamos la UI
        // Los controladores ahora contienen los valores cargados desde SharedPreferences
        licenseNumberController.text = AppState.instance.nLicencia;
        nameController.text = AppState.instance.nombre;
        directionController.text = AppState.instance.direccion;
        cityController.text = AppState.instance.ciudad;
        provinceController.text = AppState.instance.provincia;
        countryController.text = AppState.instance.pais;
        phoneController.text = AppState.instance.telefono;
        emailController.text = AppState.instance.email;

        mcis.value = AppState.instance.mcis;
        licenseStatus.value = AppState.instance.bloqueada == '1' ? 'Bloqueada' : 'Activa';
        print('AppState.instance.mcis: ${AppState.instance.mcis}');
    });

    super.onInit();
  }

  moveFocusTo(BuildContext context, FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// license / MCI details
  RxString selectedStatus = ''.obs;
  RxBool toggle = false.obs;
  List<String> statusList = [Strings.inactive, Strings.active];

  updateStatus({required int index, required String value}){
    mciLicenseList[index].status.value = value;
    update();
  }

  unfocus() {
    nameFocusNode.unfocus();
    directionFocusNode.unfocus();
    cityFocusNode.unfocus();
    provinceFocusNode.unfocus();
    countryFocusNode.unfocus();
    phoneFocusNode.unfocus();
    emailFocusNode.unfocus();
  }



  List<Map<String, dynamic>> allMcis = []; // Lista original de clientes
  Map<String, dynamic> licenciaData =
  {}; // Mapa para almacenar la respuesta de la licencia
  List<String> macList = []; // Para almacenar las MACs
  List<String> macBleList = []; // Para almacenar las MACs BLE
  String bloqueada = ''; // Para almacenar si la licencia está bloqueada
  bool _isLicenciaValida = false;
  String cadenaLicencia = '';
  String cadenaEncriptada = '';
  String cadenaCodificada = '';
  String url = '';
  String respuestaServidor = '';
  String estadoBloqueada = '';
  List<String> parsedData = [];
  String licenciaMac = '';





// Método para detectar el sistema operativo
  String detectarSO() {
    final Platform platform = LocalPlatform(); // Obtenemos la plataforma actual

    if (platform.isWindows) {
      print("Sistema Operativo: Windows");
      return 'WIN';
    } else if (platform.isIOS) {
      print("Sistema Operativo: iOS");
      return 'IOS';
    } else if (platform.isAndroid) {
      print("Sistema Operativo: Android");
      return 'AND';
    } else {
      print("Sistema Operativo: Otro");
      return 'OTRO'; // Para otros SO si es necesario
    }
  }

// Método para generar la cadena de licencia
  String generarCadenaLicencia() {
    String licencia = licenseNumberController.text;
    String nombre = nameController.text;
    String direccion = directionController.text;
    String ciudad = cityController.text;
    String provincia = provinceController.text;
    String pais = countryController.text;
    String telefono = phoneController.text;
    String email = emailController.text;

    String modulo = "imotion21"; // Valor fijo
    String so = detectarSO(); // Detectamos el sistema operativo

    // Imprimimos todos los valores para comprobar que están correctos
    print("Generando cadena de licencia con los siguientes datos:");
    print("Licencia: $licencia");
    print("Nombre: $nombre");
    print("Dirección: $direccion");
    print("Ciudad: $ciudad");
    print("Provincia: $provincia");
    print("País: $pais");
    print("Teléfono: $telefono");
    print("Email: $email");
    print("Módulo: $modulo");
    print("Sistema Operativo: $so");

    // Generamos la cadena de licencia
    String cadenaLicencia =
        "13<#>$licencia<#>$nombre<#>$direccion<#>$ciudad<#>$provincia<#>$pais<#>$telefono<#>$email<#>$modulo<#>$so";

    print("CADENA LICENCIA: $cadenaLicencia");

    return cadenaLicencia; // Aquí se devuelve la cadena codificada
  }

// Método de encriptación (sin cambios)
  String encrip(String wcadena) {
    String xkkk =
        'ABCDE0FGHIJ1KLMNO2PQRST3UVWXY4Zabcd5efghi6jklmn7opqrs8tuvwx9yz(),-.:;@';
    String xkk2 = '[]{}<>?¿!¡*#';
    int wp = 0, wd = 0, we = 0, wr = 0;
    String wa = '', wres = '';
    int wl = xkkk.length;
    var wcont = Random().nextInt(10);

    if (wcadena != '') {
      wres = xkkk.substring(wcont, wcont + 1);
      for (int wx = 0; wx < wcadena.length; wx++) {
        wa = wcadena.substring(wx, wx + 1);
        wp = xkkk.indexOf(wa);
        if (wp == -1) {
          wd = wa.codeUnitAt(0);
          we = wd ~/ wl;
          wr = wd % wl;
          wcont += wr;
          if (wcont >= wl) {
            wcont -= wl;
          }
          wres += xkk2.substring(we, we + 1) + xkkk.substring(wcont, wcont + 1);
        } else {
          wcont += wp;
          if (wcont >= wl) {
            wcont -= wl;
          }
          wres += xkkk.substring(wcont, wcont + 1);
        }
      }
    }

    print("Cadena encriptada: $wres"); // Imprime la cadena encriptada
    return wres;
  }

  Future<void> validarLicencia(BuildContext context) async {
    // Validar que los campos no estén vacíos
    if (licenseNumberController.text.isEmpty ||
        nameController.text.isEmpty ||
        directionController.text.isEmpty ||
        cityController.text.isEmpty ||
        provinceController.text.isEmpty ||
        countryController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      HelperMethods.showSnackBar(context, title: 'Debes rellenar todos los campos');
      return;
    }
    unfocus();
    // Si todos los campos están llenos, procedemos con la validación de la licencia
    // Generar la cadena de licencia
    String generatedCadenaLicencia = generarCadenaLicencia();

    cadenaLicencia = generatedCadenaLicencia;

    print("Cadena de licencia generada: $cadenaLicencia");

    // Encriptar la cadena de licencia
    String encryptedCadena = encrip(generatedCadenaLicencia);

      cadenaEncriptada = encryptedCadena;

    print("Cadena encriptada: $cadenaEncriptada");

    // Codificar la cadena encriptada para enviarla como parte de la URL
    String encodedCadena = Uri.encodeFull(encryptedCadena);

    cadenaCodificada = encodedCadena;
    url = "https://imotionems.es/lic2.php?a=$cadenaCodificada";

    print("URL de validación enviada: $url");

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        // Aquí procesamos la respuesta del servidor
        String respuesta = response.body;

        respuestaServidor = respuesta;

        print("Respuesta recibida del servidor: $respuesta");

        // Procesar la respuesta del servidor
        Map<String, dynamic> licenciaData = procesarRespuesta(respuesta);

        // Extraer las MCIs del mapa de datos procesados
        mcis.value = licenciaData["mcis"];

        // Filtrar las MCIs para eliminar las que tienen la MAC vacía
        mcis.value = mcis.where((mci) => mci['mac'].isNotEmpty).toList();

        // Verificar que mcis no esté vacío y procesarlo
        if (mcis.isNotEmpty) {
          allMcis = mcis;
          // Actualizar el estado con las MCIs procesadas

          macList = mcis.map((mci) => mci['mac'] as String).toList();
          macBleList = mcis
                .where((mci) =>
          mci['macBle'] as bool) // Asegurarse de que sea un bool
                .map((mci) => mci['mac'] as String)
                .toList();
          estadoBloqueada = licenciaData['bloqueada']
                ? "1"
                : "0"; // Convertir bool a String


          print("Información procesada:");
          print(
              "Estado de la licencia: ${estadoBloqueada == '1' ? 'Bloqueada' : 'Activa'}");
          licenseStatus.value = estadoBloqueada == '1' ? 'Bloqueada' : 'Activa';
          print("Limite semanal: ${licenciaData['limiteSemana']}");
          print("Estado del biomac: ${licenciaData['biomac']}");
          print("Nivel en la nube: ${licenciaData['nivelNube']}");
          print("Sesiones en la nube: ${licenciaData['nubeSesiones']}");
          print("EMS activo: ${licenciaData['emsActivo']}");
          print("MCIs procesadas:");
          print('MCIIII: ${mcis[0]['mac']}');
          mcis.forEach((mci) {
            print(
                "MCI - MAC: ${mci['mac']}, MAC BLOQUEADA: ${mci['macBloqueo'] ? 'Bloqueada' : 'Activa'}, BLE: ${mci['macBle'] ? 'BLE' : 'BT'}, Nombre: ${mci['nombre']}");
          });

          // Marcar la licencia como válida

          _isLicenciaValida = true;


          // Guardar el estado utilizando AppState
          AppState.instance.nLicencia = licenseNumberController.text;
          AppState.instance.nombre = nameController.text;
          AppState.instance.direccion = directionController.text;
          AppState.instance.ciudad = cityController.text;
          AppState.instance.provincia = provinceController.text;
          AppState.instance.pais = countryController.text;
          AppState.instance.telefono = phoneController.text;
          AppState.instance.email = emailController.text;
          AppState.instance.isLicenciaValida = _isLicenciaValida;
          AppState.instance.macList = macList;
          AppState.instance.macBleList = macBleList;
          AppState.instance.bloqueada = estadoBloqueada;
          AppState.instance.licenciaData = licenciaData;
          // Guardar la lista de MCIs en AppState
          AppState.instance.mcis = mcis;

          // Guardar los datos en SharedPreferences
          await AppState.instance.saveState();
        } else {
          print("Las MCIs están vacías o son inválidas.");
        }
      } else {
        print(
            "Error al validar la licencia. Código de estado: ${response.statusCode}");
      }
    } catch (e) {
      print('Excepción al validar la licencia: $e');
      HelperMethods.showSnackBar(context, title: 'Licencia no válida');
    }
    update();
  }

  Map<String, dynamic> procesarRespuesta(String respuesta) {
    // Dividimos la respuesta en partes
    List<String> datos = respuesta.split('|');

    // Validación para evitar errores si la respuesta no tiene suficientes elementos
    if (datos.length < 33) {
      print("La respuesta no contiene datos suficientes.");
      return {};
    }

    // Extraer propiedades generales de la licencia
    Map<String, dynamic> licenciaInfo = {
      "limiteSemana": int.tryParse(datos[15]) ?? 0, // Límite semanal
      "bloqueada": datos[16] == "1", // Si la licencia está bloqueada
      "biomac": datos[17], // MAC del lector de bioimpedancia
      "nivelNube": int.tryParse(datos[18]) ?? 0, // Nivel de nube
      "nubeSesiones": int.tryParse(datos[19]) ?? 0, // Sesiones en la nube
      "emsActivo": datos[32] == "1", // Si el EMS está activo
    };

    // Crear una lista para almacenar las MCIs con sus características
    List<Map<String, dynamic>> mcis = [];

    // Iteramos sobre las MCIs (índices 1 al 7 para las MACs)
    for (int i = 0; i < 7; i++) {
      Map<String, dynamic> mci = {
        "mac": datos[1 + i], // MAC del MCI
        "macBloqueo": datos[8 + i] == "1", // Estado de bloqueo (true/false)
        "macBle": datos[20 + i] == "1", // Si es BLE (true/false)
        "nombre": datos[27 + i], // Nombre del MCI
      };
      mcis.add(mci);
    }

    // Añadir las MCIs al mapa de información de la licencia
    licenciaInfo["mcis"] = mcis;

    // Retornamos la información de la licencia procesada
    return licenciaInfo;
  }


  disposeController() {
    Get.delete<LicenseController>();
  }
}