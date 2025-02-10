import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/models/license.dart';

class LicenseController extends GetxController{
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
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

  /// Session control
  RxInt maxTimeValue = 25.obs;


  moveFocusTo(BuildContext context, FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// license / MCI details
  RxString selectedStatus = ''.obs;
  RxBool toggle = false.obs;
  List<String> statusList = [Strings.inactive, Strings.active];


  @override
  void dispose() {
    /// Dispose all TextEditingControllers
    licenseNumberController.dispose();
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    countryController.dispose();
    phoneController.dispose();
    emailController.dispose();

    /// Dispose all FocusNodes
    nameFocusNode.dispose();
    directionFocusNode.dispose();
    cityFocusNode.dispose();
    provinceFocusNode.dispose();
    countryFocusNode.dispose();
    phoneFocusNode.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  updateStatus({required int index, required String value}){
    mciLicenseList[index].status.value = value;
    update();
  }


  validateLicense(){
    mciLicenseList.add(
        License(mci: '123456789', type: Strings.typeBT, status: Strings.inactive.obs),
    );
    update();
  }

}