import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// [INFO]
/// Constant for colors to be used in the app with following the design system
class ColorApp {
  static const Color black = Color(0xFF1A1A1A);
  static const Color scaffold = Color(0xFFF2F2F2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFDE3333);
  static const Color green = Color(0xFF00BA88);
  static const Color primary = Color(0xFF06BEB6);
  static const Color secondary = Color(0xFF48B1BF);
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color yellow = Color(0xFFFFCE47);
  static const Color purple = Color(0xFF475BAE);
  static const Color lightPurple = Color(0xFF9F9BC0);
  static const Color grey = Color(0xFF999999);
  static const Color darkGrey = Color(0xFF333333);

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: ColorApp.grey.withOpacity(0.2),
      blurRadius: 16.r,
      offset: const Offset(0, 4),
    ),
  ];
}
