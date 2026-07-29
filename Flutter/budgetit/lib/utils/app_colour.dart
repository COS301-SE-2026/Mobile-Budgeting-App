import 'package:flutter/material.dart';

class MyColours extends ThemeExtension<MyColours> {
  const MyColours({
    required this.primaryGradient,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.yellow,
    required this.blue,
    required this.bg2,
    required this.blendedprimary,
    required this.informational,
    required this.warning,
    required this.error,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.searchBar,
    required this.category,
    required this.light,
    required this.greenAccents,
    required this.whiteAccents,
    required this.cardText,
  });

  final LinearGradient primaryGradient;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color yellow;
  final Color blue;
  final Color bg2;
  final Color blendedprimary;
  final Color informational;
  final Color warning;
  final Color error;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color searchBar;
  final Color category;
  final Color light;
  final Color greenAccents;
  final Color whiteAccents;
  final Color cardText;

  static const double bodyFontSize = 16;
  static const double bodyFontSize2 = 14;
  static const double bodyFontSize3 = 12;
  static const double bodyFontSize4 = 10;

  static const double headingFontSize1 = 24;
  static const double headingFontSize2 = 20;
  static const double headingFontSize3 = 18;

  static const double bdSize = 40;

  static const double theadingFontSize2 = 20;
  static const double theadingFontSize3 = 18;

  static const double bdHeight = 48;

  static const double lineheight2 = 30;
  static const double lineheight3 = 26;

  static const double bodylineheight = 18;
  static const double bodylineheight2 = 14;
  static const double bodylineheight3 = 12;
  static const double bodylineheight4 = 10;

  // Shared gradient — identical in both original variants.
  static final LinearGradient _sharedGradient = LinearGradient(
    colors: [
      Color.fromARGB((0.06 * 250).toInt(), 221, 214, 174),
      Color.fromARGB((0.43 * 250).toInt(), 203, 196, 159),
      Color.fromARGB((0.56 * 250).toInt(), 119, 115, 94),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark theme — matches original defaults (isDark = true).
  static final MyColours darkTheme = MyColours(
    primaryGradient: _sharedGradient,
    primary: const Color.fromARGB(248, 25, 70, 36),
    secondary: const Color.fromARGB(250, 221, 214, 174),
    background: const Color.fromARGB(250, 4, 36, 12),
    yellow: Colors.yellow,
    blue: Colors.blue,
    bg2: const Color.fromARGB(248, 25, 70, 36),
    blendedprimary: const Color.fromARGB(248, 25, 70, 36),
    informational: const Color.fromARGB(250, 19, 126, 132),
    warning: const Color.fromARGB(250, 255, 180, 171),
    error: const Color.fromARGB(255, 255, 0, 0),
    textPrimary: const Color.fromARGB(250, 221, 214, 174),
    textSecondary: const Color.fromARGB(248, 25, 70, 36), 
    textMuted: const Color.fromARGB(150, 194, 200, 191),
    searchBar: const Color.fromARGB(248, 47, 77, 55),
    category: const Color.fromARGB(250, 28, 28, 27),
    light: Colors.white,
    greenAccents: const Color.fromARGB(255, 0, 230, 118),
    whiteAccents: const Color.fromARGB(255, 255, 255, 255),
    cardText: const Color(0xFFDDD6AE),
  );


  static final MyColours lightTheme = MyColours(
    primaryGradient: _sharedGradient,
    primary: const Color(0xFF04240C),
    secondary: const Color(0xFF04240C),
    background: const Color(0xFFDDD6AE),
    yellow: Colors.yellow,
    blue: Colors.blue,
    bg2: const Color.fromARGB(248, 25, 70, 36),
    blendedprimary: const Color.fromARGB(248, 25, 70, 36),
    informational: const Color.fromARGB(250, 19, 126, 132),
    warning: const Color.fromARGB(250, 255, 180, 171),
    error: const Color.fromARGB(255, 255, 0, 0),
    textPrimary: const Color(0xFF04240C),
    textSecondary: const Color.fromARGB(248, 25, 70, 36), 
    textMuted: const Color.fromARGB(150, 194, 200, 191),
    searchBar: const Color.fromARGB(248, 47, 77, 55),
    category: const Color.fromARGB(250, 28, 28, 27),
    light: Colors.white,
    greenAccents: const Color.fromARGB(255, 0, 230, 118),
    whiteAccents: const Color.fromARGB(255, 255, 255, 255),
    cardText: const Color(0xFFDDD6AE),
  );

  @override
  MyColours copyWith({
    LinearGradient? primaryGradient,
    Color? primary,
    Color? secondary,
    Color? background,
    Color? yellow,
    Color? blue,
    Color? bg2,
    Color? blendedprimary,
    Color? informational,
    Color? warning,
    Color? error,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? searchBar,
    Color? category,
    Color? light,
    Color? greenAccents,
    Color? whiteAccents,
    Color? cardText,
  }) {
    return MyColours(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      yellow: yellow ?? this.yellow,
      blue: blue ?? this.blue,
      bg2: bg2 ?? this.bg2,
      blendedprimary: blendedprimary ?? this.blendedprimary,
      informational: informational ?? this.informational,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      searchBar: searchBar ?? this.searchBar,
      category: category ?? this.category,
      light: light ?? this.light,
      greenAccents: greenAccents ?? this.greenAccents,
      whiteAccents: whiteAccents ?? this.whiteAccents,
      cardText: cardText ?? this.cardText,
    );
  }

  @override
  MyColours lerp(ThemeExtension<MyColours>? other, double t) {
    if (other is! MyColours) return this;
    return MyColours(
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      bg2: Color.lerp(bg2, other.bg2, t)!,
      blendedprimary: Color.lerp(blendedprimary, other.blendedprimary, t)!,
      informational: Color.lerp(informational, other.informational, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      searchBar: Color.lerp(searchBar, other.searchBar, t)!,
      category: Color.lerp(category, other.category, t)!,
      light: Color.lerp(light, other.light, t)!,
      greenAccents: Color.lerp(greenAccents, other.greenAccents, t)!,
      whiteAccents: Color.lerp(whiteAccents, other.whiteAccents, t)!,
      cardText: Color.lerp(cardText, other.cardText, t)!,
    );
  }

  

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

  TextStyle get b4 => TextStyle(
        fontSize: bodyFontSize3,
        fontWeight: FontWeight.w500,
        color: textMuted,
        height: bodylineheight3 / bodyFontSize3,
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
}

extension MyColoursContext on BuildContext {
  MyColours get colours => Theme.of(this).extension<MyColours>()!;
} //used Deepseek to help troubleshoot problems with setting up context ONLY

