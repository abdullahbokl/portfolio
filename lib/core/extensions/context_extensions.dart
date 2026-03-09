import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../constants/app_breakpoints.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  AccentTheme get accent => theme.extension<AccentTheme>()!;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppBreakpoints.mobile;

  bool get isTablet =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;

  bool get isDesktop => screenWidth >= AppBreakpoints.tablet;

  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}

