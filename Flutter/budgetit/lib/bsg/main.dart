import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';
import 'main.directories.g.dart';
import 'package:budgetit/utils/app_colour.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      initialRoute: 'Flutter/budgetit/lib/BrandStyleGuide/intro.dart',
      directories: directories,
      addons: [
        
        MaterialThemeAddon(

          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData(brightness: Brightness.light, extensions: [MyColours.lightTheme])),
             WidgetbookTheme(name: 'Dark', data: ThemeData(brightness: Brightness.dark, extensions: [MyColours.darkTheme])),
          ],
        ),
      
      ],
    );
  }
}