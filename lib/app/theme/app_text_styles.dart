import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/constants/app_breakpoints.dart';

abstract final class AppTextStyles {
  static TextStyle display(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 56.0
        : w > AppBreakpoints.mobile
            ? 44.0
            : 32.0;
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.1,
    );
  }

  static TextStyle h1(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 48.0
        : w > AppBreakpoints.mobile
            ? 36.0
            : 28.0;
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle h2(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 36.0
        : w > AppBreakpoints.mobile
            ? 28.0
            : 24.0;
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.2,
    );
  }

  static TextStyle h3(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 24.0
        : w > AppBreakpoints.mobile
            ? 22.0
            : 20.0;
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  static TextStyle body(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.mobile ? 16.0 : 15.0;
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 1.6,
    );
  }

  static TextStyle bodyBold(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.mobile ? 16.0 : 15.0;
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.6,
    );
  }

  static TextStyle caption(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 14.0
        : w > AppBreakpoints.mobile
            ? 13.0
            : 12.0;
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }

  static TextStyle code(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final size = w > AppBreakpoints.tablet
        ? 14.0
        : w > AppBreakpoints.mobile
            ? 13.0
            : 12.0;
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
  }
}


