import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_model/core/routes.dart';
import 'package:i_model/core/strings.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Change to your desired color
      statusBarIconBrightness: Brightness.dark, // For white icons
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(800, 1280),
      minTextAdapt: true,
      builder:  (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'I-Model',
          theme: ThemeData(
            textTheme: GoogleFonts.oswaldTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: Strings.initialScreen,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
