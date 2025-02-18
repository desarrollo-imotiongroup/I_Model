import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/helper_methods.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/overlays/alert_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaxTimeSelectionController extends GetxController{
  RxInt maxTimeValue = 25.obs;

  @override
  Future<void> onInit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int maxTime = sharedPreferences.getInt(Strings.maxTimeSP) ?? 25;
    maxTimeValue.value = maxTime;
    super.onInit();
  }

  selectMaxTime(BuildContext context, {required int oldMaxValue, required Function() dismissOverlayFunc}) async {
    if(oldMaxValue != maxTimeValue.value) {
      /// Storing max time in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(Strings.maxTimeSP, maxTimeValue.value);

      dismissOverlayFunc();

      HelperMethods.showSnackBar(context, title: translation(context).maxTimeSnackBarConfirmation);
    }
    else{
      alertOverlay(context,
          heading: translation(context).alertCompleteForm,
          description: translation(context).notSelectedMaxTimeError,
          isOneButtonNeeded: true
      );
    }
  }


}