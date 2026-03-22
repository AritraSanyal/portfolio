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

  static TextStyle muted({double size = 12}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.muted,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle prompt({double size = 12}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.green,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle command({double size = 12}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.yellow,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle tag() => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.yellow,
        fontSize: 10,
        letterSpacing: 0.2,
        height: 1.65,
      );

  static TextStyle infoLabel() => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.muted,
        fontSize: 10,
        letterSpacing: 0.14,
        height: 1.65,
      );

  static TextStyle infoValue({double? size}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.body,
        fontSize: size ?? 12,
        height: 1.85,
      );

  static TextStyle sectionTitle(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final clamped = (width * 0.028).clamp(18.0, 28.0);
    return GoogleFonts.jetBrainsMono(
      color: GruvboxColors.body,
      fontSize: clamped,
      fontWeight: FontWeight.bold,
      height: 1.65,
    );
  }

  static TextStyle link({double size = 12}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.blue,
        fontSize: size,
        height: 1.65,
        decoration: TextDecoration.underline,
      );

  static TextStyle faded({double size = 11}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.faded,
        fontSize: size,
        height: 1.7,
      );

  static TextStyle surface({double size = 11}) => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.surface,
        fontSize: size,
        height: 1.65,
      );

  static TextStyle footerLeft() => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.surface,
        fontSize: 11,
        height: 1.65,
      );

  static TextStyle footerRight() => GoogleFonts.jetBrainsMono(
        color: GruvboxColors.overlay,
        fontSize: 10,
        height: 1.65,
      );
}
