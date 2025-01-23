import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/login_screen.dart';
import 'package:i_model/views/menu_screen.dart';
import 'package:i_model/views/unknown_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Strings.initialScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Strings.menuScreen:
        return MaterialPageRoute(builder: (_) => MenuScreen());

      default:
        return MaterialPageRoute(builder: (_) => const UnKnownScreen());
    }
  }
}
