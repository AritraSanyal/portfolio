import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/text_styles.dart';
import '../widgets/typewriter_engine.dart';
import '../features/terminal/terminal_controller.dart';

class FastfetchWidget extends StatefulWidget {
  final TerminalController controller;

  const FastfetchWidget({super.key, required this.controller});

  @override
  State<FastfetchWidget> createState() => _FastfetchWidgetState();
}

class _FastfetchWidgetState extends State<FastfetchWidget> {
  TypewriterEngine? _engine;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    final lines = _buildFastfetchLines();
    _engine = TypewriterEngine(
      lines: lines,
      onLineComplete: (line) {
        if (mounted) widget.controller.appendLine(line);
      },
      onDone: () {
        if (!mounted) return;
        widget.controller.appendLines(_buildFooter());
      },
    );
    _engine!.start();
  }

  @override
  void dispose() {
    _engine?.cancel();
    super.dispose();
  }

  // ── Fastfetch content ───────────────────────────────────────────────────────

  List<Widget> _buildFastfetchLines() {
    RichText row(List<TextSpan> spans) =>
        RichText(text: TextSpan(children: spans));

    TextSpan art(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.muted));
    TextSpan artOrange(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.orange));
    TextSpan host(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.yellow));
    TextSpan sep(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.surface));
    TextSpan key(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.cyan));
    TextSpan val(String t) =>
        TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.body));

    // Fixed-width two-column layout: ASCII art (left) | info (right)
    // Each row is exactly paired.
    // TODO: Replace TODO_ placeholders with your actual info
    return [
      row([art('        .          .          '), host('visitor@portfolio')]),
      row([art('       /|          |\\         '), sep('─────────────────')]),
      row([art('      / |          | \\        '), key('OS: '),       val('Flutter Web')]),
      row([art('     /  |   '),  artOrange('[F]'),  art('   |  \\       '), key('Shell: '),   val('portfolio.sh')]),
      // TODO: Replace TODO_NAME with your actual name
      row([art('    /   |          |   \\      '), key('Name: '),     val('TODO_NAME')]),
      row([art('   /____|__________|____\\     '), key('Role: '),     val('Flutter Developer')]),
      // TODO: Replace TODO_CITY with your actual city
      row([art('   |                    |     '), key('Location: '), val('TODO_CITY')]),
      // TODO: Replace TODO_GITHUB with your GitHub username
      row([art('   |____________________|     '), key('GitHub: '),   val('TODO_GITHUB')]),
      row([art('                              '), key('Skills: '),   val('Flutter · Dart · Firebase')]),
      // TODO: Replace TODO_N with number of shipped apps
      row([art('                              '), key('Projects: '), val('TODO_N shipped apps')]),
      // TODO: Replace TODO_EMAIL with your actual email
      row([art('                              '), key('Contact: '),  val('TODO_EMAIL')]),
    ];
  }

  List<Widget> _buildFooter() {
    return [
      RichText(text: const TextSpan(text: '')), // blank line
      RichText(
        text: TextSpan(
          text: "Type 'ls' to explore. 'cat <file>' to read.",
          style: GruvboxText.body(color: GruvboxColors.faded),
        ),
      ),
      RichText(text: const TextSpan(text: '')), // blank line
    ];
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
