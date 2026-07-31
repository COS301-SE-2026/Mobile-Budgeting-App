// lib/landing_page/main.dart
import 'package:flutter/material.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/shared/widgets/landingpage/landing_page.dart';

void main() {
  runApp(const LandingApp());
}

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [MyColours.lightTheme],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [MyColours.darkTheme],
      ),
      home: const LandingPage(),
    );
  }
}