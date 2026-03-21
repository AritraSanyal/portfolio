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
  bool _isReady = false;
  final FocusNode _skipFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (TerminalConstants.loadingDurationSec * 1000).round(),
      ),
    )
      ..addListener(_onAnimationUpdate)
      ..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isReady = true);
    });
  }

  void _onAnimationUpdate() {
    if (!mounted) return;
    setState(() {});

    final t = _controller.value;
    final shouldNavigate = _skipRequested || (t >= 0.4 && _isReady) || t >= 1.0;

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
    final state = LoadingController.compute(t, isReady: _isReady);
    final screenW = MediaQuery.of(context).size.width;
    final barW = (screenW * TerminalConstants.loadingBarWidthRatio)
        .clamp(0.0, TerminalConstants.loadingBarMaxWidth);

    final safeStatusOpacity = state.statusOpacity.clamp(0.0, 1.0);
    final safeOverlayOpacity = state.overlayOpacity.clamp(0.0, 1.0);
    final safeSkipHintOpacity = state.skipHintOpacity.clamp(0.0, 1.0);

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
                        state.statusText,
                        style: GruvboxText.muted(size: 11),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Opacity(
                      opacity: safeSkipHintOpacity,
                      child: Text(
                        'Press Enter or click to skip',
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
