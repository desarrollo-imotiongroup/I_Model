import 'package:flutter/material.dart';
import 'package:i_model/core/strings.dart';
import 'package:i_model/views/clients_screen.dart';
import 'package:i_model/views/dashboard_screen.dart';
import 'package:i_model/views/login_screen.dart';
import 'package:i_model/views/menu/center_management_screen.dart';
import 'package:i_model/views/menu/license_screen.dart';
import 'package:i_model/views/menu/menu_screen.dart';
import 'package:i_model/views/programs_screen.dart';
import 'package:i_model/views/setting_screen.dart';
import 'package:i_model/views/tutorial_screen.dart';
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
      case Strings.clientScreen:
        return MaterialPageRoute(builder: (_) => ClientScreen());
      case Strings.tutorialScreen:
        return MaterialPageRoute(builder: (_) => TutorialScreen());
      case Strings.programsScreen:
        return MaterialPageRoute(builder: (_) => ProgramsScreen());
      case Strings.licenseScreen:
        return MaterialPageRoute(builder: (_) => LicenseScreen());
      case Strings.centerManagementScreen:
        return MaterialPageRoute(builder: (_) => CenterManagementScreen());

      default:
        return MaterialPageRoute(builder: (_) => const UnKnownScreen());
    }
  }
}
