import 'package:budgetit/shared/widgets/help_menu_page.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
Widget wrapHelpMenu() {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme: ThemeData(
        extensions: [MyColours.lightTheme],
      ),
      home: const HelpMenuPage(),
    ),
  );~
}