import 'package:flutter/material.dart';

class MyColours {
  var primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB((0.06 * 250).toInt(), 221, 214, 174),
      Color.fromARGB((0.43 * 250).toInt(), 203, 196, 159),
      Color.fromARGB((0.56 * 250).toInt(), 119, 115, 94),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  Color primary = Color.fromARGB(248, 25, 70, 36);
   Color secondary = Color.fromARGB(250,221, 214, 174); 
   Color background = Color.fromARGB(250, 4, 36, 12);
   Color yellow = Colors.yellow;
   Color blue = Colors.blue;
   Color bg2 = Color.fromARGB(248, 25, 70, 36);
   Color get blendedprimary => Color.fromARGB(248, 25, 70, 36);
   Color informational = Color.fromARGB(250, 19, 126, 132);
   Color warning = Color.fromARGB(250, 255, 180, 171);
    Color error = Color.fromARGB(255, 255, 0, 0);
  Color textPrimary = Color.fromARGB(250,221, 214, 174);
  Color get textSecondary => blendedprimary;
  Color textMuted = Color.fromARGB(150, 194, 200, 191);
  Color searchBar = Color.fromARGB(248, 47, 77, 55);
  Color category = Color.fromARGB(250, 28, 28, 27);
 Color light = Colors.white;
  Color greenAccents = Color.fromARGB(255, 0, 230, 118);
  Color whiteAccents = Color.fromARGB(255, 255, 255, 255);

  double bodyFontSize = 16;
  double bodyFontSize2 = 14;
  double bodyFontSize3 = 12;
  double bodyFontSize4 = 10;  

  double headingFontSize1 = 24;
  double headingFontSize2 = 20;
  double headingFontSize3 = 18;


  double bdSize = 40;


  double theadingFontSize2 = 20;
  double theadingFontSize3 = 18;

  double bdHeight = 48;
 
  double lineheight2 = 30;
  double lineheight3 = 26;
 
  double bodylineheight = 18;
  double bodylineheight2 = 14;
  double bodylineheight3 = 12;
  double bodylineheight4 = 10;
  

  
  Color cardText = const Color(0xFFDDD6AE);

  static bool isDark = true;

  TextStyle get title => TextStyle(
    fontSize: headingFontSize3,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: lineheight2 / headingFontSize3,
    letterSpacing: 0,
    fontFamily: 'PressStart2P',
  );

  TextStyle get bigDisplay => TextStyle(
    fontSize: bdSize,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: bdHeight / bdSize,
    letterSpacing: -1.2,
    fontFamily: 'SpaceGrotesk',
  );

  TextStyle get h1 => TextStyle(
    fontSize: theadingFontSize2,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: lineheight2 / theadingFontSize2,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );

  TextStyle get h2 => TextStyle(
    fontSize: headingFontSize2,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: lineheight3 / headingFontSize2,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );

  TextStyle get warntext => TextStyle(
    fontSize: headingFontSize2,
    fontWeight: FontWeight.w700,
    color: warning,
    height: lineheight3 / headingFontSize2,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );

  TextStyle get h4 => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w700,
    color: textMuted,
    height: bodylineheight / bodyFontSize2,
    letterSpacing: 1.4,
    fontFamily: 'JetBrainsMono',
  );

  TextStyle get b1 => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: bodylineheight / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'JetBrainsMono',
  );

  TextStyle get categorytext => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w700,
    color: light,
    height: bodylineheight / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'HankenGrotesk',
  );

  TextStyle get budgetheader => TextStyle(
    fontSize: bodyFontSize,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: bodylineheight / bodyFontSize,
    letterSpacing: 0,
    fontFamily: 'HankenGrotesk',
  );

  TextStyle get altbodytext => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: bodylineheight / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'JetBrainsMono',
  );

  TextStyle get searchtext => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w500,
    color: light,
    height: bodylineheight2 / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'JetBrainsMono',
  );

  TextStyle get b2 => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: bodylineheight2 / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'JetBrainsMono',
  );



TextStyle get b3 => TextStyle(
    fontSize: bodyFontSize2,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: bodylineheight2 / bodyFontSize2,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );
  
TextStyle get b5 => TextStyle(
    fontSize: bodyFontSize4,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: bodylineheight4 / bodyFontSize4,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );
  
TextStyle get b4 => TextStyle(
    fontSize: bodyFontSize3,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: bodylineheight3 / bodyFontSize3,
    letterSpacing: 0,
    fontFamily: 'SpaceGrotesk',
  );

  MyColours() {
    if (!isDark) {
      background = const Color(0xFFDDD6AE);
      secondary = const Color(0xFF04240C);
      textPrimary = const Color(0xFF04240C);
      primary     = const Color(0xFF04240C); 
     

  }}}