import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/client/client_activity.dart';
import 'package:i_model/models/client/clients.dart';

class ClientController extends GetxController {
  List<String> clientStatusList = [Strings.active, Strings.inactive, Strings.all];
  List<String> genderList = [Strings.man, Strings.women];

  /// Client screen values
  final TextEditingController nameController = TextEditingController();
  RxString selectedStatus = Strings.active.obs;
  var isDropdownOpen = false.obs;

  /// Client Personal data values
  final TextEditingController clientPerDataNameController = TextEditingController();
  final TextEditingController clientPerDataDobController = TextEditingController();
  final TextEditingController clientPerDataPhoneController = TextEditingController();
  final TextEditingController clientPerDataHeightController = TextEditingController();
  final TextEditingController clientPerDataWeightController = TextEditingController();
  final TextEditingController clientPerDataEmailController = TextEditingController();
  RxString clientPerDataSelectedGender = Strings.nothing.obs;


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


  RxList<dynamic> clientsDetail = [
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



}
