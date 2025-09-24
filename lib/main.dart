import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager_app/di/service_locator.dart';
import 'package:task_manager_app/splash_screen/splash_screen.dart';

void main() {
  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task manager app',

        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          useMaterial3: false,


        colorScheme: ColorScheme.fromSeed(seedColor:  Colors.indigoAccent,),
      ),
      home: const SplashScreen(),
    );
  }
}

