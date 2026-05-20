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
   Color tertiary = Color.fromARGB(250, 19, 126, 132);
  Color textPrimary = Color.fromARGB(250,221, 214, 174);
  
  double bodyFontSize = 16;
  double headingFontSize1 = 24;
  double headingFontSize2 = 20;
  double headingFontSize3 = 18;
  

}