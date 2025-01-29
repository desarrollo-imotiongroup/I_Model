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
  RxList<dynamic> mciLicenseList = [].obs;

  @override
  void dispose() {
    licenseNumberController.dispose();
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    countryController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  validateLicense(){
    mciLicenseList.add(
        License(mci: '123456789', type: Strings.typeBT, status: Strings.inactive),
    );
    update();
  }

}