import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class GruvboxText {
  GruvboxText._();

  static TextStyle body({Color? color, double size = 12}) =>
      GoogleFonts.jetBrainsMono(
        color: color ?? GruvboxColors.body,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle heading({Color? color, double size = 13}) =>
      GoogleFonts.jetBrainsMono(
        color: color ?? GruvboxColors.yellow,
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.65,
      );

  static TextStyle muted({double size = 12}) =>
      GoogleFonts.jetBrainsMono(
        color: GruvboxColors.muted,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle prompt({double size = 12}) =>
      GoogleFonts.jetBrainsMono(
        color: GruvboxColors.green,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle command({double size = 12}) =>
      GoogleFonts.jetBrainsMono(
        color: GruvboxColors.yellow,
        fontSize: size,
        height: 1.65,
      );
}
