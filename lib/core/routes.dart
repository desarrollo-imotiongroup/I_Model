import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/login_screen.dart';
import 'package:i_model/views/unknown_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Strings.initialScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      default:
        return MaterialPageRoute(builder: (_) => const UnKnownScreen());
    }
  }
}
