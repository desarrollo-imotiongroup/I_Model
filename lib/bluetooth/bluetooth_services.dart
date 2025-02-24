// import 'dart:async';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart' as ble;
// import 'package:sqflite/sqflite.dart';
// import 'package:http/http.dart' as http;
//
// class comun {
//   static String so = '';
//
//   static String serviciouuid = "49535343-fe7d-4ae5-8fa9-9fafd205e455";
//   static String escribiruuid = "49535343-8841-43f4-a8d4-ecbe34729bb3";
//   static String leeruuid = "49535343-1e4d-4bd9-ba61-23c647249616";
//   static String escribiruuid5 = "49535343-8841-43f4-a8d4-ecbe34729bb4";
//   static String leeruuid5 = "49535343-1e4d-4bd9-ba61-23c647249617";
//
//   static int pagina =
//   12; //12-splash, 10-login, 11-cambiapass, 0-menu, 1-panel, 2-configuracion, 3-clientes, 4-usuarios
//
//   static List<String> idioma = List.filled(1, '', growable: true);
//   static List<String> idioma2 = List.filled(1, '', growable: true);
//
//   static int ni = 0;
//
//   static String vmensaje = '';
//   static bool vaviso = false;
//
//   static List<String> ciciclo = [
//     '1.2.3.4.5.6.7.8.9',
//     '4.5:1.2.3:9',
//     '4.5.8:1.2.3:6.7.9',
//     '4.5.8:1.2.3.6.7.9'
//   ];
//
//   static List<int> peso = [0, 24, 29, 27, 42, 32, 27, 42, 42, 25, 25];
//
//   static int grupoabloquear = 0;
//
//   // static late Soundpool pool;
//   // static SoundpoolOptions spo = const SoundpoolOptions();
//   static late int beep;
//
//   static int numusuario = 0;
//   static int porbonos = 0;
//   static int usubonos = 0;
//
//   static int nivelnube = 0, nubesesiones = 0;
//   static int duracionsesion = 1500;
//
//   // static late VideoPlayerController vpc;
//
//   static bool swvideo = false, swvideopos = false;
//
//   static int limitesemana = 0;
//
//   static double coefekcal = 1.15;
//
//   // programas
//   static List<String> prnombre = List.filled(1, '', growable: true);
//   static List<int> prgrupo = List.filled(1, 1, growable: true);
//   static List<int> prfrecuencia = List.filled(1, 0, growable: true);
//   static List<int> prpulso = List.filled(1, 0, growable: true);
//   static List<int> prrampa = List.filled(1, 0, growable: true);
//   static List<int> prcontraccion = List.filled(1, 0, growable: true);
//   static List<int> prpausa = List.filled(1, 0, growable: true);
//   static List<String> practivo = List.filled(1, '', growable: true);
//   static List<String> prcronaxie = List.filled(1, '', growable: true);
//   static List<String> prfrecuencia2 = List.filled(1, '', growable: true);
//   static List<String> prtexto = List.filled(1, '', growable: true);
//
//   static List<String> innombre = List.filled(1, '', growable: true);
//   static List<int> ingrupo = List.filled(1, 1, growable: true);
//   static List<String> insecuencia = List.filled(1, '', growable: true);
//   static List<String> intexto = List.filled(1, '', growable: true);
//
//   static int contadorluces = 0;
//   static int idluces = 0;
//
//   static String licencia = '';
//
//   static String passnumero = '';
//
//   static int segundosrenovacion = 0;
//
//   static late Database dbase;
//
//   static String modulo = 'imotion21';
//   static String xkkk =
//       'ABCDE0FGHIJ1KLMNO2PQRST3UVWXY4Zabcd5efghi6jklmn7opqrs8tuvwx9yz(),-.:;@';
//   static String xkk2 = '[]{}<>?¿!¡*#';
//
//   static bool debug = true;
//   static bool swlog = false;
//
//   static int incremento = 2;
//
//   static int hora = 0;
//
//   static int a1 = 0, a2 = 0, a3 = 0, a4 = 0;
//
//   static List<String> weblog = List.filled(1, '', growable: true);
//
//   // static void initpool(SoundpoolOptions sp) {
//   //   spo = sp;
//   //   pool = Soundpool.fromOptions(options: spo);
//   //   leerpitidos();
//   // }
//
//   // static Future<void> leerpitidos() async {
//   //   var asset = await rootBundle.load("assets/beeplargo.wav");
//   //   beep = await pool.load(asset);
//   // }
//
//   // static Future<void> beeplargo() async {
//   //   await pool.play(beep);
//   // }
//
//   static int intparse(String str) {
//     try {
//       int valor = int.parse(str);
//       return valor;
//     } on FormatException {
//       return 0;
//     }
//   }
//
//   static String fechaamd(String fec) {
//     List<String> f = fec.split('-');
//     String fecha;
//
//     if (f.length == 3) {
//       if (f[0].length == 4) {
//         if (f[1].length == 1) {
//           f[1] = '0${f[1]}';
//         }
//         if (f[2].length == 1) {
//           f[2] = '0${f[2]}';
//         }
//         fecha = '${f[0]}-${f[1]}-${f[2]}';
//       } else {
//         if (f[0].length == 1) {
//           f[0] = '0${f[0]}';
//         }
//         if (f[1].length == 1) {
//           f[1] = '0${f[1]}';
//         }
//         fecha = '${f[2]}-${f[1]}-${f[0]}';
//       }
//     } else {
//       fecha = fec;
//     }
//     return fecha;
//   }
//
//   static String fechadma(String fec) {
//     List<String> f = fec.split('-');
//     String fecha;
//
//     if (f.length == 3) {
//       if (f[0].length == 4) {
//         if (f[1].length == 1) {
//           f[1] = '0${f[1]}';
//         }
//         if (f[2].length == 1) {
//           f[2] = '0${f[2]}';
//         }
//         fecha = '${f[2]}-${f[1]}-${f[0]}';
//       } else {
//         if (f[0].length == 1) {
//           f[0] = '0${f[0]}';
//         }
//         if (f[1].length == 1) {
//           f[1] = '0${f[1]}';
//         }
//         fecha = '${f[0]}-${f[1]}-${f[2]}';
//       }
//     } else {
//       fecha = fec;
//     }
//     return fecha;
//   }
//
//   static int leersegundos() {
//     var ahora = DateTime.now();
//     var dif = ahora.difference(diainicial);
//     int segundos = dif.inSeconds;
//     return segundos;
//   }
//
//   static String encrip(String wcadena) {
//     int wp = 0, wd = 0, we = 0, wr = 0;
//     String wa = '', wres = '';
//
//     int wl = xkkk.length;
//
//     calcularclave();
//     var wcont = a1;
//
//     if (wcadena != '') {
//       wres = xkkk.substring(wcont, wcont + 1);
//       for (int wx = 0; wx < wcadena.length; wx++) {
//         wa = wcadena.substring(wx, wx + 1);
//         wp = xkkk.indexOf(wa);
//         if (wp == -1) {
//           // no esta
//           wd = wa.codeUnitAt(0);
//           we = wd ~/ wl;
//           wr = wd % wl;
//           wcont += wr;
//           if (wcont >= wl) {
//             wcont -= wl;
//           }
//           wres += xkk2.substring(we, we + 1) + xkkk.substring(wcont, wcont + 1);
//         } else {
//           // esta
//           wcont += wp;
//           if (wcont >= wl) {
//             wcont -= wl;
//           }
//           wres += xkkk.substring(wcont, wcont + 1);
//         }
//       }
//     }
//
//     return wres;
//   }
//
//   static String desencrip(String wcadena) {
//     String wres = '', wa = '';
//     int wp = 0, wq = 0, ws = 0, wcont = 0;
//
//     int wl = xkkk.length;
//
//     if (wcadena != '') {
//       wa = wcadena.substring(0, 1);
//       wcont = xkkk.indexOf(wa);
//
//       for (int wx = 1; wx < wcadena.length; wx++) {
//         wa = wcadena.substring(wx, wx + 1);
//
//         wq = xkk2.indexOf(wa);
//         if (wq == -1) {
//           // normal
//           wp = xkkk.indexOf(wa);
//           ws = wp - wcont;
//           if (ws < 0) {
//             ws += wl;
//           }
//           wres += xkkk.substring(ws, ws + 1);
//           wcont = wp;
//         } else {
//           //caracter especial
//           wx++;
//           wa = wcadena.substring(wx, wx + 1);
//           wp = xkkk.indexOf(wa);
//           ws = wp - wcont;
//           if (ws < 0) {
//             ws += wl;
//           }
//           wres += String.fromCharCode(wl * wq + ws);
//           wcont = wp;
//         }
//       }
//     }
//     return wres;
//   }
//
//   static void calcularclave() {
//     a1 = Random().nextInt(10);
//     a2 = Random().nextInt(10);
//     a3 = Random().nextInt(10);
//     a4 = Random().nextInt(10);
//
//     comun.passnumero = '';
//   }
//
//   static String datosinteligente(int ni, int tiempopasado) {
//     List<String> pi = insecuencia[ni].split(':');
//     String segmento = '';
//     int acumulador = 0;
//     int sw = 0;
//     for (int x = 0; x < pi.length; x++) {
//       List<String> pi2 = pi[x].split('_');
//       if (sw == 0) {
//         pi2[1] = pi2[1].replaceAll(',', '.');
//         acumulador += (double.parse(pi2[1]) * 60).toInt();
//         if (acumulador > tiempopasado) {
//           sw = 1;
//           segmento = pi[x];
//         }
//       }
//     }
//     return '${segmento}_$acumulador';
//   }
//
//   static String traducir(String texto) {
//     String resultado = texto;
//     if (ni > 0) {
//       for (int x = 0; x < comun.idioma.length; x++) {
//         if (comun.idioma[x] == texto) {
//           resultado = comun.idioma2[x];
//         }
//       }
//     }
//     return resultado;
//   }
// }
//
// class clmci {
//   int numeromci = 0;
//   String macAddress = ' ';
//   String macnombre = ' ';
//   String macbloqueo = '1';
//   String macactivo = '1';
//   int esble = 0;
//
//   int aconectar = 0;
//   bool swparametro = false;
//
//   bool esv5 = false;
//
//   //ImotionMciCom imotionMciCom = ImotionMciCom();
//   late StreamSubscription streamSubscription;
//
//   late BluetoothConnection serconexion;
//   ble.BluetoothDevice dispositivo = ble.BluetoothDevice.fromId('');
//   late StreamSubscription sus;
//   late StreamSubscription conn;
//   late ble.BluetoothCharacteristic mcileer;
//   late ble.BluetoothCharacteristic mciescribir;
//
//   int errores = 0;
//   int errorvalidar = 0;
//   String idmci = '';
//   String mac6 = ' ';
//   String elev1 = ' ';
//   String elev2 = ' ';
//   String versw = ' ';
//   String verhw = ' ';
//   String xmac1 = ' ';
//   String xmac2 = ' ';
//   String xmac3 = ' ';
//   String xmac4 = ' ';
//   String xmac5 = ' ';
//   String xmac6 = ' ';
//   String xmac7 = ' ';
//   String xmac8 = ' ';
//   String xmac9 = ' ';
//   String xmac10 = ' ';
//   String xmac11 = ' ';
//   String xmac12 = ' ';
//
//   int estado =
//   0; //0=POWER OFF, 1=CONFIG, 2=BAT VERY LOW, 3=LIMIT, 4=CHARGE, 5=CHARGE, 6=STOP, 7=STOP, 8=PAUSE, 9=RUN, 10=RUN, 11=CLOSE
//   int estadobat = 0;
//   double mcivoltaje = 0;
//   int temperatura = 0;
//
//   int flag1 = 0;
//   int flag2 = 0;
//   int tarifa = 0;
//   int ct = 0;
//   int cp = 0;
//   int lica = 0;
//   int licb = 0;
//   int licc = 0;
//   int licd = 0;
//   int estadoequipo =
//   0; //-1=bloqueado, 0=no conectado, 1=conectado, 2=pausa, 3=en marcha
//   int equipovalidado = 0;
//   int equipogrupo = 0;
//
//   List<int> ch = List.filled(10, 0);
//   List<int> ch0 = List.filled(10, 0);
//   List<bool> chanulado = List.filled(10, false);
//   List<bool> chbloqueado = List.filled(10, false);
//   List<bool> chconectado = List.filled(10, true);
//   List<bool> chciclo = List.filled(10, false);
//
//   List<String> tolva = List.filled(0, '', growable: true);
//
//   int clave1 = 0;
//   int clave2 = 0;
//   int clave3 = 0;
//   int clave4 = 0;
//   int rclave1 = 0;
//   int rclave2 = 0;
//   int rclave3 = 0;
//   int rclave4 = 0;
//   int mediach = 0;
//
//   int tipoprograma = 0; //1-libre 2-programa 3-inteligente 4-rehabilitacion
//   int traje = 0; //0-traje 1-pantalon
//
//   int subirbajarx = 0;
//   List<int> subirbajar = List.filled(10, 0);
//
//   int cicloElegido = 0;
//   int indiceCiclo = 0;
//   List<String> ci = List.filled(7, "");
//
//   int rampa = 0;
//   int contraccion = 0;
//   int pausa = 0;
//   int frecuencia = 0;
//   int pulso = 0;
//
//   List<int> cr = List.filled(10, 0);
//
//   String frecuencia2 = '';
//   int idfrecuencia2 = 0;
//   int compensacionfrecuencia = 0;
//
//   bool pausaactiva = false;
//
//   int ultimacop = 0; //comienzo de contraccion o pausa
//   String cop = ''; //estado de contraccion o pausa
//
//   String horaInicio = '';
//   int tiempoInicio = 0;
//   int tiempoInicioPausa = 0;
//   int pausaAcumulada = 0;
//   int tiempoParada = 0;
//   int vvparada = 0;
//   double segTranscurrido = 0.0;
//   double segPendientes = 0.0;
//
//   String fechasemana = '', fechamci = '';
//   int tiempograbado = 0;
//
//   //programa simple
//   int numeroprograma = 0;
//   int ultimoPrograma = 0;
//
//   // programa inteligente
//   int numerointeligente = 0;
//   int tiempoSalto = 0;
//   int tiempoSegmento = 0;
//   int piprograma = 0;
//   String pisegmento = '';
//   int piajuste = 0; //ajuste cuando hay cambio de programa
//
// //datos cliente
//   int cliente = 0;
//   int bono = 0;
//   String nombrecliente = '';
//   String nombrecliente6 = '';
//   int sexocliente = 0;
//   int pesocliente = 0;
//   String actividad = '';
//   int puntos0 = 0;
//   int puntos = 0;
//   int ekcal = 0;
//
//   List<int> bufferEscritura = List.filled(120, 0);
//   List<int> bufferLectura = List.filled(250, 0);
//   List<int> bufferParam = List.filled(300, 0);
//   bool swescritura = false;
//
//   int ctdia = 0;
//   int ctmes = 0;
//   int ctao = 0;
//   int cta = 0;
//   int ctb = 0;
//   int ctc = 0;
//   int ctd = 0;
//   int ct1 = 0;
//   int ct2 = 0;
//   int ct3 = 0;
//   int ct4 = 0;
//
//   bool permiso = true;
//
//   int idBufferLectura = 0;
//   int ultimaEscritura = 0;
//
//   //conmutadores para disparar funciones
//   int swrenovacion = 0;
//
//   bool swesperarespuesta = false;
//   bool escudo = false;
//
//   bool swrepite = false;
//   bool swesperarepite = false;
//   String repitesesion = '';
//   int idrepite = 0;
//   int sigtiemporepite = 0;
//
//   String lbtiempo = '';
//   int arcotiempo = 0;
//   double porccontraccion = 0;
//   double porcpausa = 0;
//
//   clmci(int numero, String mac, String nombre, String bloqueo, String activo,
//       int esbl, int tipopro) {
//     numeromci = numero;
//     macAddress = mac;
//     macnombre = nombre;
//     macbloqueo = bloqueo;
//     macactivo = activo;
//     esble = esbl;
//     aconectar = 1;
//     tipoprograma = tipopro;
//   }
//
//   Future<void> conectar() async {
//     aconectar = 0;
//     errores = 0;
//     swesperarespuesta = false;
//     if (macAddress != '' && macactivo == '1') {
//       if (esble == 1) {
//         //ble
//         if (dispositivo.isDisconnected) {
//           if (comun.so == 'AND') {
//             dispositivo = ble.BluetoothDevice.fromId(macAddress);
//             bleconectar();
//           } else {
//             //ios
//             if (idmci == '') {
//               await blescan();
//             }
//             if (idmci != '') {
//               dispositivo = ble.BluetoothDevice.fromId(idmci);
//               ble.FlutterBluePlus.adapterState
//                   .listen((ble.BluetoothAdapterState estado) async {
//                 if (estado == ble.BluetoothAdapterState.on) {
//                   bleconectar();
//                 }
//               });
//             }
//           }
//         }
//       } else {
//         serconectar();
//       }
//     }
//   }
//
//   Future<void> blescan() async {
//     ble.FlutterBluePlus.scanResults.listen((value) {
//       for (int x = 0; x < value.length; x++) {
//         if (value[x].device.platformName.toString() == macnombre) {
//           idmci = value[x].device.remoteId.toString();
//           ble.FlutterBluePlus.stopScan();
//           swparametro = true;
//         }
//       }
//     })
//         .onError((value){
//       print('error: '+value.toString());
//     });
//
//     ble.FlutterBluePlus.adapterState.listen((ble.BluetoothAdapterState estado) {
//       if (estado == ble.BluetoothAdapterState.on) {
//
//         ble.FlutterBluePlus.startScan();
//       }
//     });
//     await Future.delayed(const Duration(seconds: 6));
//     ble.FlutterBluePlus.stopScan();
//   }
//
//   Future<void> bleconectar() async {
//     dispositivo.connect().then((value) async {
//       //buscar servicios
//       List<ble.BluetoothService> services =
//       await dispositivo.discoverServices();
//       for (ble.BluetoothService s in services) {
//         if (s.uuid.toString() == comun.serviciouuid) {
//           //buscar caracteristicas
//           var characteristics = s.characteristics;
//           bool tengoleer = false;
//           for (ble.BluetoothCharacteristic car in characteristics) {
//             if (car.uuid.toString() == comun.escribiruuid ||
//                 car.uuid.toString() == comun.escribiruuid5) {
//               mciescribir = car;
//             }
//             if (car.uuid.toString() == comun.leeruuid ||
//                 car.uuid.toString() == comun.leeruuid5) {
//               if (car.uuid.toString() == comun.leeruuid5) {
//                 esv5 = true;
//               }
//               if (!tengoleer) {
//                 tengoleer = true;
//                 mcileer = car;
//                 mcileer.setNotifyValue(true);
//                 try {
//                   sus.cancel();
//                 } catch (e) {}
//                 sus = mcileer.lastValueStream.listen((value) {
//                   procesarlectura(Uint8List.fromList(value));
//                 });
//                 conn = dispositivo.connectionState.listen((state) async {
//                   if (state == ble.BluetoothConnectionState.disconnected) {
//                     desconectar();
//                   }
//                 });
//                 estadoequipo = 1;
//                 errorvalidar = 0;
//                 rutinainicio();
//               }
//             }
//           }
//         }
//       }
//     });
//   }
//
//   Future<void> desconectar() async {
//     print('...........desconectando');
//     if (esble == 1) {
//       try {
//         dispositivo.disconnect();
//         sus.cancel();
//         conn.cancel();
//         estadoequipo = 0;
//         equipovalidado = 0;
//       } catch (e) {}
//     } else {
//       serconexion.finish();
//       estadoequipo = 0;
//       equipovalidado = 0;
//     }
//   }
//
//   Future<void> serconectar() async {
//     try {
//       serconexion = await BluetoothConnection.toAddress(macAddress);
//
//       if(serconexion.isConnected){
//         sus=serconexion.input?.listen((Uint8List data) {
//           procesarlectura(data);
//         }) as StreamSubscription;
//         sus.onDone(() {
//           desconectar();
//         });
//
//         estadoequipo = 1;
//         equipovalidado = 1;
//         rutinainicio();
//       }
//     }
//     catch (exception) {}
//   }
// /*
//   Future<void> serconectar0() async {
//     await imotionMciCom.exec('connect', macAddress);
//     Stream<Uint8List>? stream =
//         imotionMciCom.subscribeRawData(macAddress, numeromci.toString());
//     try {
//       streamSubscription = stream?.listen(onDataReceived) as StreamSubscription;
//     } catch (e) {}
//     estadoequipo = 1;
//     equipovalidado = 1;
//     rutinainicio();
//   }
// */
//   Future<void> onDataReceived(Uint8List data) async {
//     if (data.isNotEmpty) {
//       await procesarlectura(data);
//     }
//   }
//
// //----------------
//   void funcion00() {
//     bufferEscritura[0] = 0;
//     swescritura = true;
//   }
//
//   void funcion00a() {
//     if (rclave1 > 0) {
//       bufferEscritura[0] = 0;
//       bufferEscritura[1] = 1;
//       bufferEscritura[2] = rclave1;
//       bufferEscritura[3] = rclave2;
//       bufferEscritura[4] = rclave3;
//       bufferEscritura[5] = rclave4;
//       swescritura = true;
//     }
//   }
//
//   void funcion00b() {
//     //poner a cero los canales
//     bufferEscritura[0] = 24;
//     bufferEscritura[1] = 0;
//     swescritura = true;
//   }
//
//   void funcion02() {
//     //FUN_GET_CONTADOR
//     bufferEscritura[0] = 2;
//     swescritura = true;
//   }
//
//   void funcion12() {
//     //FUN_GET_CONTADOR
//     bufferEscritura[0] = 12;
//     swescritura = true;
//   }
//
//   void funcion14a() {
//     //renovar tiempo
//     int t1 = comun.segundosrenovacion ~/ 65536;
//     int t2 = (comun.segundosrenovacion - t1 * 65536) ~/ 256;
//     int t3 = comun.segundosrenovacion - t1 * 65536 - t2 * 256;
//
//     bufferEscritura[0] = 14;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 0;
//     bufferEscritura[3] = 1;
//     bufferEscritura[4] = 1;
//     bufferEscritura[9] = 0;
//     bufferEscritura[10] = t1;
//     bufferEscritura[11] = t2;
//     bufferEscritura[12] = t3;
//     swescritura = true;
//   }
//
//   void funcion14b() {
//     //desbloquear tiempo
//
//     bufferEscritura[0] = 14;
//     bufferEscritura[1] = 1;
//     bufferEscritura[2] = 0;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion220() {
//     //a cero canal cero
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 0;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion221() {
//     //a cero canal 1
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 1;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion222() {
//     //a cero canal 2
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 2;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion223() {
//     //a cero canal 3
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 3;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion224() {
//     //a cero canal 4
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 4;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion225() {
//     //a cero canal 5
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 5;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion226() {
//     //a cero canal 6
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 6;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion227() {
//     //a cero canal 7
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 7;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion228() {
//     //a cero canal 8
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 8;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion229() {
//     //a cero canal 9
//
//     bufferEscritura[0] = 22;
//     bufferEscritura[1] = 0;
//     bufferEscritura[2] = 9;
//     bufferEscritura[3] = 0;
//     bufferEscritura[4] = 0;
//     swescritura = true;
//   }
//
//   void funcion261() {
//     //apagar
//     if (esv5) {
//       bufferEscritura[0] = 26;
//       bufferEscritura[1] = 102;
//       bufferEscritura[2] = 1;
//       swescritura = true;
//     }
//   }
//
//   void funcion28() {
//     //FUN_GET_MEM
//     bufferEscritura[0] = 28;
//     swescritura = true;
//   }
//
//   void funcion30() {
//     //FUN_SET_MEM
//     bufferEscritura[0] = 30;
//
//     bufferParam[2] = comun.intparse(fechasemana.substring(4));
//     bufferParam[3] = comun.intparse(fechasemana.substring(2, 4));
//     bufferParam[4] = comun.intparse(fechasemana.substring(0, 2));
//     bufferParam[5] = cta;
//     bufferParam[6] = ctb;
//     bufferParam[7] = ctc;
//     bufferParam[8] = ctd;
//
//     swescritura = true;
//   }
//
//   void funcion87() {
//     //PROTO_F_READ_INFO
//     if (!esv5) {
//       bufferEscritura[1] = 87;
//     } else {
//       // 2 info
//       bufferEscritura[0] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion89() {
//     //PROTO_F_READ_BAT
//     if (!esv5) {
//       bufferEscritura[1] = 89;
//     } else {
//       // 8 get parametros batería
//       bufferEscritura[0] = 8;
//       swescritura = true;
//     }
//   }
//
//   void funcion91() {
//     //PROTO_F_WRITE_INFO
//     //tarifa=0
//     if (!esv5) {
//       bufferEscritura[1] = 91;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = comun.intparse(elev1);
//       bufferEscritura[5] = comun.intparse(elev2);
//       bufferEscritura[6] = comun.intparse(xmac1);
//       bufferEscritura[7] = comun.intparse(xmac2);
//       bufferEscritura[8] = comun.intparse(xmac3);
//       bufferEscritura[9] = comun.intparse(xmac4);
//       bufferEscritura[10] = comun.intparse(xmac5);
//       bufferEscritura[11] = comun.intparse(xmac6);
//       bufferEscritura[12] = comun.intparse(xmac7);
//       bufferEscritura[13] = comun.intparse(xmac8);
//       bufferEscritura[14] = comun.intparse(xmac9);
//       bufferEscritura[15] = comun.intparse(xmac10);
//       bufferEscritura[16] = comun.intparse(xmac11);
//       bufferEscritura[17] = comun.intparse(xmac12);
//       bufferEscritura[18] = lica;
//       bufferEscritura[19] = licb;
//       bufferEscritura[20] = licc;
//       bufferEscritura[21] = licd;
//     } else {
//       // 14 set contador tarifa -desbloqueo-
//       bufferEscritura[0] = 14;
//       bufferEscritura[1] = 1;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       bufferEscritura[5] = 0;
//       bufferEscritura[6] = 0;
//       bufferEscritura[7] = 0;
//       bufferEscritura[8] = 0;
//       bufferEscritura[9] = 0;
//       bufferEscritura[10] = 0;
//       bufferEscritura[11] = 0;
//       bufferEscritura[12] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion91b() {
//     //PROTO_F_WRITE_INFO
//     //tarifa =1
//     if (!esv5) {
//       bufferEscritura[1] = 91;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 1;
//       bufferEscritura[4] = comun.intparse(elev1);
//       bufferEscritura[5] = comun.intparse(elev2);
//       bufferEscritura[6] = comun.intparse(xmac1);
//       bufferEscritura[7] = comun.intparse(xmac2);
//       bufferEscritura[8] = comun.intparse(xmac3);
//       bufferEscritura[9] = comun.intparse(xmac4);
//       bufferEscritura[10] = comun.intparse(xmac5);
//       bufferEscritura[11] = comun.intparse(xmac6);
//       bufferEscritura[12] = comun.intparse(xmac7);
//       bufferEscritura[13] = comun.intparse(xmac8);
//       bufferEscritura[14] = comun.intparse(xmac9);
//       bufferEscritura[15] = comun.intparse(xmac10);
//       bufferEscritura[16] = comun.intparse(xmac11);
//       bufferEscritura[17] = comun.intparse(xmac12);
//       bufferEscritura[18] = lica;
//       bufferEscritura[19] = licb;
//       bufferEscritura[20] = licc;
//       bufferEscritura[21] = licd;
//     }
//   }
//
//   void funcion99() {
//     //PROTO_F_WRITE_CP
//     int t1 = comun.segundosrenovacion ~/ 65536;
//     int t2 = (comun.segundosrenovacion - t1 * 65536) ~/ 256;
//     int t3 = comun.segundosrenovacion - t1 * 65536 - t2 * 256;
//     if (!esv5) {
//       bufferEscritura[1] = 99;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = t1;
//       bufferEscritura[4] = t2;
//       bufferEscritura[5] = t3;
//       bufferEscritura[6] = lica;
//       bufferEscritura[7] = licb;
//       bufferEscritura[8] = licc;
//       bufferEscritura[9] = licd;
//     } else {
//       // 14 set contador tarifa -recarga tiempo-
//       bufferEscritura[0] = 14;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 1;
//       bufferEscritura[4] = 1;
//       bufferEscritura[5] = 0;
//       bufferEscritura[6] = 0;
//       bufferEscritura[7] = 0;
//       bufferEscritura[8] = 0;
//       bufferEscritura[9] = 0;
//       bufferEscritura[10] = t1;
//       bufferEscritura[11] = t2;
//       bufferEscritura[12] = t3;
//       swescritura = true;
//     }
//   }
//
//   void funcion99b() {
//     //PROTO_F_WRITE_CP
//     // poner solo 100 segundos
//     int t1 = 0;
//     int t2 = 0;
//     int t3 = 100;
//     if (!esv5) {
//       bufferEscritura[1] = 99;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = t1;
//       bufferEscritura[4] = t2;
//       bufferEscritura[5] = t3;
//       bufferEscritura[6] = lica;
//       bufferEscritura[7] = licb;
//       bufferEscritura[8] = licc;
//       bufferEscritura[9] = licd;
//     } else {
//       // 14 set contador tarifa -recarga tiempo-
//       bufferEscritura[0] = 14;
//       bufferEscritura[1] = 1;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 1;
//       bufferEscritura[4] = 1;
//       bufferEscritura[5] = 0;
//       bufferEscritura[6] = 0;
//       bufferEscritura[7] = 0;
//       bufferEscritura[8] = 0;
//       bufferEscritura[9] = 0;
//       bufferEscritura[10] = t1;
//       bufferEscritura[11] = t2;
//       bufferEscritura[12] = t3;
//       swescritura = true;
//     }
//   }
//
//   void funcion101() {
//     //PROTO_F_ESTADO_TOT
//     if (!esv5) {
//       bufferEscritura[1] = 101;
//     } else {
//       // 2 info
//       bufferEscritura[0] = 16;
//       bufferEscritura[2] = 0;
//
//       swescritura = true;
//     }
//   }
//
//   void funcion105() {
//     //PROTO_F_estado bat
//     if (!esv5) {
//       bufferEscritura[1] = 105;
//     } else {
//       // 2 info
//       bufferEscritura[0] = 16;
//       bufferEscritura[2] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion107() {
//     //PROTO_F_RUN_TOT
//     if (!esv5) {
//       if ((pulso > 0) && (cicloElegido == 0)) {
//         //no cronaxie ni ciclo
//         for (int xx = 1; xx < 10; xx++) {
//           chciclo[xx - 1] = true;
//         }
//         bufferEscritura[1] = 107;
//         bufferEscritura[2] = 0;
//         bufferEscritura[3] = rampa;
//         bufferEscritura[4] = 0;
//         bufferEscritura[5] = 0;
//         bufferEscritura[6] = 0;
//         bufferEscritura[7] = frecuencia;
//         doblenum(8, pulso);
//         bufferEscritura[10] = 0;
//         bufferEscritura[11] = 0;
//         bufferEscritura[12] = 0;
//         bufferEscritura[13] = 85;
//         if (escudo) {
//           bufferEscritura[13] = 0;
//         }
//       } else {
//         //si cronaxie o ciclo
//         if (cicloElegido == 0) {
//           for (int xx = 1; xx < 10; xx++) {
//             chciclo[xx - 1] = true;
//           }
//         } else {
//           ci = comun.ciciclo[cicloElegido].split(':');
//           indiceCiclo++;
//           if (indiceCiclo > (ci.length - 1)) indiceCiclo = 0;
//           if (ci[indiceCiclo] == '') indiceCiclo = 0;
//           for (int xx = 1; xx < 10; xx++) {
//             if (ci[indiceCiclo].contains(xx.toString())) {
//               chciclo[xx - 1] = true;
//             } else {
//               chciclo[xx - 1] = false;
//             }
//           }
//         }
//         bufferEscritura[1] = 145;
//         bufferEscritura[2] = 0;
//         bufferEscritura[3] = rampa;
//         bufferEscritura[4] = 0;
//         bufferEscritura[5] = 0;
//         bufferEscritura[6] = 0;
//         bufferEscritura[7] = frecuencia;
//         List<String> cr = comun.prcronaxie[numeroprograma].split('-');
//
//         for (int x = 0; x < 10; x++) {
//           if (chciclo[x] && chconectado[x]) {
//             doblenum(8 + x + x, pulso > 0 ? pulso : comun.intparse(cr[x]));
//           } else {
//             doblenum(8 + x + x, 0);
//           }
//         }
//         bufferEscritura[28] = 85;
//         if (escudo) {
//           bufferEscritura[28] = 0;
//         }
//       }
//       if (escudo) anadirtolva('138e');
//     } else {
//       //18 RUN sesión electroestimulación
//       bufferEscritura[0] = 18;
//       bufferEscritura[1] = 0;
//       if (escudo) bufferEscritura[2] = 1;
//       bufferEscritura[3] = rampa;
//       bufferEscritura[4] = frecuencia;
//       bufferEscritura[5] = 0;
//       bufferEscritura[6] = 255;
//       if ((pulso > 0) && (cicloElegido == 0)) {
//         //no cronaxie ni ciclo
//         bufferEscritura[7] = pulso ~/ 5;
//       } else {
//         //cronaxie o ciclo
//         if (cicloElegido == 0) {
//           for (int xx = 1; xx < 10; xx++) {
//             chciclo[xx - 1] = true;
//           }
//         } else {
//           ci = comun.ciciclo[cicloElegido].split(':');
//           indiceCiclo++;
//           if (indiceCiclo > (ci.length - 1)) indiceCiclo = 0;
//           if (ci[indiceCiclo] == '') indiceCiclo = 0;
//           for (int xx = 1; xx < 10; xx++) {
//             if (ci[indiceCiclo].contains(xx.toString())) {
//               chciclo[xx - 1] = true;
//             } else {
//               chciclo[xx - 1] = false;
//             }
//           }
//         }
//         List<String> cr = comun.prcronaxie[numeroprograma].split('-');
//
//         for (int x = 0; x < 10; x++) {
//           if (chciclo[x] && chconectado[x]) {
//             bufferEscritura[8 + x] =
//             pulso > 0 ? (pulso ~/ 5) : comun.intparse(cr[x]) ~/ 5;
//           }
//         }
//       }
//       swescritura = true;
//     }
//   }
//
//   void funcion109() {
//     //PROTO_F_STOP
//     anadiractividad('04', '');
//     if (!esv5) {
//       bufferEscritura[1] = 109;
//     } else {
//       bufferEscritura[0] = 20;
//       bufferEscritura[1] = 0;
//       swescritura = true;
//     }
//     // comun.beeplargo();
//     // if (comun.swvideo) {
//     //   comun.vpc.dispose();
//     //   comun.swvideo = false;
//     // }
//     estadoequipo = 1;
//   }
//
//   void funcion109a() {
//     //PROTO_F_STOP -fin sesion b-
//     escribiractividad();
//     inicializarequipo();
//     if (esv5) {
//       anadirtolva('00b');
//     }
//   }
//
//   void funcion109b() {
//     //PROTO_F_STOP sin pitido
//     anadiractividad('04', '');
//     if (!esv5) {
//       bufferEscritura[1] = 109;
//     } else {
//       bufferEscritura[0] = 20;
//       bufferEscritura[1] = 0;
//       swescritura = true;
//     }
//     if (comun.swvideo) {
//       // comun.vpc.dispose();
//       comun.swvideo = false;
//     }
//   }
//
//   void funcion109c() {
//     //desconectar
//     desconectar();
//   }
//
//   void funcion110() {
//     //PROTO_F_PAUSE
//     if (!esv5) {
//       if (!pausaactiva || estadoequipo == 2) {
//         //pausa pasiva
//         bufferEscritura[1] = 110;
//       } else {
//         //pausa activa
//         bufferEscritura[1] = 107;
//         bufferEscritura[2] = 0;
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = 0;
//         bufferEscritura[5] = 0;
//         bufferEscritura[6] = 0;
//         bufferEscritura[7] = 10;
//         doblenum(8, 350);
//         bufferEscritura[10] = 0;
//         bufferEscritura[11] = 0;
//         bufferEscritura[12] = 0;
//         bufferEscritura[13] = 85;
//         if (escudo) {
//           bufferEscritura[13] = 0;
//         }
//       }
//       if (escudo) anadirtolva('138e');
//     } else {
//       if (!pausaactiva || estadoequipo == 2) {
//         //pausa pasiva
//         bufferEscritura[0] = 20;
//         bufferEscritura[1] = 0;
//       } else {
//         //pausa activa
//         bufferEscritura[0] = 18;
//         bufferEscritura[1] = 0;
//         if (escudo) bufferEscritura[2] = 1;
//         bufferEscritura[3] = 0;
//         bufferEscritura[4] = 10;
//         bufferEscritura[5] = 0;
//         bufferEscritura[6] = 255;
//         bufferEscritura[7] = 70;
//       }
//       swescritura = true;
//     }
//   }
//
//   void funcion111() {
//     //PROTO_F_SETCH
//     if (!esv5) {
//       bufferEscritura[1] = 111;
//       bufferEscritura[2] = (chconectado[0]) ? 1 : ch[0];
//       bufferEscritura[3] = (chconectado[1]) ? 1 : ch[1];
//       bufferEscritura[4] = (chconectado[2]) ? 1 : ch[2];
//       bufferEscritura[5] = (chconectado[3]) ? 1 : ch[3];
//       bufferEscritura[6] = (chconectado[4]) ? 1 : ch[4];
//       bufferEscritura[7] = (chconectado[5]) ? 1 : ch[5];
//       bufferEscritura[8] = (chconectado[6]) ? 1 : ch[6];
//       bufferEscritura[9] = (chconectado[7]) ? 1 : ch[7];
//       bufferEscritura[10] = (chconectado[8]) ? 1 : ch[8];
//       bufferEscritura[11] = (chconectado[9]) ? 1 : ch[9];
//     }
//   }
//
//   void funcion114() {
//     //PROTO_F_BACKDOOR
//     if (!esv5) {
//       bufferEscritura[1] = 114;
//     }
//   }
//
//   void funcion118() {
//     //PROTO_F_X_ch1
//     anadiractividad('11', subirbajar[0].toString());
//
//     if (!esv5) {
//       bufferEscritura[1] = 118;
//       bufferEscritura[2] = (100 + subirbajar[0]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 0;
//
//       if (subirbajar[0] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[0] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[0] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[0] = 0;
//   }
//
//   void funcion1180() {
//     //PROTO_F_X_ch1 poner a cero
//     anadiractividad('11', '0');
//
//     if (!esv5) {
//       bufferEscritura[1] = 118;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1181() {
//     //PROTO_F_X_ch1 iniciales
//     ch[0] = ch0[0];
//     anadiractividad('11', ch[0].toString());
//
//     if (!esv5) {
//       bufferEscritura[1] = 118;
//       bufferEscritura[2] = (100 + ch[0]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[0];
//       swescritura = true;
//     }
//   }
//
//   void funcion119() {
//     //PROTO_F_X_ch2
//     anadiractividad('12', subirbajar[1].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 119;
//       bufferEscritura[2] = (100 + subirbajar[1]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 1;
//
//       if (subirbajar[1] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[1] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[1] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[1] = 0;
//   }
//
//   void funcion1190() {
//     //PROTO_F_X_ch2 a cero
//     anadiractividad('12', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 119;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 1;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1191() {
//     //PROTO_F_X_ch2 inicial
//     ch[1] = ch0[1];
//     anadiractividad('12', ch[1].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 119;
//       bufferEscritura[2] = (100 + ch[1]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 1;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[1];
//       swescritura = true;
//     }
//   }
//
//   void funcion120() {
//     //PROTO_F_X_ch3
//     anadiractividad('13', subirbajar[2].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 120;
//       bufferEscritura[2] = (100 + subirbajar[2]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 2;
//
//       if (subirbajar[2] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[2] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[2] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[2] = 0;
//   }
//
//   void funcion1200() {
//     //PROTO_F_X_ch3 a cero
//     anadiractividad('13', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 120;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 2;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1201() {
//     //PROTO_F_X_ch3 inicial
//     ch[2] = ch0[2];
//     anadiractividad('13', ch[2].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 120;
//       bufferEscritura[2] = (100 + ch[2]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 2;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[2];
//       swescritura = true;
//     }
//   }
//
//   void funcion121() {
//     //PROTO_F_X_ch4
//     anadiractividad('14', subirbajar[3].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 121;
//       bufferEscritura[2] = (100 + subirbajar[3]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 3;
//
//       if (subirbajar[3] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[3] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[3] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[3] = 0;
//   }
//
//   void funcion1210() {
//     //PROTO_F_X_ch4 a cero
//     anadiractividad('14', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 121;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 3;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1211() {
//     //PROTO_F_X_ch4 inicial
//     ch[3] = ch0[3];
//     anadiractividad('14', ch[3].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 121;
//       bufferEscritura[2] = (100 + ch[3]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 3;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[3];
//       swescritura = true;
//     }
//   }
//
//   void funcion122() {
//     //PROTO_F_X_ch5
//     anadiractividad('15', subirbajar[4].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 122;
//       bufferEscritura[2] = (100 + subirbajar[4]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 4;
//
//       if (subirbajar[4] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[4] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[4] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[4] = 0;
//   }
//
//   void funcion1220() {
//     //PROTO_F_X_ch5 a cero
//     anadiractividad('15', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 122;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 4;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1221() {
//     //PROTO_F_X_ch5 inicial
//     ch[4] = ch0[4];
//     anadiractividad('15', ch[4].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 122;
//       bufferEscritura[2] = (100 + ch[4]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 4;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[4];
//       swescritura = true;
//     }
//   }
//
//   void funcion123() {
//     //PROTO_F_X_ch6
//     anadiractividad('16', subirbajar[5].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 123;
//       bufferEscritura[2] = (100 + subirbajar[5]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 5;
//
//       if (subirbajar[5] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[5] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[5] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[5] = 0;
//   }
//
//   void funcion1230() {
//     //PROTO_F_X_ch6 a cero
//     anadiractividad('16', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 123;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 5;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1231() {
//     //PROTO_F_X_ch6 inicial
//     ch[5] = ch0[5];
//     anadiractividad('16', ch[5].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 123;
//       bufferEscritura[2] = (100 + ch[5]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 5;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[5];
//       swescritura = true;
//     }
//   }
//
//   void funcion124() {
//     //PROTO_F_X_ch7
//     anadiractividad('17', subirbajar[6].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 124;
//       bufferEscritura[2] = (100 + subirbajar[6]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 6;
//
//       if (subirbajar[6] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[6] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[6] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[6] = 0;
//   }
//
//   void funcion1240() {
//     //PROTO_F_X_ch7 a cero
//     anadiractividad('17', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 124;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 6;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1241() {
//     //PROTO_F_X_ch7 inicial
//     ch[6] = ch0[6];
//     anadiractividad('17', ch[6].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 124;
//       bufferEscritura[2] = (100 + ch[6]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 6;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[6];
//       swescritura = true;
//     }
//   }
//
//   void funcion125() {
//     //PROTO_F_X_ch8
//     anadiractividad('18', subirbajar[7].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 125;
//       bufferEscritura[2] = (100 + subirbajar[7]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 7;
//
//       if (subirbajar[7] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[7] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[7] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[7] = 0;
//   }
//
//   void funcion1250() {
//     //PROTO_F_X_ch8 a cero
//     anadiractividad('18', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 125;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 7;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1251() {
//     //PROTO_F_X_ch8 inicial
//     ch[7] = ch0[7];
//     anadiractividad('18', ch[7].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 125;
//       bufferEscritura[2] = (100 + ch[7]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 7;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[7];
//       swescritura = true;
//     }
//   }
//
//   void funcion126() {
//     //PROTO_F_X_ch9
//     anadiractividad('19', subirbajar[8].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 126;
//       bufferEscritura[2] = (100 + subirbajar[8]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 8;
//
//       if (subirbajar[8] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[8] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[8] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[8] = 0;
//   }
//
//   void funcion1260() {
//     //PROTO_F_X_ch9 a cero
//     anadiractividad('19', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 126;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 8;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1261() {
//     //PROTO_F_X_ch9 inicial
//     ch[8] = ch0[8];
//     anadiractividad('19', ch[8].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 126;
//       bufferEscritura[2] = (100 + ch[8]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 8;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[8];
//       swescritura = true;
//     }
//   }
//
//   void funcion127() {
//     //PROTO_F_X_ch10
//     anadiractividad('20', subirbajar[9].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 127;
//       bufferEscritura[2] = (100 + subirbajar[9]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 9;
//
//       if (subirbajar[9] > 0) {
//         bufferEscritura[3] = 1;
//         bufferEscritura[4] = subirbajar[9] ~/ 2;
//       } else {
//         bufferEscritura[3] = 2;
//         bufferEscritura[4] = -subirbajar[9] ~/ 2;
//       }
//       swescritura = true;
//     }
//     subirbajar[9] = 0;
//   }
//
//   void funcion1270() {
//     //PROTO_F_X_ch10 a cero
//     anadiractividad('20', '0');
//     if (!esv5) {
//       bufferEscritura[1] = 127;
//       bufferEscritura[2] = 0;
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 9;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion1271() {
//     //PROTO_F_X_ch10 inicial
//     ch[9] = ch0[9];
//     anadiractividad('20', ch[9].toString());
//     if (!esv5) {
//       bufferEscritura[1] = 127;
//       bufferEscritura[2] = (100 + ch[9]);
//     } else {
//       bufferEscritura[0] = 22;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 9;
//       bufferEscritura[3] = 0;
//       bufferEscritura[4] = ch[9];
//       swescritura = true;
//     }
//   }
//
//   void funcion138() {
//     //PROTO_F_X_TODOS
//     anadiractividad('21', subirbajarx.toString());
//
//     if (!esv5) {
//       bufferEscritura[1] = 138;
//       bufferEscritura[2] = (100 + subirbajarx);
//       int valor = 0;
//       if (!chbloqueado[9] && chconectado[9] && !chanulado[9]) valor += 2;
//       if (!chbloqueado[8] && chconectado[8] && !chanulado[8]) valor += 1;
//       bufferEscritura[3] = valor;
//       valor = 0;
//       if (!chbloqueado[7] && chconectado[7] && !chanulado[7]) valor += 128;
//       if (!chbloqueado[6] && chconectado[6] && !chanulado[6]) valor += 64;
//       if (!chbloqueado[5] && chconectado[5] && !chanulado[5]) valor += 32;
//       if (!chbloqueado[4] && chconectado[4] && !chanulado[4]) valor += 16;
//       if (!chbloqueado[3] && chconectado[3] && !chanulado[3]) valor += 8;
//       if (!chbloqueado[2] && chconectado[2] && !chanulado[2]) valor += 4;
//       if (!chbloqueado[1] && chconectado[1] && !chanulado[1]) valor += 2;
//       if (!chbloqueado[0] && chconectado[0] && !chanulado[0]) valor += 1;
//       bufferEscritura[4] = valor;
//       subirbajarx = 0;
//     } else {
//       bufferEscritura[0] = 24;
//       bufferEscritura[1] = 0;
//       if (subirbajarx > 0) {
//         bufferEscritura[2] = 1;
//       } else {
//         bufferEscritura[2] = 2;
//         subirbajarx = -subirbajarx;
//       }
//       if (!chbloqueado[0] && chconectado[0] && !chanulado[0])
//         bufferEscritura[3] = subirbajarx ~/ 2;
//       if (!chbloqueado[1] && chconectado[1] && !chanulado[1])
//         bufferEscritura[4] = subirbajarx ~/ 2;
//       if (!chbloqueado[2] && chconectado[2] && !chanulado[2])
//         bufferEscritura[5] = subirbajarx ~/ 2;
//       if (!chbloqueado[3] && chconectado[3] && !chanulado[3])
//         bufferEscritura[6] = subirbajarx ~/ 2;
//       if (!chbloqueado[4] && chconectado[4] && !chanulado[4])
//         bufferEscritura[7] = subirbajarx ~/ 2;
//       if (!chbloqueado[5] && chconectado[5] && !chanulado[5])
//         bufferEscritura[8] = subirbajarx ~/ 2;
//       if (!chbloqueado[6] && chconectado[6] && !chanulado[6])
//         bufferEscritura[9] = subirbajarx ~/ 2;
//       if (!chbloqueado[7] && chconectado[7] && !chanulado[7])
//         bufferEscritura[10] = subirbajarx ~/ 2;
//       if (!chbloqueado[8] && chconectado[8] && !chanulado[8])
//         bufferEscritura[11] = subirbajarx ~/ 2;
//       if (!chbloqueado[9] && chconectado[9] && !chanulado[9])
//         bufferEscritura[12] = subirbajarx ~/ 2;
//
//       subirbajarx = 0;
//       swescritura = true;
//     }
//   }
//
//   void funcion138e() {
//     //PROTO_F_X_TODOS -leer niveles -
//     if (!esv5) {
//       bufferEscritura[1] = 138;
//       bufferEscritura[2] = 100;
//       bufferEscritura[3] = 3;
//       bufferEscritura[4] = 255;
//     } else {
//       bufferEscritura[0] = 24;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 3;
//       swescritura = true;
//     }
//   }
//
//   void funcion138f() {
//     //PROTO_F_X_TODOS -ajuste cambio frecuencia-
//     int valor = 0;
//     if (compensacionfrecuencia != 0) {
//       anadiractividad('21', compensacionfrecuencia.toString());
//       if (!esv5) {
//         bufferEscritura[1] = 138;
//         bufferEscritura[2] = (100 + 2 * compensacionfrecuencia);
//         if (!chbloqueado[9] && chconectado[9]) valor += 2;
//         if (!chbloqueado[8] && chconectado[8]) valor += 1;
//         bufferEscritura[3] = valor;
//         valor = 0;
//         if (!chbloqueado[7] && chconectado[7]) valor += 128;
//         if (!chbloqueado[6] && chconectado[6]) valor += 64;
//         if (!chbloqueado[5] && chconectado[5]) valor += 32;
//         if (!chbloqueado[4] && chconectado[4]) valor += 16;
//         if (!chbloqueado[3] && chconectado[3]) valor += 8;
//         if (!chbloqueado[2] && chconectado[2]) valor += 4;
//         if (!chbloqueado[1] && chconectado[1]) valor += 2;
//         if (!chbloqueado[0] && chconectado[0]) valor += 1;
//         bufferEscritura[4] = valor;
//       } else {
//         bufferEscritura[0] = 24;
//         bufferEscritura[1] = 0;
//         if (compensacionfrecuencia < 0) {
//           bufferEscritura[2] = 2;
//           valor = -compensacionfrecuencia;
//         } else {
//           bufferEscritura[2] = 1;
//           valor = compensacionfrecuencia;
//         }
//         if (!chbloqueado[0] && chconectado[0]) {
//           bufferEscritura[3] = valor;
//         }
//         if (!chbloqueado[1] && chconectado[1]) {
//           bufferEscritura[4] = valor;
//         }
//         if (!chbloqueado[2] && chconectado[2]) {
//           bufferEscritura[5] = valor;
//         }
//         if (!chbloqueado[3] && chconectado[3]) {
//           bufferEscritura[6] = valor;
//         }
//         if (!chbloqueado[4] && chconectado[4]) {
//           bufferEscritura[7] = valor;
//         }
//         if (!chbloqueado[5] && chconectado[5]) {
//           bufferEscritura[8] = valor;
//         }
//         if (!chbloqueado[6] && chconectado[6]) {
//           bufferEscritura[9] = valor;
//         }
//         if (!chbloqueado[7] && chconectado[7]) {
//           bufferEscritura[10] = valor;
//         }
//         if (!chbloqueado[8] && chconectado[8]) {
//           bufferEscritura[11] = valor;
//         }
//         if (!chbloqueado[9] && chconectado[9]) {
//           bufferEscritura[12] = valor;
//         }
//         swescritura = true;
//       }
//     }
//   }
//
//   void funcion138p() {
//     //PROTO_F_X_TODOS -ajuste cambio programa-
//     int valor = 0;
//     if (piajuste != 0) {
//       anadiractividad('21', piajuste.toString());
//       if (!esv5) {
//         bufferEscritura[1] = 138;
//         bufferEscritura[2] = (100 + piajuste);
//         if (!chbloqueado[9] && chconectado[9]) valor += 2;
//         if (!chbloqueado[8] && chconectado[8]) valor += 1;
//         bufferEscritura[3] = valor;
//         valor = 0;
//         if (!chbloqueado[7] && chconectado[7]) valor += 128;
//         if (!chbloqueado[6] && chconectado[6]) valor += 64;
//         if (!chbloqueado[5] && chconectado[5]) valor += 32;
//         if (!chbloqueado[4] && chconectado[4]) valor += 16;
//         if (!chbloqueado[3] && chconectado[3]) valor += 8;
//         if (!chbloqueado[2] && chconectado[2]) valor += 4;
//         if (!chbloqueado[1] && chconectado[1]) valor += 2;
//         if (!chbloqueado[0] && chconectado[0]) valor += 1;
//         bufferEscritura[4] = valor;
//       } else {
//         bufferEscritura[0] = 24;
//         bufferEscritura[1] = 0;
//         if (piajuste < 0) {
//           bufferEscritura[2] = 2;
//           valor = -piajuste ~/ 2;
//         } else {
//           bufferEscritura[2] = 1;
//           valor = piajuste ~/ 2;
//         }
//         if (!chbloqueado[0] && chconectado[0]) {
//           bufferEscritura[3] = valor;
//         }
//         if (!chbloqueado[1] && chconectado[1]) {
//           bufferEscritura[4] = valor;
//         }
//         if (!chbloqueado[2] && chconectado[2]) {
//           bufferEscritura[5] = valor;
//         }
//         if (!chbloqueado[3] && chconectado[3]) {
//           bufferEscritura[6] = valor;
//         }
//         if (!chbloqueado[4] && chconectado[4]) {
//           bufferEscritura[7] = valor;
//         }
//         if (!chbloqueado[5] && chconectado[5]) {
//           bufferEscritura[8] = valor;
//         }
//         if (!chbloqueado[6] && chconectado[6]) {
//           bufferEscritura[9] = valor;
//         }
//         if (!chbloqueado[7] && chconectado[7]) {
//           bufferEscritura[10] = valor;
//         }
//         if (!chbloqueado[8] && chconectado[8]) {
//           bufferEscritura[11] = valor;
//         }
//         if (!chbloqueado[9] && chconectado[9]) {
//           bufferEscritura[12] = valor;
//         }
//         swescritura = true;
//       }
//     }
//   }
//
//   void funcion138r() {
//     //PROTO_F_X_TODOS -reset -
//     anadiractividad('21', '-100');
//     if (!esv5) {
//       bufferEscritura[1] = 138;
//       bufferEscritura[2] = 0;
//       bufferEscritura[3] = 3;
//       bufferEscritura[4] = 255;
//     } else {
//       bufferEscritura[0] = 24;
//       bufferEscritura[1] = 0;
//       bufferEscritura[2] = 0;
//       swescritura = true;
//     }
//   }
//
//   void reset() {
//     rutinafindesesion();
//     anadiractividad('03', '');
//   }
//
//   bool controlsemana() {
//     //controlar sesiones semana
//     bool grabarfecha = false;
//     permiso = true;
//     if (comun.limitesemana > 0) {
//       if (verhw == '4') {
//         permiso = false;
//         DateTime f = DateTime.now();
//         int d = f.weekday;
//         if (d > 1) {
//           f = f.subtract(Duration(days: (d - 1)));
//         }
//         List<String> f1 = f.toString().split(' ');
//         List<String> f2 = f1[0].toString().split('-');
//         fechasemana = "${f2[0].substring(2)}${f2[1]}${f2[2]}";
//
//         if (ctao == 0) {
//           //no hay grabado
//           permiso = true;
//           grabarfecha = true;
//         } else {
//           //hay grabado
//           DateTime f = DateTime(2000 + ctao, ctmes, ctdia);
//           List<String> f1 = f.toString().split(' ');
//           List<String> f2 = f1[0].toString().split('-');
//           fechamci = "${f2[0].substring(2)}${f2[1]}${f2[2]}";
//
//           if (fechasemana != fechamci) {
//             //semanas distintas
//             permiso = true;
//             grabarfecha = true;
//           } else {
//             //misma semana
//             tiempograbado = ct1 * 16777216 + ct2 * 65556 + ct3 * 256 + ct4;
//             int tiempomci = cta * 16777216 + ctb * 65556 + ctc * 256 + ctd;
//             if ((tiempomci - tiempograbado) > comun.limitesemana) {
//               //limite alcanzado
//               permiso = false;
//             } else {
//               //limite no alcanzado
//               permiso = true;
//             }
//           }
//         }
//       }
//     }
//     return grabarfecha;
//   }
//
//   int longitudfuncion(int funcion) {
//     //DE 87 A 167
//     List<int> longitud = [
//       0,
//       32,
//       0,
//       9,
//       21,
//       1,
//       0,
//       4,
//       10,
//       1,
//       8,
//       1,
//       8,
//       1,
//       0,
//       28,
//       0,
//       0,
//       0,
//       4,
//       12,
//       0,
//       0,
//       0,
//       10,
//       0,
//       46,
//       0,
//       8,
//       0,
//       0,
//       1,
//       1,
//       1,
//       1,
//       1,
//       1,
//       1,
//       1,
//       1,
//       1,
//       2,
//       2,
//       2,
//       2,
//       2,
//       2,
//       2,
//       2,
//       2,
//       2,
//       3,
//       12,
//       1,
//       0,
//       1,
//       1,
//       2,
//       27,
//       1,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       0,
//       101,
//       1,
//       1,
//       101,
//       0,
//       0,
//       1
//     ];
//
//     if ((funcion > 86) & (funcion < 168)) {
//       return longitud[funcion - 87] + 2;
//     } else {
//       return 0;
//     }
//   }
//
//   void doblenum(int posicion, int valor) {
//     int resto = valor % 256;
//     bufferEscritura[posicion] = ((valor - resto) ~/ 256);
//     bufferEscritura[posicion + 1] = resto;
//   }
//
//   void calculartiempo() {
//     int ti = 0;
//     if (estadoequipo < 2) ti = comun.duracionsesion;
//     if (estadoequipo == 2) ti = tiempoParada;
//     if (estadoequipo == 3)
//       ti = comun.duracionsesion + pausaAcumulada - (comun.hora - tiempoInicio);
//
//     int min = ti ~/ 60;
//     int seg = ti - min * 60;
//     String min2 = '0$min';
//     min2 = min2.substring(min2.length - 2);
//     String seg2 = '0$seg';
//     seg2 = seg2.substring(seg2.length - 2);
//
//     lbtiempo = '$min2:$seg2';
//     arcotiempo = ti;
//   }
//
//   void calcularpuntos() {
//     int pfrec, pcontr, punt;
//
//     if(pesocliente==0){
//       pesocliente=75;
//     }
//
//     int pr;
//     if (tipoprograma == 2) {
//       pr = numeroprograma;
//     } else {
//       pr = piprograma;
//     }
//
//     if (pr>-1) {
//       if (frecuencia < 75) {
//         pfrec = frecuencia;
//       } else {
//         pfrec = 160 - frecuencia;
//       }
//       if (pfrec < 10) pfrec = 10;
//
//       if (pausa == 0) {
//         //sin contraccion-pausa
//         pcontr = 5;
//       } else {
//         //con contraccion-pausa
//         pcontr = contraccion;
//       }
//
//       punt = 0;
//       int coefv5 = 1;
//       if (esv5) {
//         coefv5 = 2;
//       }
//       if (pulso > 0) {
//         //no cronaxie
//         for (int x = 0; x < 10; x++) {
//           punt += comun.peso[x + 1] * ch[x] * coefv5;
//         }
//         punt *= pfrec * calculapulso(pulso) * pcontr;
//       } else {
//         //cronaxie
//         List<String> cr = comun.prcronaxie[pr].split('-');
//         for (int x = 0; x < 10; x++) {
//           punt += calculapulso(comun.intparse(cr[x])) *
//               comun.peso[x + 1] *
//               ch[x] *
//               coefv5;
//         }
//         punt *= pfrec * pcontr;
//       }
//       puntos0 += punt;
//       puntos = puntos0 ~/ 245000000;
//       ekcal = calcularekcal(puntos, pesocliente);
//     }
//   }
//
//   int calculapulso(int a) {
//     int b = 4 * a ~/ 35 + 49;
//     return b;
//   }
//
//   int calcularekcal(int punt, int peso) {
//     int ek = 0;
//     if (peso > 0) {
//       ek = ((punt * punt / 1000 + 2.3 * punt) *
//           comun.coefekcal *
//           (1 - (100 - peso) / 300))
//           .toInt();
//     }
//     return ek;
//   }
//
//   void calcularmedia() {
//     mediach =
//         ch[0] + ch[1] + ch[2] + ch[3] + ch[4] + ch[5] + ch[6] + ch[7] + ch[8];
//     if (esv5) {
//       mediach = mediach ~/ 9;
//     } else {
//       mediach = mediach ~/ 18;
//     }
//   }
//
//   void anadiractividad(String fun, String valor) {
//     int seg = 0;
//     if (actividad != '') {
//       actividad += ':';
//     }
//
//     if (estadoequipo > 1) {
//       int hora = comun.leersegundos();
//       double segtr = (hora - tiempoInicio).toDouble();
//       seg = segtr.toInt();
//     }
//     actividad += '$seg.$fun.$valor';
//   }
//
//   Future<void> escribiractividad() async {
//     String fecha, dehora, ahora;
//     int nbono = bono;
//     int nbono2 = 0;
//
//     if (nbono > 0) {
//       nbono = 1;
//     }
//     if (comun.porbonos > 0) {
//       nbono2 = 1;
//     }
//     if (horaInicio != '') {
//       List<String> h1 = horaInicio.split(' ');
//       fecha = comun.fechaamd(h1[0]);
//
//       dehora = h1[1];
//
//       var horaFin = DateTime.now().toString();
//       List<String> h2 = horaFin.split(' ');
//       ahora = h2[1];
// // menos de 1 minuto
//       int de1 = comun.intparse(dehora.substring(0, 2));
//       int de2 = comun.intparse(dehora.substring(3, 5));
//       int de3 = comun.intparse(dehora.substring(6, 8));
//       int a1 = comun.intparse(ahora.substring(0, 2));
//       int a2 = comun.intparse(ahora.substring(3, 5));
//       int a3 = comun.intparse(ahora.substring(6, 8));
//
//       int segundos = (a1 - de1) * 3600 + (a2 - de2) * 60 + a3 - de3;
//       if (segundos < 60) {
//         nbono = 0;
//         nbono2 = 0;
//         comun.usubonos++;
//       }
//
//       if (comun.nivelnube < 3) {
//         String cadena =
//             "insert into actividad (cliente, entrenador, fecha, inicio, fin, clibono, usubono, sesion, puntos, ekal, nombre) values";
//         cadena +=
//         "('$cliente','$comun.numusuario','$fecha','$dehora','$ahora','$nbono',";
//         cadena += "'$nbono2','$actividad','$puntos','$ekcal','')";
//         await comun.dbase.rawQuery(cadena);
//       } else {
//         String datos = comun.encrip(
//             "13<#>$comun.licencia<#>$cliente<#>$comun.numusuario<#>$fecha<#>$dehora<#>$ahora<#>$nbono<#>$nbono2<#>$actividad<#>$puntos<#>$ekcal<#>$comun.modulo");
//         Uri url = Uri.parse("https://imotionems.es/inube3.php?a=$datos");
//         await http.get(url);
//       }
//     }
//   }
//
//   void repetirsesion() {
//     double lahora = segTranscurrido;
//     if (swrepite && estadoequipo==3) {
//       if (sigtiemporepite <= lahora) {
//         List<String> a = repitesesion.split(':');
//         List<String> b = a[idrepite].split('.');
//
//         //                    if (b[1] == '00') iniciar();
//         if (b[1] == '01') {
//           startequipo();
//         }
//         ;
//         if (b[1] == '02') {
//           startequipo();
//         }
//         ;
//         //                    if (b[1] == '03') xses.accion = 'Reset';
//         //                    if (b[1] == '04') xses.accion = 'Fin Sesión';
//
//         if (b[1] == '05') tipoprograma = 1;
//         if (b[1] == '06') {
//           List<String> cc = b[2].split('-');
//           tipoprograma = 2;
//           numeroprograma = comun.intparse(cc[0]);
//           frecuencia = comun.intparse(cc[1]);
//           pulso = comun.intparse(cc[2]);
//           rampa = comun.intparse(cc[3]);
//           contraccion = comun.intparse(cc[4]);
//           pausa = comun.intparse(cc[5]);
//           List<String> vv = comun.practivo[numeroprograma].split('-');
//           for (int x = 0; x < vv.length; x++) {
//             chconectado[x] = (vv[x] == '1');
//           }
//         }
//         if (b[1] == '07') numerointeligente = comun.intparse(b[2]);
//
//         if (b[1] == '08') cicloElegido = comun.intparse(b[2]);
//
//         if (b[1] == '09') {
//           List<String> cc = b[2].split('-');
//           for (int x = 0; x < 10; x++) {
//             cr[x] = comun.intparse(cc[x]);
//           }
//         }
//
//         if (b[1] == '11') {
//           subirbajar[0] = comun.intparse(b[2]);
//           anadirtolva('118');
//           swesperarepite = true;
//         }
//         if (b[1] == '12') {
//           subirbajar[1] = comun.intparse(b[2]);
//           anadirtolva('119');
//           swesperarepite = true;
//         }
//         if (b[1] == '13') {
//           subirbajar[2] = comun.intparse(b[2]);
//           anadirtolva('120');
//           swesperarepite = true;
//         }
//         if (b[1] == '14') {
//           subirbajar[3] = comun.intparse(b[2]);
//           anadirtolva('121');
//           swesperarepite = true;
//         }
//         if (b[1] == '15') {
//           subirbajar[4] = comun.intparse(b[2]);
//           anadirtolva('122');
//           swesperarepite = true;
//         }
//         if (b[1] == '16') {
//           subirbajar[5] = comun.intparse(b[2]);
//           anadirtolva('123');
//           swesperarepite = true;
//         }
//         if (b[1] == '17') {
//           subirbajar[6] = comun.intparse(b[2]);
//           anadirtolva('124');
//           swesperarepite = true;
//         }
//         if (b[1] == '18') {
//           subirbajar[7] = comun.intparse(b[2]);
//           anadirtolva('125');
//           swesperarepite = true;
//         }
//         if (b[1] == '19') {
//           subirbajar[8] = comun.intparse(b[2]);
//           anadirtolva('126');
//           swesperarepite = true;
//         }
//         if (b[1] == '20') {
//           subirbajar[9] = comun.intparse(b[2]);
//           anadirtolva('127');
//           swesperarepite = true;
//         }
//         if (b[1] == '21') {
//           subirbajarx += comun.intparse(b[2]);
//           anadirtolva('138');
//           swesperarepite = true;
//         }
//         if (b[1] == '22') frecuencia = comun.intparse(b[2]);
//         if (b[1] == '23') pulso = comun.intparse(b[2]);
//         if (b[1] == '24') rampa = comun.intparse(b[2]);
//         if (b[1] == '25') contraccion = comun.intparse(b[2]);
//         if (b[1] == '26') pausa = comun.intparse(b[2]);
//         if (b[1] == '28') pausaactiva = true;
//         if (b[1] == '29') pausaactiva = false;
//
//         if (b[1] == '31') chbloqueado[0] = true;
//         if (b[1] == '32') chbloqueado[1] = true;
//         if (b[1] == '33') chbloqueado[2] = true;
//         if (b[1] == '34') chbloqueado[3] = true;
//         if (b[1] == '35') chbloqueado[4] = true;
//         if (b[1] == '36') chbloqueado[5] = true;
//         if (b[1] == '37') chbloqueado[6] = true;
//         if (b[1] == '38') chbloqueado[7] = true;
//         if (b[1] == '39') chbloqueado[8] = true;
//         if (b[1] == '40') chbloqueado[9] = true;
//
//         if (b[1] == '41') chbloqueado[0] = false;
//         if (b[1] == '42') chbloqueado[1] = false;
//         if (b[1] == '43') chbloqueado[2] = false;
//         if (b[1] == '44') chbloqueado[3] = false;
//         if (b[1] == '45') chbloqueado[4] = false;
//         if (b[1] == '46') chbloqueado[5] = false;
//         if (b[1] == '47') chbloqueado[6] = false;
//         if (b[1] == '48') chbloqueado[7] = false;
//         if (b[1] == '49') chbloqueado[8] = false;
//         if (b[1] == '50') chbloqueado[9] = false;
//
//         if (b[1] == '51') {
//           chconectado[0] = false;
//           if (!esv5) {
//             subirbajar[0] = -ch[0];
//             anadirtolva('118');
//           } else {
//             anadirtolva('220');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '52') {
//           chconectado[1] = false;
//           if (!esv5) {
//             subirbajar[1] = -ch[1];
//             anadirtolva('119');
//           } else {
//             anadirtolva('221');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '53') {
//           chconectado[2] = false;
//           if (!esv5) {
//             subirbajar[2] = -ch[2];
//             anadirtolva('120');
//           } else {
//             anadirtolva('222');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '54') {
//           chconectado[3] = false;
//           if (!esv5) {
//             subirbajar[3] = -ch[3];
//             anadirtolva('121');
//           } else {
//             anadirtolva('223');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '55') {
//           chconectado[4] = false;
//           if (!esv5) {
//             subirbajar[4] = -ch[4];
//             anadirtolva('122');
//           } else {
//             anadirtolva('224');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '56') {
//           chconectado[5] = false;
//           if (!esv5) {
//             subirbajar[5] = -ch[5];
//             anadirtolva('123');
//           } else {
//             anadirtolva('225');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '57') {
//           chconectado[6] = false;
//           if (!esv5) {
//             subirbajar[6] = -ch[6];
//             anadirtolva('124');
//           } else {
//             anadirtolva('226');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '58') {
//           chconectado[7] = false;
//           if (!esv5) {
//             subirbajar[7] = -ch[7];
//             anadirtolva('125');
//           } else {
//             anadirtolva('227');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '59') {
//           chconectado[8] = false;
//           if (!esv5) {
//             subirbajar[8] = -ch[8];
//             anadirtolva('126');
//           } else {
//             anadirtolva('228');
//           }
//           swesperarepite = true;
//         }
//         if (b[1] == '60') {
//           chconectado[9] = false;
//           if (!esv5) {
//             subirbajar[9] = -ch[9];
//             anadirtolva('127');
//           } else {
//             anadirtolva('229');
//           }
//           swesperarepite = true;
//         }
//
//         if (b[1] == '61') chconectado[0] = true;
//         if (b[1] == '62') chconectado[1] = true;
//         if (b[1] == '63') chconectado[2] = true;
//         if (b[1] == '64') chconectado[3] = true;
//         if (b[1] == '65') chconectado[4] = true;
//         if (b[1] == '66') chconectado[5] = true;
//         if (b[1] == '67') chconectado[6] = true;
//         if (b[1] == '68') chconectado[7] = true;
//         if (b[1] == '69') chconectado[8] = true;
//         if (b[1] == '70') chconectado[9] = true;
//
//         idrepite++;
//         if (idrepite < a.length) {
//           List<String> d = a[idrepite].split('.');
//           sigtiemporepite = comun.intparse(d[0]);
//         } else {
//           swrepite = false;
//           rutinafindesesion();
//         }
//       }
//     }
//   }
//
//   void bajarcanal2(int canal, int incremento) {
//     if (!chbloqueado[canal]) {
//       subirbajar[canal] -= incremento;
//       if (ch[canal] < 0) ch[canal] = 0;
//       swsubirbajar(canal);
//     }
//   }
//
//   void procesar01() {
//     //FUN_INIT_R
//     if (bufferLectura[1] == 0) {
//       clave1 = bufferLectura[2];
//       clave2 = bufferLectura[3];
//       clave3 = bufferLectura[4];
//       clave4 = bufferLectura[5];
//
//       rclave1 = clave1 ^ 42;
//       rclave2 = clave2 ^ 85;
//       rclave3 = clave3 ^ 170;
//       rclave4 = clave4 ^ 162;
//       errorvalidar++;
//       if (errorvalidar < 5) {
//         anadirtolva('00a');
//       }
//     }
//     if (bufferLectura[1] > 0) {
//       equipovalidado = 1;
//       rutinainfo();
//     }
//   }
//
//   void procesar03() {
//     //FUN_INFO_R
//     verhw = bufferLectura[9].toString();
//     versw = bufferLectura[10].toString();
//   }
//
//   void procesar13() {
//     //FUN_GET_CONTADOR_R
//     tarifa = bufferLectura[1];
//     ct = bufferLectura[3] * 65536 + bufferLectura[4] * 256 + bufferLectura[5];
//     cp = bufferLectura[7] * 65536 + bufferLectura[8] * 256 + bufferLectura[9];
//     posttarifa();
//   }
//
//   void procesar15() {
//     //FUN_GET_CONTADOR_R
//   }
//
//   void procesar17() {
//     //FUN_GET_ESTADO_EMS_R
//     estado = bufferLectura[2];
//     if (verestado() == 4) {
//       //en carga
//       if (estadoequipo == 3) {
//         startequipo();
//       }
//       bool sw = false;
//       for (int x = 0; x < 10; x++) {
//         if (ch[x] > 0) {
//           sw = true;
//         }
//       }
//       if (sw) {
//         rutinaponeracero();
//       }
//     } else {
//       estadobat = bufferLectura[3];
//       temperatura = (bufferLectura[7] * 256 + bufferLectura[8]) ~/ 100;
//       if (temperatura > 130) {}
//       int y = 0;
//       for (int x = 0; x < 10; x++) {
//         y = bufferLectura[10 + x];
//         if (y == 200) {
//           ch[x] = 0;
//         } else {
//           ch[x] = y;
//         }
//       }
//     }
//     swesperarepite = false;
//   }
//
//   void procesar19() {
//     //FUN_RUN_EMS_R
//   }
//
//   void procesar21() {
//     //FUN_STOP_EMS_R
//     swesperarepite = false;
//   }
//
//   void procesar23() {
//     //FUN_CANAL_EMS_R
//     int x = bufferLectura[2];
//     int y = bufferLectura[3];
//     int z = bufferLectura[4];
//     if (y == 1) {
//       if (z == 200) {
//         ch[x] = 0;
//       } else {
//         ch[x] = z;
//       }
//     }
//     swesperarepite = false;
//   }
//
//   void procesar25() {
//     //FUN_ALL_CANAL_EMS_R
//     int y = bufferLectura[2];
//     if (y == 1) {
//       for (int x = 0; x < 10; x++) {
//         int z = bufferLectura[3 + x];
//         if (z == 200) {
//           ch[x] = 0;
//         } else {
//           ch[x] = z;
//         }
//       }
//     }
//   }
//
//   void procesar29() {
//     //FUN_GET_MEM_R
//     for (int x = 0; x < 15; x++) {
//       bufferParam[x] = bufferLectura[x + 3];
//     }
//
//     ctdia = bufferParam[0];
//     ctmes = bufferParam[1];
//     ctao = bufferParam[2];
//     ct1 = bufferParam[3];
//     ct2 = bufferParam[4];
//     ct3 = bufferParam[5];
//     ct4 = bufferParam[6];
//
//     bool grabarfecha = controlsemana();
//
//     if (grabarfecha) {
//       anadirtolva('30');
//     }
//   }
//
//   void procesar31() {
//     //FUN_SET_MEM_R
//   }
//
//   void procesar88() {
//     //PROTO_F_R_READ_INFO
//     tarifa = bufferLectura[3];
//     elev1 = bufferLectura[5].toString();
//     elev2 = bufferLectura[6].toString();
//     versw = bufferLectura[7].toString();
//     verhw = bufferLectura[8].toString();
//     xmac1 = bufferLectura[13].toString();
//     xmac2 = bufferLectura[14].toString();
//     xmac3 = bufferLectura[15].toString();
//     xmac4 = bufferLectura[16].toString();
//     xmac5 = bufferLectura[17].toString();
//     xmac6 = bufferLectura[18].toString();
//     xmac7 = bufferLectura[19].toString();
//     xmac8 = bufferLectura[20].toString();
//     xmac9 = bufferLectura[21].toString();
//     xmac10 = bufferLectura[22].toString();
//     xmac11 = bufferLectura[23].toString();
//     xmac12 = bufferLectura[24].toString();
//     cta = bufferLectura[25];
//     ctb = bufferLectura[26];
//     ctc = bufferLectura[27];
//     ctd = bufferLectura[28];
//
//     ct =
//         bufferLectura[26] * 65536 + bufferLectura[27] * 256 + bufferLectura[28];
//     cp =
//         bufferLectura[30] * 65536 + bufferLectura[31] * 256 + bufferLectura[32];
//
//     if (comun.pagina == 1) {
//       posttarifa();
//     }
//   }
//
//   void posttarifa() {
//     if (tarifa > 0) {
//       if (cp < 10000) {
//         renovaciontiempo();
//       }
//     }
//   }
//
//   void procesar90() {
//     //PROTO_F_R_READ_BAT
//     mcivoltaje = (bufferLectura[3] * 256 + bufferLectura[4]) / 100;
//   }
//
//   void procesar100() {
//     //PROTO_F_R_WRITE_CP
//   }
//
//   void procesar102() {
//     //PROTO_F_R_ESTADO_TOT
//
//     estado = bufferLectura[2];
//     estadobat = bufferLectura[3];
//     flag1 = bufferLectura[4];
//     flag2 = bufferLectura[5];
//     ch[0] = bufferLectura[6];
//     ch[1] = bufferLectura[7];
//     ch[2] = bufferLectura[8];
//     ch[3] = bufferLectura[9];
//     ch[4] = bufferLectura[10];
//     ch[5] = bufferLectura[11];
//     ch[6] = bufferLectura[12];
//     ch[7] = bufferLectura[13];
//     ch[8] = bufferLectura[14];
//     ch[9] = bufferLectura[15];
//
//     revisarestado();
//   }
//
//   void procesar106() {
//     //PROTO_F_R_estado bat
//     estadobat = bufferLectura[3];
//   }
//
//   void procesar115() {
//     //PROTO_F_R_BACKDOOR
//     lica = bufferLectura[6];
//     licb = bufferLectura[7];
//     licc = bufferLectura[8];
//     licd = bufferLectura[9];
//   }
//
//   void procesar128() {
//     //PROTO_F_R_X_ch1
//     estado = bufferLectura[2];
//     ch[0] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar129() {
//     //PROTO_F_R_X_ch2
//     estado = bufferLectura[2];
//     ch[1] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar130() {
//     //PROTO_F_R_X_ch3
//     estado = bufferLectura[2];
//     ch[2] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar131() {
//     //PROTO_F_R_X_CH4
//     estado = bufferLectura[2];
//     ch[3] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar132() {
//     //PROTO_F_R_X_CH5
//     estado = bufferLectura[2];
//     ch[4] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar133() {
//     //PROTO_F_R_X_CH6
//     estado = bufferLectura[2];
//     ch[5] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar134() {
//     //PROTO_F_R_X_CH7
//     estado = bufferLectura[2];
//     ch[6] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar135() {
//     //PROTO_F_R_X_CH8
//     estado = bufferLectura[2];
//     ch[7] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar136() {
//     //PROTO_F_R_X_CH9
//     estado = bufferLectura[2];
//     ch[8] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar137() {
//     //PROTO_F_R_X_ch10
//     estado = bufferLectura[2];
//     ch[9] = bufferLectura[3];
//     swesperarepite = false;
//     revisarestado();
//   }
//
//   void procesar139() {
//     //PROTO_F_R_X_TODOS
//     ch[0] = bufferLectura[4];
//     ch[1] = bufferLectura[5];
//     ch[2] = bufferLectura[6];
//     ch[3] = bufferLectura[7];
//     ch[4] = bufferLectura[8];
//     ch[5] = bufferLectura[9];
//     ch[6] = bufferLectura[10];
//     ch[7] = bufferLectura[11];
//     ch[8] = bufferLectura[12];
//     ch[9] = bufferLectura[13];
//     swesperarepite = false;
//   }
//
//   void procesar144() {
//     //PROTO_F_R_X_TODOS
//     estadobat = bufferLectura[4];
//   }
//
//   void revisarestado() {
//     if (verestado() == 3) {
//       //sin tiempo
//     }
//     if (verestado() == 4) {
//       //en carga
//       if (estadoequipo == 3) {
//         startequipo();
//       }
//       bool sw = false;
//       for (int x = 0; x < 10; x++) {
//         if (ch[x] > 0) {
//           sw = true;
//         }
//       }
//       if (sw) {
//         rutinaponeracero();
//       }
//     }
//   }
//
//   Future<void> renovaciontiempo() async {
//     try {
//       String maclimpia = macAddress.replaceAll(':', '');
//       String datos = comun.encrip("4<#>$maclimpia<#>$comun.licencia");
//       Uri url = Uri.parse("https://imotionems.es/lic2.php?a=$datos");
//       var response = await http.get(url);
//       List<String> a = response.body.split('|');
//       int bloqueotiempo = comun.intparse(a[0]);
//       int renovacion = comun.intparse(a[1]);
//       comun.segundosrenovacion = comun.intparse(a[2]);
//       if (renovacion == 1) {
//         //renovar
//         String datos = comun.encrip(
//             "12<#>$maclimpia<#>$comun.licencia<#>$cp<#>$comun.segundosrenovacion<#>$ct");
//         url = Uri.parse("https://imotionems.es/lic2.php?a=$datos");
//         await http.get(url);
//         swrenovacion = 1;
//       }
//       if (bloqueotiempo == 0) {
//         //desbloquear
//         swrenovacion = 2;
//       }
//     } catch (e) {}
//   }
//
//   void datos2param() {
//     bufferParam[125] = comun.intparse(fechasemana.substring(4));
//     bufferParam[126] = comun.intparse(fechasemana.substring(2, 4));
//     bufferParam[127] = comun.intparse(fechasemana.substring(0, 2));
//     bufferParam[128] = cta;
//     bufferParam[129] = ctb;
//     bufferParam[130] = ctc;
//     bufferParam[131] = ctd;
//   }
//
//   //-----------------------------------------
// //--------------------------------------
//   Future<void> escribirpuertov4() async {
//     if (estadoequipo > 0) {
//       int funcion = bufferEscritura[1];
//       int longitud = longitudfuncion(funcion);
//       int x;
//       int y = 0;
//       final Uint8List buffer2 = Uint8List(500);
//       buffer2[0] = 85;
//       for (x = 1; x < longitud; x++) {
//         y++;
//         buffer2[y] = bufferEscritura[x];
//         if (bufferEscritura[x] == 85) {
//           y++;
//           buffer2[y] = 86;
//         }
//       }
//       y++;
//       final Uint8List bufferToSend = Uint8List(y);
//       for (x = 0; x < y; x++) {
//         bufferToSend[x] = buffer2[x];
//       }
//       if (comun.debug)
//         print('Envio    $numeromci ${comun.hora} : $bufferToSend');
//       if (comun.swlog)
//         comun.weblog.add('Envio   $numeromci ${comun.hora} : $bufferToSend');
//
//       if (esble == 1) {
//         try {
//           await mciescribir.write(bufferToSend);
//         } catch (e) {
//           errores++;
//         }
//         ultimaEscritura = comun.hora;
//       } else {
//         serconexion.output.add(bufferToSend);
//         ultimaEscritura = comun.hora;
//       }
//     }
//   }
//
//   Future<void> escribirpuertov40() async {
//     if (estadoequipo > 0) {
//       int funcion = bufferEscritura[1];
//       int longitud = longitudfuncion(funcion);
//       int x;
//       int y = 0;
//       final Uint8List buffer2 = Uint8List(500);
//       buffer2[0] = 85;
//       for (x = 1; x < longitud; x++) {
//         y++;
//         buffer2[y] = bufferEscritura[x];
//         if (bufferEscritura[x] == 85) {
//           y++;
//           buffer2[y] = 86;
//         }
//       }
//       y++;
//       final Uint8List bufferToSend = Uint8List(y);
//       for (x = 0; x < y; x++) {
//         bufferToSend[x] = buffer2[x];
//       }
//       if (comun.debug)
//         print('Envio    $numeromci ${comun.hora} : $bufferToSend');
//       if (comun.swlog)
//         comun.weblog.add('Envio   $numeromci ${comun.hora} : $bufferToSend');
//
//       if (esble == 1) {
//         try {
//           await mciescribir.write(bufferToSend);
//         } catch (e) {
//           errores++;
//         }
//         ultimaEscritura = comun.hora;
//       } else {
// //        await imotionMciCom.exec(
//         //          'write', {'macAddress': macAddress, 'functBuffer': bufferToSend});
//         ultimaEscritura = comun.hora;
//       }
//     }
//   }
//
//   Future<void> escribirpuertov5() async {
//     Uint8List bufferToSend = Uint8List(20);
//
//     if (estadoequipo > 0) {
//       for (int x = 0; x < 20; x++) {
//         bufferToSend[x] = bufferEscritura[x];
//       }
//
//       if (comun.debug)
//         print(
//             'Envio    V5 $numeromci ${comun.hora}: ' + bufferToSend.toString());
//       if (comun.swlog)
//         comun.weblog.add(
//             'Envio    V5 $numeromci ${comun.hora}: ' + bufferToSend.toString());
//
//       try {
//         await mciescribir.write(bufferToSend);
//       } catch (e) {
//         errores++;
//       }
//       ultimaEscritura = comun.hora;
//     }
//   }
//
//   void limpiarbufer() {
//     for (int x = 0; x < 250; x++) {
//       bufferLectura[x] = 0;
//     }
//   }
//
// //--------------------------------
//   Future<void> procesarlectura(Uint8List data) async {
//     errores = 0;
//     if (esv5) {
//       procesarlectura5(data);
//     } else {
//       procesarlectura4(data);
//     }
//   }
//
//   Future<void> procesarlectura4(Uint8List data) async {
//     //añadir data recibida a buffer lectura
//     for (int i = 0; i < data.length; i++) {
//       if (idBufferLectura == -1) {
//         //primer caracter
//         if (data[i] == 85) {
//           idBufferLectura++;
//           bufferLectura[idBufferLectura] = data[i];
//         }
//       } else if (idBufferLectura == 0) {
//         //segundo caracter
//         if (data[i] == 86) {
//           idBufferLectura = -1;
//         } else {
//           idBufferLectura++;
//           bufferLectura[idBufferLectura] = data[i];
//         }
//       } else {
//         //resto lineas
//         if (bufferLectura[idBufferLectura] == 85 && data[i] == 86) {
//           //saltarse el 86
//         } else {
//           idBufferLectura++;
//           bufferLectura[idBufferLectura] = data[i];
//         }
//       }
//     }
//
//     if (idBufferLectura > 0) {
//       int longitud = longitudfuncion(bufferLectura[1]);
//       if (idBufferLectura >= (longitud - 1)) {
//         if (comun.debug) print('recibido eq ${comun.hora} : ${bufferLectura}');
//         if (comun.swlog)
//           comun.weblog.add('recibido eq ${comun.hora} : ${bufferLectura}');
//         //procesar respuesta
//         if (bufferLectura[1] == 88) procesar88();
//         if (bufferLectura[1] == 90) procesar90();
//         if (bufferLectura[1] == 100) procesar100();
//         if (bufferLectura[1] == 102) procesar102();
//         if (bufferLectura[1] == 106) procesar106();
//         if (bufferLectura[1] == 115) procesar115();
//         if (bufferLectura[1] == 128) procesar128();
//         if (bufferLectura[1] == 129) procesar129();
//         if (bufferLectura[1] == 130) procesar130();
//         if (bufferLectura[1] == 131) procesar131();
//         if (bufferLectura[1] == 132) procesar132();
//         if (bufferLectura[1] == 133) procesar133();
//         if (bufferLectura[1] == 134) procesar134();
//         if (bufferLectura[1] == 135) procesar135();
//         if (bufferLectura[1] == 136) procesar136();
//         if (bufferLectura[1] == 137) procesar137();
//         if (bufferLectura[1] == 139) procesar139();
//         if (bufferLectura[1] == 144) procesar144();
//
//         //fin procesar respuesta
//         limpiarbufer();
//         idBufferLectura = -1;
//         swesperarespuesta = false;
//       }
//     }
//   }
//
//   Future<void> procesarlectura5(Uint8List data) async {
//     //añadir data recibida a buffer lectura
//     if (data.length == 20) {
//       for (int i = 0; i < 20; i++) {
//         bufferLectura[i] = data[i];
//       }
//     }
//     if (comun.debug)
//       print('recibido V5 ${comun.hora}: ${bufferLectura.sublist(0, 20)}');
//     if (comun.swlog)
//       comun.weblog
//           .add('recibido V5 ${comun.hora}: ${bufferLectura.sublist(0, 20)}');
//
//     //procesar respuesta
//     if (bufferLectura[0] == 1) procesar01();
//     if (bufferLectura[0] == 3) procesar03();
//     if (bufferLectura[0] == 13) procesar13();
//     if (bufferLectura[0] == 17) procesar17();
//     if (bufferLectura[0] == 19) procesar19();
//     if (bufferLectura[0] == 21) procesar21();
//     if (bufferLectura[0] == 23) procesar23();
//     if (bufferLectura[0] == 25) procesar25();
//     if (bufferLectura[0] == 29) procesar29();
//     if (bufferLectura[0] == 31) procesar31();
//
//     limpiarbufer();
//     swesperarepite = false;
//     swesperarespuesta = false;
//   }
//
//   //-------------------------PROCESADO DE FUNCIONES
//
//   int verestado() {
//     int est = estado;
// /*
//     0: POWER OFF. (metaestado)
//     1: CHARGE. (no puede ponerse en RUN)
//     2: STOP
//     3: RUN RAMPA
//     4: RUN
//     100: LIMITE TARIFA.
// */
//
//     if (esv5) {
//       if (estado == 0) {
//         est = 0;
//       }
//       if (estado == 1) {
//         est = 5;
//       }
//       if (estado == 2) {
//         est = 6;
//       }
//       if (estado == 3) {
//         est = 9;
//       }
//       if (estado == 4) {
//         est = 9;
//       }
//       if (estado == 100) {
//         est = 3;
//       }
//     } else {
//       if (estado == 5) {
//         est = 4;
//       }
//       if (estado == 7) {
//         est = 6;
//       }
//       if (estado == 10) {
//         est = 9;
//       }
//     }
//     return est;
//   }
//
//   void rutinainicio() {
//     if (!esv5) {
//       anadirtolva('101');
//       anadirtolva('87');
//       anadirtolva('89');
//       anadirtolva('111');
//       anadirtolva('138r');
//       anadirtolva('138r');
//     } else {
//       anadirtolva('00');
//     }
//   }
//
//   void rutinarecarga() {
//     if (!esv5) {
//       anadirtolva('114');
//       anadirtolva('99');
//       anadirtolva('87');
//     } else {
//       anadirtolva('14a');
//     }
//   }
//
//   void rutinadesbloqueo() {
//     if (!esv5) {
//       anadirtolva('114');
//       anadirtolva('91');
//     } else {
//       anadirtolva('14b');
//     }
//   }
//
//   void rutinacerrarpanel() {
//     if (!esv5) {
//       anadirtolva('109b');
//       anadirtolva('109c');
//     } else {
//       anadirtolva('00b');
//       anadirtolva('109b');
//       anadirtolva('109c');
//     }
//   }
//
//   void rutinafindesesion() {
//     if (!esv5) {
//       anadirtolva('109');
//       anadirtolva('109a');
//     } else {
//       anadirtolva('109');
//       anadirtolva('109a');
//     }
//   }
//
//   void rutinainfo() {
//     if (!esv5) {
//       anadirtolva('101');
//       anadirtolva('87');
//       anadirtolva('89');
//       anadirtolva('111');
//     } else {
//       anadirtolva('02');
//       anadirtolva('28');
//       anadirtolva('12');
//       anadirtolva('08');
//       anadirtolva('101');
//     }
//   }
//
//   void rutinaponeracero() {
//     if (!esv5) {
//       anadirtolva('138r');
//       anadirtolva('138r');
//     } else {
//       anadirtolva('138r');
//       anadirtolva('138r');
//     }
//   }
//
//   void rutinacambioprograma() {
//     if (!esv5) {
//       anadirtolva('110');
//       anadirtolva('138p');
//     } else {
//       anadirtolva('110');
//       anadirtolva('138p');
//     }
//   }
//
//   void rutinacambiofrecuencia() {
//     if (!esv5) {
//       anadirtolva('138f');
//       anadirtolva('107');
//       anadirtolva('105');
//     } else {
//       anadirtolva('138f');
//       anadirtolva('107');
//       anadirtolva('105');
//     }
//   }
//
// //------------utilidades
//   void ciclofrecuencia() {
//     // ejemplo:    30,50-1,70-1,100-1,0+3 (fin frecuencias y reiniciar compensacion)
//     if (frecuencia2 != '') {
//       List<String> frec2 = frecuencia2.split(',');
//       idfrecuencia2++;
//       if (idfrecuencia2 > (frec2.length - 1)) {
//         idfrecuencia2 = 0;
//       }
//       String frec = frec2[idfrecuencia2];
//       if (idfrecuencia2 == 0) {
//         //primera
//         frecuencia = comun.intparse(frec);
//       } else {
//         //siguientes frecuencias
//         if (frec.contains('+')) {
//           // mas
//           List<String> frec3 = frec.split('+');
//           frecuencia = comun.intparse(frec3[0]);
//           compensacionfrecuencia = comun.intparse(frec3[1]);
//         } else {
//           if (frec.contains('-')) {
//             //menos
//             List<String> frec3 = frec.split('-');
//             frecuencia = comun.intparse(frec3[0]);
//             compensacionfrecuencia = -comun.intparse(frec3[1]);
//           } else {
//             // ni mas ni menos
//             frecuencia = comun.intparse(frec);
//             compensacionfrecuencia = 0;
//           }
//         }
//       }
//       if (frecuencia == 0) {
//         //fin de frecuencias reinicio
//         frecuencia = comun.intparse(frec2[0]);
//         idfrecuencia2 = 0;
//       }
//     }
//   }
//
//   void inicializarequipo() {
//     estadobat = 9;
//
//     int y;
//     for (y = 0; y < 10; y++) {
//       ch[y] = 0;
//       ch0[y] = 0;
//       chanulado[y] = false;
//       chbloqueado[y] = false;
//       chconectado[y] = true;
//       subirbajar[y] = 0;
//     }
//     equipogrupo = 0;
//
//     horaInicio = '';
//     tiempoInicio = 0;
//     tiempoInicioPausa = 0;
//     pausaAcumulada = 0;
//     tiempoParada = 0;
//     vvparada = 0;
//
//     leerdatosprograma();
//
//     tiempoSalto = 0;
//     tiempoSegmento = 0;
//     pisegmento = '';
//     piprograma = -1;
//
//     swrepite = false;
//     swesperarepite = false;
//     repitesesion = '';
//     idrepite = 0;
//     sigtiemporepite = 0;
//
//     ultimacop = 0;
//     cop = '';
//
//     cicloElegido = 0;
//     indiceCiclo = -1;
//
//     tolva = [];
//     for (y = 0; y < 100; y++) {
//       bufferLectura[y] = 0;
//       bufferEscritura[y] = 0;
//     }
//     idBufferLectura = -1;
//
//     swesperarespuesta = false;
//     ultimaEscritura = 0;
//
//     cliente = 0;
//     bono = 0;
//     nombrecliente = '';
//     sexocliente = 0;
//     pesocliente = 0;
//     actividad = '';
//
//     swrenovacion = 0;
//   }
//
//   void leerdatosprograma() {
//     if (tipoprograma == 3) {
//       numeroprograma = piprograma;
//     }
//     int np = numeroprograma;
//     frecuencia = comun.prfrecuencia[np];
//     frecuencia2 = comun.prfrecuencia2[np];
//     idfrecuencia2 = -1;
//     compensacionfrecuencia = 0;
//     pulso = comun.prpulso[np];
//     rampa = comun.prrampa[np];
//     contraccion = comun.prcontraccion[np];
//     pausa = comun.prpausa[np];
//     if (pulso == 0) {
//       List<String> scr = comun.prcronaxie[np].split('-');
//       if (scr.isNotEmpty) {
//         for (int x = 0; x < scr.length; x++) {
//           cr[x] = comun.intparse(scr[x]);
//         }
//       }
//     }
//     List<String> vv = comun.practivo[np].split('-');
//     for (int x = 0; x < vv.length; x++) {
//       chconectado[x] = (vv[x] == '1');
//       if (chanulado[x]) {
//         chconectado[x] = false;
//       }
//     }
//   }
//
//   void bucle() {
//     comun.hora = comun.leersegundos();
//     segTranscurrido = (comun.hora - tiempoInicio - pausaAcumulada).toDouble();
//     segPendientes = comun.duracionsesion - segTranscurrido;
//     if (estadoequipo > 0) {
//       //conectado
//       if (swesperarespuesta) {
//         if ((comun.hora - ultimaEscritura) > 5) {
//           errores++;
//           if (errores > 3) {
//             //error desconectar
//             desconectar();
//           }
//         }
//       } else {
//         if (estadoequipo == 2) {
//           //iniciado y parado
//           if (swrepite) {
//             if (!swesperarepite) {
//               repetirsesion();
//             }
//           }
//         }
//         if (estadoequipo == 3) {
//           //iniciado y en marcha
// //reposicionar video
// //           if (comun.swvideopos) {
// //             if (comun.vpc.value.isInitialized) {
// //               comun.swvideopos = false;
// //               int dur = comun.hora - tiempoInicio - pausaAcumulada;
// //               comun.vpc.seekTo(Duration(seconds: dur));
// //             }
// //           }
// // control de luces
//           comun.contadorluces++;
//           if (comun.contadorluces > 10) {
//             comun.contadorluces = 0;
//             comun.idluces++;
//             if (comun.idluces > 4) comun.idluces = 1;
//           }
// // control tiempo pendiente
//           if (segPendientes <= 0) {
//             rutinafindesesion();
//           } else {
//             if (swrepite) {
//               if (!swesperarepite) repetirsesion();
//             } else {
//               if (tipoprograma == 3) {
//                 //si es programa inteligente
//                 if (segTranscurrido > tiempoSalto) {
// //cambio de programa
//                   String vv = comun.datosinteligente(
//                       numerointeligente, segTranscurrido.toInt());
//                   vv = vv.replaceAll(',', '.');
//                   List<String> vv2 = vv.split('_');
//                   if (vv2[0] == '') {
//                     //falta programa, fin sesion
//                     rutinafindesesion();
//                   } else {
//                     //nuevo programa
//                     piprograma = comun.intparse(vv2[0]);
//                     tiempoSegmento = (double.parse(vv2[1]) * 60).toInt();
//                     piajuste = (double.parse(vv2[2]) * 2).toInt();
//                     tiempoSalto = (double.parse(vv2[3]).toInt());
//
//                     leerdatosprograma();
//                     actividadPrograma();
//
//                     rutinacambioprograma();
//                     if (pausa > 0) {
//                       //hay ciclos c-p
//                       ultimacop = comun.hora - contraccion;
//                       cop = 'c';
//                       ciclofrecuencia();
//                     } else {
//                       //no hay ciclos c-p
//                       cop = 'p';
//                     }
//                   }
//                 }
//               }
//             }
//             int segcp = comun.hora - ultimacop;
//             if (pausa > 0) {
//               //si hay ciclos contraccion-pausa
//               if (cop == 'c') {
//                 //en contraccion
//                 if (contraccion > 0) {
//                   porccontraccion = segcp / contraccion;
//                 }
//
//                 if (segcp >= contraccion) {
//                   //cambio a pausa
//                   ultimacop = comun.hora;
//                   cop = 'p';
//                   anadirtolva('110');
//                   calcularpuntos();
//                 }
//               } else if (cop == 'p') {
//                 //en pausa
//                 if (pausa > 0) {
//                   porcpausa = segcp / pausa;
//                 }
//                 if (segcp >= pausa) {
//                   //cambio a contraccion
//                   ultimacop = comun.hora;
//                   cop = 'c';
//                   ciclofrecuencia();
//                   rutinacambiofrecuencia();
//                 }
//               } else {
//                 //ni c ni p empezamos con contraccion
//                 ultimacop = comun.hora;
//                 cop = 'c';
//                 ciclofrecuencia();
//                 rutinacambiofrecuencia();
//               }
//             } else {
//               //no hay ciclos de contraccion-pausa
//               if (cop == 'p') {
//                 cop = 'c';
//                 ciclofrecuencia();
//                 rutinacambiofrecuencia();
//               }
//               if (contraccion > 0) {
//                 porccontraccion = segcp / contraccion;
//               }
//               porcpausa = 0;
//
//               if (segcp >= 5) {
//                 calcularpuntos();
//                 ultimacop = comun.hora;
//               }
//             }
//           }
//         }
//
//         bufferEscritura[0] = 85;
//         for (int x = 1; x < 120; x++) {
//           bufferEscritura[x] = 0;
//         }
//         if (swrenovacion == 1) {
//           //renovar
//           swrenovacion = 0;
//           rutinarecarga();
//         }
//         if (swrenovacion == 2) {
//           //desbloquear
//           swrenovacion = 0;
//           rutinadesbloqueo();
//         }
//         if (tolva.isNotEmpty) {
//           String tv = tolva[0];
//           tolva.removeAt(0);
//
//           if (tv == '00') {
//             funcion00();
//           }
//           if (tv == '00a') {
//             funcion00a();
//           }
//           if (tv == '00b') {
//             funcion00b();
//           }
//           if (tv == '02') {
//             funcion02();
//           }
//           if (tv == '12') {
//             funcion12();
//           }
//           if (tv == '14a') {
//             funcion14a();
//           }
//           if (tv == '14b') {
//             funcion14b();
//           }
//           if (tv == '220') {
//             funcion220();
//           }
//           if (tv == '221') {
//             funcion221();
//           }
//           if (tv == '222') {
//             funcion222();
//           }
//           if (tv == '223') {
//             funcion223();
//           }
//           if (tv == '224') {
//             funcion224();
//           }
//           if (tv == '225') {
//             funcion225();
//           }
//           if (tv == '226') {
//             funcion226();
//           }
//           if (tv == '227') {
//             funcion227();
//           }
//           if (tv == '228') {
//             funcion228();
//           }
//           if (tv == '229') {
//             funcion229();
//           }
//           if (tv == '261') {
//             funcion261();
//           }
//           if (tv == '28') {
//             funcion28();
//           }
//           if (tv == '30') {
//             funcion30();
//           }
//           if (tv == '87') {
//             funcion87();
//           }
//           if (tv == '89') {
//             funcion89();
//           }
//           if (tv == '91') {
//             funcion91();
//           }
//           if (tv == '91b') {
//             funcion91b();
//           }
//           if (tv == '99') {
//             funcion99();
//           }
//           if (tv == '99b') {
//             funcion99b();
//           }
//           if (tv == '101') {
//             funcion101();
//           }
//           if (tv == '105') {
//             funcion105();
//           }
//           if (tv == '107') {
//             funcion107();
//           }
//           if (tv == '109') {
//             funcion109();
//           }
//           if (tv == '109a') {
//             funcion109a();
//           }
//           if (tv == '109b') {
//             funcion109b();
//           }
//           if (tv == '109c') {
//             funcion109c();
//           }
//           if (tv == '110') {
//             funcion110();
//           }
//           if (tv == '111') {
//             funcion111();
//           }
//           if (tv == '114') {
//             funcion114();
//           }
//           if (tv == '118') {
//             funcion118();
//           }
//           if (tv == '119') {
//             funcion119();
//           }
//           if (tv == '120') {
//             funcion120();
//           }
//           if (tv == '121') {
//             funcion121();
//           }
//           if (tv == '122') {
//             funcion122();
//           }
//           if (tv == '123') {
//             funcion123();
//           }
//           if (tv == '124') {
//             funcion124();
//           }
//           if (tv == '125') {
//             funcion125();
//           }
//           if (tv == '126') {
//             funcion126();
//           }
//           if (tv == '127') {
//             funcion127();
//           }
//           if (tv == '138') {
//             funcion138();
//           }
//           if (tv == '138e') {
//             funcion138e();
//           }
//           if (tv == '138f') {
//             funcion138f();
//           }
//           if (tv == '138p') {
//             funcion138p();
//           }
//           if (tv == '138r') {
//             funcion138r();
//           }
//         }
//
//         if (ultimaEscritura == 0) {
//           ultimaEscritura = comun.hora;
//         }
//         if (bufferEscritura[1] == 0 && swescritura == false) {
//           if ((comun.hora - ultimaEscritura) > 5) {
//             ultimaEscritura = comun.hora;
//             anadirtolva('101');
//           }
//         } else {
//           if (!esv5) {
//             if (bufferEscritura[1] > 0) {
//               swesperarespuesta = true;
//               ultimaEscritura = comun.hora;
//               escribirpuertov4();
//             }
//           } else {
//             if (swescritura) {
//               swescritura = false;
//               swesperarespuesta = true;
//               ultimaEscritura = comun.hora;
//               escribirpuertov5();
//             }
//           }
//         }
//       }
//     }
//   }
//
//   void anadirtolva(String tv) {
//     tolva.add(tv);
//   }
//
//   void bajarcanal(int canal, int incremento) {
//     if (!chbloqueado[canal]) {
//       subirbajar[canal] -= incremento;
//       if (ch[canal] < 0) {
//         ch[canal] = 0;
//       }
//       swsubirbajar(canal);
//     }
//   }
//
//   void subircanal(int canal, int incremento) {
//     if (!chbloqueado[canal]) {
//       subirbajar[canal] += incremento;
//       if (ch[canal] > 200) {
//         ch[canal] = 200;
//       }
//       swsubirbajar(canal);
//     }
//   }
//
//   void swsubirbajar(int canal) {
//     anadirtolva((118 + canal).toString());
//   }
//
//   void subirx() {
//     subirbajarx += comun.incremento;
//     if (subirbajarx > 8) subirbajarx = 8;
//     anadirtolva('138');
//   }
//
//   void bajarx() {
//     subirbajarx -= comun.incremento;
//     anadirtolva('138');
//   }
//
//   void infomci() {
//     rutinainfo();
//   }
//
//   void recargamci() {
//     renovaciontiempo();
//   }
//
//   void actividadPrograma() {
//     int programa;
//     if (tipoprograma == 2) {
//       programa = numeroprograma;
//     } else {
//       programa = piprograma;
//     }
//
//     if (ultimoPrograma != programa) {
//       ultimoPrograma = programa;
//       anadiractividad(
//           '06', '$programa-$frecuencia-$pulso-$rampa-$contraccion-$pausa');
//       if (pulso == 0) {
//         anadiractividad('09',
//             '${cr[0]}-${cr[1]}-${cr[2]}-${cr[3]}-${cr[4]}-${cr[5]}-${cr[6]}-${cr[7]}-${cr[8]}-${cr[9]}');
//       }
//     }
//   }
//
//   void startequipo() {
//     int seg = comun.leersegundos();
//     switch (estadoequipo) {
//       case 1:
//       //iniciar
//         inicializarequipo();
//         horaInicio = DateTime.now().toString();
//         tiempoInicio = seg;
//         if (nombrecliente.length < 7) {
//           nombrecliente6 = nombrecliente;
//         } else {
//           nombrecliente6 = nombrecliente.substring(0, 6);
//         }
//         puntos0 = 0;
//         puntos = 0;
//         ekcal = 0;
//         anadirtolva('107');
//         estadoequipo = 3;
//         ultimacop = 0;
//         cop = '';
//         anadiractividad('00', '');
//         if (tipoprograma == 1) {
//           anadiractividad('05', '');
//         }
//         if (tipoprograma == 2) {
//           actividadPrograma();
//         }
//         if (tipoprograma == 3) {
//           anadiractividad('07', numerointeligente.toString());
//         }
//         anadiractividad('08', cicloElegido.toString());
//         comun.usubonos--;
//         // if (comun.swvideo) comun.vpc.play();
//         break;
//
//       case 2:
//       //reiniciar
//         pausaAcumulada += seg - tiempoInicioPausa;
//         anadirtolva('107');
//         estadoequipo = 3;
//         ultimacop = 0;
//         cop = '';
//         actividadPrograma();
//         anadiractividad('02', '');
//         // if (comun.swvideo) {
//         //   comun.vpc.play();
//         // }
//         break;
//
//       case 3:
//       //parar
//         tiempoParada = arcotiempo;
//         vvparada = tiempoSalto - (comun.hora - tiempoInicio - pausaAcumulada);
//         tiempoInicioPausa = seg;
//         anadirtolva('110');
//         estadoequipo = 2;
//         anadiractividad('01', '');
//         // if (comun.swvideo) {
//         //   comun.vpc.pause();
//         // }
//         break;
//     }
//   }
// }
