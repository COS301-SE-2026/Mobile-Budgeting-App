import 'package:flutter/material.dart';

class MyColours{
    var primaryGradient = LinearGradient(
    colors: [Color.fromARGB((0.06 * 250).toInt(), 221, 214, 174), Color.fromARGB((0.43 * 250).toInt(),203, 196, 159),Color.fromARGB((0.56 * 250).toInt(), 119, 115, 94)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  Color primary = Color.fromARGB(23,221, 214, 174);
   Color secondary = Color.fromARGB(250,221, 214, 174); 
   Color background = Color.fromARGB(250, 4, 36, 12);
   Color informational = Color.fromARGB(250, 19, 126, 132);
   Color warning = Color.fromARGB(250, 255, 193, 7);
    Color error = Color.fromARGB(255, 255, 0, 0);
  Color textPrimary = Color.fromARGB(250,221, 214, 174);
 
  Color greenAccents = Color.fromARGB(255, 0, 230, 118);
  Color whiteAccents = Color.fromARGB(255, 255, 255, 255);
  
  double bodyFontSize = 16;
  double headingFontSize1 = 24;
  double headingFontSize2 = 20;
  double headingFontSize3 = 18;

  
  Color cardText = const Color(0xFFDDD6AE);

  static bool isDark = true;

  MyColours() {
    if (!isDark) {
      background  = const Color(0xFFDDD6AE);
      secondary   = const Color(0xFF04240C);
      textPrimary = const Color(0xFF04240C);
      primary     = const Color(0xFF04240C); 
      primaryGradient = const LinearGradient(
        colors: [
          Color(0xFF04240C),
          Color(0xFF0A3818),
          Color(0xFF104A22),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  
  Color get navBarColor => MyColours.isDark ? background : secondary;

}