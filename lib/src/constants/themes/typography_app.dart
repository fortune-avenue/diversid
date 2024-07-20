import 'package:diversid/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyApp {
  static TextStyle headline1 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(26),
    fontWeight: FontWeight.w700,
    color: ColorApp.black,
  );

  static TextStyle headline2 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(24),
    fontWeight: FontWeight.w700,
    color: ColorApp.black,
  );

  static TextStyle headline3 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(20),
    fontWeight: FontWeight.w600,
    color: ColorApp.black,
  );

  static TextStyle text1 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w500,
    color: ColorApp.black,
  );

  static TextStyle text2 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w400,
    color: ColorApp.black,
  );

  static TextStyle subText1 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: ScreenUtil().setSp(10),
    fontWeight: FontWeight.w300,
    color: ColorApp.black,
  );
}
