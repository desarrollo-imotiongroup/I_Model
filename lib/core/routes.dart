import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/dashboard_screen.dart';
import 'package:i_model/views/login_screen.dart';
import 'package:i_model/views/menu_screen.dart';
import 'package:i_model/views/setting_screen.dart';
import 'package:i_model/views/unknown_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Strings.initialScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Strings.menuScreen:
        return MaterialPageRoute(builder: (_) => MenuScreen());
      case Strings.settingScreen:
        return MaterialPageRoute(builder: (_) => SettingScreen());
      case Strings.dashboardScreen:
        return MaterialPageRoute(builder: (_) => DashboardScreen());

      default:
        return MaterialPageRoute(builder: (_) => const UnKnownScreen());
    }
  }
}
