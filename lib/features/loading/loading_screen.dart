import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (TerminalConstants.loadingDurationSec * 1000).round(),
      ),
    )
      ..addListener(() {
        if (mounted) setState(() {});
        if (_controller.value >= 1.0 && !_navigated) {
          _navigated = true;
          _navigate();
        }
      })
      ..forward();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _controller.value.clamp(0.0, 1.0);
    final state = LoadingController.compute(t);
    final screenW = MediaQuery.of(context).size.width;
    final barW = (screenW * TerminalConstants.loadingBarWidthRatio)
        .clamp(0.0, TerminalConstants.loadingBarMaxWidth);

    // Clamp all opacity values defensively at render time
    final safeStatusOpacity = state.statusOpacity.clamp(0.0, 1.0);
    final safeOverlayOpacity = state.overlayOpacity.clamp(0.0, 1.0);

    return ColoredBox(
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
              ],
            ),
          ),
          // Zoom overlay fade (phase 4)
          if (safeOverlayOpacity > 0)
            IgnorePointer(
              child: ColoredBox(
                color: GruvboxColors.bg_hard
                    .withOpacity(safeOverlayOpacity),
              ),
            ),
        ],
      ),
    );
  }
}
