import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_model/config/language_constants.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguageController extends GetxController {
  final RxList<String> languages = [
    Strings.spanish,
    Strings.english,
    Strings.french,
    Strings.portuguese,
    Strings.italian,
    Strings.german,
  ].obs;

  RxString selectedLanguage = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    selectedLanguage.value = sharedPreferences.getString(Strings.selectedLanguage) ?? Strings.spanish;
  }

  chooseLanguage({required BuildContext context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Locale locale;
    String languageCode = Strings.spanishLanguageCode;

    switch (selectedLanguage.value) {
      case Strings.english:
        languageCode = Strings.englishLanguageCode;
        break;
      case Strings.spanish:
        languageCode = Strings.spanishLanguageCode;
        break;
      case Strings.french:
        languageCode = Strings.frenchLanguageCode;
        break;
      case Strings.german:
        languageCode = Strings.germanLanguageCode;
        break;
      case Strings.portuguese:
        languageCode = Strings.portugueseLanguageCode;
        break;
      case Strings.italian:
        languageCode = Strings.italianLanguageCode;
        break;
    }

    locale = await setLocale(languageCode);
    MyApp.setLocale(context, locale);
    sharedPreferences.setString(Strings.selectedLanguageCode, languageCode);
    sharedPreferences.setString(Strings.selectedLanguage, selectedLanguage.value);

  }
}
