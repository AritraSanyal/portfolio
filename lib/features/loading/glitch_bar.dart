import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import 'loading_controller.dart';

class GlitchBar extends StatelessWidget {
  final LoadingState state;
  final double width;

  const GlitchBar({
    super.key,
    required this.state,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(state.shakeOffset, 0),
      child: Transform.scale(
        scale: state.phase == LoadingPhase.zoom ? state.scaleZoom : 1.0,
        child: _buildBar(),
      ),
    );
  }

  Widget _buildBar() {
    final barH = state.barHeight;
    final fillW = width * state.fillFraction;

    Widget bar = Container(
      width: width,
      height: barH,
      decoration: BoxDecoration(
        color: GruvboxColors.overlay,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: fillW,
          height: barH,
          decoration: BoxDecoration(
            color: state.fillColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );

    // Apply blur in glitch phase
    if (state.blurSigma > 0) {
      bar = ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: state.blurSigma,
          sigmaY: state.blurSigma / 2,
        ),
        child: bar,
      );
    }

    if (!state.showGhosts) return bar;

    // Ghost layers
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Ghost 1: +3px right, red
        Positioned(
          left: 3,
          child: Opacity(
            opacity: state.ghostOpacity,
            child: _buildFillOnly(fillW, barH, GruvboxColors.red),
          ),
        ),
        // Ghost 2: -3px left, blue
        Positioned(
          left: -3,
          child: Opacity(
            opacity: state.ghostOpacity,
            child: _buildFillOnly(fillW, barH, GruvboxColors.blue),
          ),
        ),
        // Main bar on top
        bar,
      ],
    );
  }

  Widget _buildFillOnly(double fillW, double barH, Color color) {
    return Container(
      width: fillW,
      height: barH,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
