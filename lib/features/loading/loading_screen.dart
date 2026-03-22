import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../config/constants.dart';
import '../terminal/terminal_page.dart';
import 'loading_controller.dart';
import 'glitch_bar.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _navigated = false;
  bool _skipRequested = false;
  bool _fontsLoaded = false;
  final FocusNode _skipFocus = FocusNode();

  static const double _minDisplaySec = 2.0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (TerminalConstants.loadingDurationSec * 1000).round(),
      ),
    )
      ..addListener(_onAnimationUpdate)
      ..forward();

    _loadFonts();
  }

  Future<void> _loadFonts() async {
    try {
      final fontLoader = FontLoader('JetBrains Mono');
      fontLoader.addFont(() async {
        final fontData = await rootBundle
            .load('packages/google_fonts/fonts/JetBrainsMono-Regular.ttf');
        return fontData.buffer.asByteData()!;
      }());
      await fontLoader.load();
    } catch (e) {
      debugPrint('Font loading error: $e');
    }

    if (mounted) {
      setState(() => _fontsLoaded = true);
    }
  }

  void _onAnimationUpdate() {
    if (!mounted) return;
    setState(() {});

    final t = _controller.value;
    final elapsed =
        DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    final minTimePassed = elapsed >= _minDisplaySec;
    final ready = minTimePassed && _fontsLoaded;

    final shouldNavigate = _skipRequested || (ready && t >= 1.0);

    if (shouldNavigate && !_navigated) {
      _navigated = true;
      _navigate();
    }
  }

  void _navigate() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const TerminalPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _skipFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _controller.value.clamp(0.0, 1.0);
    final elapsed =
        DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    final minTimePassed = elapsed >= _minDisplaySec;
    final ready = minTimePassed && _fontsLoaded;

    final state = LoadingController.compute(t, isReady: ready);
    final screenW = MediaQuery.of(context).size.width;
    final barW = (screenW * TerminalConstants.loadingBarWidthRatio)
        .clamp(0.0, TerminalConstants.loadingBarMaxWidth);

    final safeStatusOpacity = state.statusOpacity.clamp(0.0, 1.0);
    final safeOverlayOpacity = state.overlayOpacity.clamp(0.0, 1.0);
    final safeSkipHintOpacity = state.skipHintOpacity.clamp(0.0, 1.0);

    String statusText;
    if (ready) {
      statusText = 'Ready! Press Enter to continue or wait...';
    } else {
      statusText = '${state.statusText}';
    }

    final fontStatus = _fontsLoaded ? '[Done]' : '[Loading fonts...]';

    return GestureDetector(
      onTap: () => setState(() => _skipRequested = true),
      child: RawKeyboardListener(
        focusNode: _skipFocus,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            setState(() => _skipRequested = true);
          }
        },
        child: ColoredBox(
          color: GruvboxColors.bg_hard,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'portfolio.sh',
                      style: GruvboxText.body(
                        color: GruvboxColors.yellow,
                        size: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlitchBar(state: state, width: barW),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: safeStatusOpacity,
                      child: Text(
                        '$statusText $fontStatus',
                        style: GruvboxText.muted(size: 11),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Opacity(
                      opacity: safeSkipHintOpacity,
                      child: Text(
                        ready
                            ? 'Press Enter or click to continue'
                            : 'Press Enter or click to skip',
                        style: GruvboxText.muted(size: 10),
                      ),
                    ),
                  ],
                ),
              ),
              if (safeOverlayOpacity > 0)
                IgnorePointer(
                  child: ColoredBox(
                    color:
                        GruvboxColors.bg_hard.withOpacity(safeOverlayOpacity),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
