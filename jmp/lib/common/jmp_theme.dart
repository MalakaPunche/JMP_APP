import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_classes_with_only_static_members
class JMPTheme {
  static const List<Color> primaryGradient = [Color(0xFF4A90E2), Color(0xFF50E3C2)];
  static const Color primaryColor = Color(0xFF4A90E2); // Using first color as primary
  static const Color secondaryColor = Color(0xFF50E3C2);
  static const Color tertiaryColor = Color(0xFFFFFFFF);

  String primaryFontFamily = 'Poppins';
  String secondaryFontFamily = 'Roboto';
  static TextStyle get title1 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF303030),
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  static TextStyle get title2 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF303030),
        fontWeight: FontWeight.w500,
        fontSize: 22,
      );
  static TextStyle get title3 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF303030),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  static TextStyle get subtitle1 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF757575),
        fontWeight: FontWeight.w500,
        fontSize: 18,
      );
  static TextStyle get subtitle2 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF616161),
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  static TextStyle get bodyText1 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF303030),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  static TextStyle get bodyText2 => const TextStyle(
        fontFamily: 'NotoSansKhmer',
        color: Color(0xFF424242),
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              height: lineHeight,
            );
}
