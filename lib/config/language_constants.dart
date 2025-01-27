import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<Locale> setLocale(String languageCode) async {
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String languageCode = sharedPreferences.getString(Strings.selectedLanguageCode) ?? Strings.spanishLanguageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case Strings.englishLanguageCode:
      return const Locale(Strings.englishLanguageCode, '');
    case Strings.spanishLanguageCode:
      return const Locale(Strings.spanishLanguageCode, '');
    case Strings.germanLanguageCode:
      return const Locale(Strings.germanLanguageCode, '');
    case Strings.portugueseLanguageCode:
      return const Locale(Strings.portugueseLanguageCode, '');
    case Strings.italianLanguageCode:
      return const Locale(Strings.italianLanguageCode, '');
    case Strings.frenchLanguageCode:
      return const Locale(Strings.frenchLanguageCode, '');
    default:
      return const Locale(Strings.englishLanguageCode, '');

  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
