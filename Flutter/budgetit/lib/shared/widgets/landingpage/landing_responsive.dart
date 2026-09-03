import 'package:flutter/material.dart';

const Color kAmber = Color(0xFFDDD6AE);
const Color kCream = Color(0xFFDDD6AE);

class LandingBreakpoints {
  static const double desktop = 1100;
  static const double tablet = 800;
  static const double mobile = 520;
}

extension LandingResponsiveContext on BuildContext {
  double get _width => MediaQuery.of(this).size.width;
  bool get isDesktop => _width >= LandingBreakpoints.desktop;
  bool get isTablet =>
      _width < LandingBreakpoints.desktop && _width >= LandingBreakpoints.tablet;
  bool get isMobile => _width < LandingBreakpoints.tablet;
  bool get isSmallMobile => _width < LandingBreakpoints.mobile;

  double get sectionHPadding {
    if (isSmallMobile) return 20;
    if (isMobile) return 28;
    if (isTablet) return 40;
    return 60;
  }

  int get featureColumns {
    if (isMobile) return 1;
    return 2;
  }
}