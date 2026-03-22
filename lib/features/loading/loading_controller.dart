import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';

enum LoadingPhase { boot, shaking, glitch, zoom }

class LoadingState {
  final LoadingPhase phase;
  final double fillFraction;
  final double barHeight;
  final double blurSigma;
  final double shakeOffset;
  final double ghostOpacity;
  final double statusOpacity;
  final bool showGhosts;
  final String statusText;
  final double progressPercent;
  final Color fillColor;
  final double scaleZoom;
  final double overlayOpacity;
  final bool isReady;
  final double skipHintOpacity;

  const LoadingState({
    required this.phase,
    required this.fillFraction,
    required this.barHeight,
    required this.blurSigma,
    required this.shakeOffset,
    required this.ghostOpacity,
    required this.statusOpacity,
    required this.showGhosts,
    required this.statusText,
    required this.progressPercent,
    required this.fillColor,
    required this.scaleZoom,
    required this.overlayOpacity,
    required this.isReady,
    required this.skipHintOpacity,
  });
}

class LoadingController {
  static const List<String> _glitchFrames = [
    'Almost there...',
    'Alm0st th3r3...',
    'A1m!st th3r3...',
    '#lm05t +h3r3...',
    'Almost there...',
    'A!m#st t#3re...',
  ];

  static final math.Random _rng = math.Random();

  static double _clamp(double v) => v.clamp(0.0, 1.0);

  static LoadingState compute(double t, {bool isReady = false}) {
    final skipHintOpacity = t >= 0.33 ? _clamp((t - 0.33) / 0.17) : 0.0;

    // Smooth progress based on actual t value (0-100%)
    final displayProgress = (t * 100).round().toDouble();

    // When ready, show progress at 100%
    final progress = isReady ? 100.0 : displayProgress;

    // Phase 1: Boot (0.0 to 0.25)
    if (t < 0.25) {
      final local = _clamp(t / 0.25);
      return LoadingState(
        phase: LoadingPhase.boot,
        fillFraction: local * 0.20,
        barHeight: TerminalConstants.loadingBarHeight,
        blurSigma: 0,
        shakeOffset: 0,
        ghostOpacity: 0,
        statusOpacity: 1.0,
        showGhosts: false,
        statusText: '${progress.round()}% -- Loading fonts...',
        progressPercent: isReady ? 100 : local * 20,
        fillColor: GruvboxColors.green,
        scaleZoom: 1.0,
        overlayOpacity: 0.0,
        isReady: isReady,
        skipHintOpacity: skipHintOpacity,
      );
    }

    // Phase 2: Shaking (0.25 to 0.55)
    if (t < 0.55) {
      final local = _clamp((t - 0.25) / 0.30);
      final amplitude = 4.0 + local * 4.0;
      final shake = math.sin(t * 60) * amplitude;
      final pulse = _clamp(0.4 + 0.6 * ((math.sin(t * 20) + 1) / 2));
      return LoadingState(
        phase: LoadingPhase.shaking,
        fillFraction: _clamp(0.20 + local * 0.40),
        barHeight: TerminalConstants.loadingBarHeight,
        blurSigma: 0,
        shakeOffset: shake,
        ghostOpacity: 0,
        statusOpacity: pulse,
        showGhosts: false,
        statusText: '${progress.round()}% -- Initializing...',
        progressPercent: isReady ? 100 : 20 + (local * 35),
        fillColor: GruvboxColors.yellow,
        scaleZoom: 1.0,
        overlayOpacity: 0.0,
        isReady: isReady,
        skipHintOpacity: skipHintOpacity,
      );
    }

    // Phase 3: Glitch (0.55 to 0.85)
    if (t < 0.85) {
      final local = _clamp((t - 0.55) / 0.30);
      final fillColor =
          Color.lerp(GruvboxColors.orange, GruvboxColors.red, local)!;
      final barH = TerminalConstants.loadingBarHeight + local * 20.0;
      final blurS = local * 3.0;
      final shakeX = (_rng.nextDouble() * 28) - 14;
      final glitchIdx = (t * 30).floor() % _glitchFrames.length;
      return LoadingState(
        phase: LoadingPhase.glitch,
        fillFraction: _clamp(0.60 + local * 0.30),
        barHeight: barH,
        blurSigma: blurS,
        shakeOffset: shakeX,
        ghostOpacity: 0.4,
        statusOpacity: 1.0,
        showGhosts: true,
        statusText: '${progress.round()}% -- ${_glitchFrames[glitchIdx]}',
        progressPercent: isReady ? 100 : 55 + (local * 30),
        fillColor: fillColor,
        scaleZoom: 1.0,
        overlayOpacity: 0.0,
        isReady: isReady,
        skipHintOpacity: skipHintOpacity,
      );
    }

    // Phase 4: Zoom (0.85 to 1.0)
    final local = _clamp((t - 0.85) / 0.15);
    final scale = 1.0 + local * 29.0;
    return LoadingState(
      phase: LoadingPhase.zoom,
      fillFraction: _clamp(0.90 + local * 0.10),
      barHeight: TerminalConstants.loadingBarHeight,
      blurSigma: 0,
      shakeOffset: 0,
      ghostOpacity: 0,
      statusOpacity: _clamp(1.0 - local),
      showGhosts: false,
      statusText: '100% -- Done.',
      progressPercent: 100,
      fillColor: GruvboxColors.redDark,
      scaleZoom: scale,
      overlayOpacity: _clamp(local),
      isReady: isReady,
      skipHintOpacity: 0.0,
    );
  }
}
