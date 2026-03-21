import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../widgets/typewriter_engine.dart';
import 'terminal_controller.dart';

// Flutter ASCII logo — 11 rows, fixed width 28 chars
// The "F" shape with the characteristic notch and crossbar
// Colors: cyan body, blue shadow, orange accent on crossbar dot
const _artRows = [
  r'   ______     __  __                ',
  r'  / ____/    / /_/ /____  __________',
  r' / /_   __  / __/ __/ _ \/ ___/ ___/',
  r'/ __/  /_/ / /_/ /_/  __/ /  (__  ) ',
  r'/_/       \__/\__/\___/_/  /____/   ',
];

// Which chars in each row are the "accent" (orange) vs body (cyan) vs shadow (blue)
// We'll color everything uniformly — cyan for body, with the dot on crossbar in orange

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

  // ── Helpers ─────────────────────────────────────────────────────────────────

  RichText _row(List<TextSpan> spans) =>
      RichText(text: TextSpan(children: spans));

  TextSpan _art(String t, {Color? color}) =>
      TextSpan(text: t, style: GruvboxText.body(color: color ?? GruvboxColors.cyan, size: 11));

  TextSpan _host(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.yellow));

  TextSpan _sep(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.surface));

  TextSpan _key(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.cyan));

  TextSpan _val(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.body));

  TextSpan _orange(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.orange));

  // ── Flutter ASCII art with colored segments ──────────────────────────────────
  // Row 0: "   ______     __  __                "  — plain cyan
  // Row 1: "  / ____/    / /_/ /____  __________" — cyan slash, orange underscores
  // Row 2: " / /_   __  / __/ __/ _ \/ ___/ ___/" — mixed
  // Row 3: "/ __/  /_/ / /_/ /_/  __/ /  (__  ) " — mixed
  // Row 4: "/_/       \__/\__/\___/_/  /____/   " — mixed

  List<TextSpan> _artRow(int i) {
    // Colorize the "Flutter" text components:
    // Slashes/underscores = cyan, "F","l","u","t","t","e","r" letters area = blue accent
    // The /__  crossbar area gets orange highlight
    switch (i) {
      case 0:
        return [_art(_artRows[0])];
      case 1:
        // highlight the underscores in orange as "crossbar" accent
        return [
          _art('  / '),
          _art('____', color: GruvboxColors.orange),
          _art('/    / /_/ /'),
          _art('____  ', color: GruvboxColors.orange),
          _art('__________'),
        ];
      case 2:
        return [
          _art(' / /'),
          _art('_', color: GruvboxColors.orange),
          _art('   __  / __/ __/ '),
          _art('_', color: GruvboxColors.orange),
          _art('__ '),
          _art(r'\'),
          _art('/ ___/ ___/'),
        ];
      case 3:
        return [
          _art('/ __/  /'),
          _art('_', color: GruvboxColors.orange),
          _art('/ / /_/ /_/  __/ /  ('),
          _art('__', color: GruvboxColors.orange),
          _art('  ) '),
        ];
      case 4:
        return [
          _art('/'),
          _art('_', color: GruvboxColors.orange),
          _art(r'/       \__/\__/\___/'),
          _art('_', color: GruvboxColors.orange),
          _art('/  /'),
          _art('____', color: GruvboxColors.orange),
          _art('/   '),
        ];
      default:
        return [_art(_artRows[i])];
    }
  }

  // ── Info rows paired with art rows ───────────────────────────────────────────

  static const _artPad = '  '; // left padding for info column

  List<Widget> _buildFastfetchLines() {
    // Art has 5 rows; info has more — extra info rows get blank art padding
    // Art row width is ~38 chars; we pad info to align
    const artW = 38;

    // Info lines (label + value pairs)
    // TODO: Replace TODO_ placeholders with your actual info
    final infoLines = <List<TextSpan>>[
      [_host('visitor@portfolio')],
      [_sep('─────────────────────────────────')],
      [_key('OS       '), _val('Flutter Web')],
      [_key('Shell    '), _val('portfolio.sh')],
      [_key('Name     '), _val('TODO_NAME')],     // TODO: your name
      [_key('Role     '), _val('Flutter Developer')],
      [_key('Location '), _val('TODO_CITY')],     // TODO: your city
      [_key('GitHub   '), _val('TODO_GITHUB')],   // TODO: your GitHub username
      [_key('Skills   '), _val('Flutter · Dart · Firebase')],
      [_key('Projects '), _val('TODO_N shipped apps')],  // TODO: number of apps
      [_key('Contact  '), _val('TODO_EMAIL')],    // TODO: your email
    ];

    final rows = <Widget>[];

    final maxRows = infoLines.length > _artRows.length
        ? infoLines.length
        : _artRows.length;

    for (int i = 0; i < maxRows; i++) {
      final List<TextSpan> artSpans = i < _artRows.length
          ? _artRow(i)
          : [_art(' ' * artW)];
      final List<TextSpan> infoSpans =
          i < infoLines.length ? infoLines[i] : [];

      rows.add(_row([...artSpans, ...infoSpans]));
    }

    return rows;
  }

  List<Widget> _buildFooter() {
    return [
      RichText(text: const TextSpan(text: '')),
      RichText(
        text: TextSpan(
          text: "Type 'help' for commands. 'ls' to explore. 'cat <file>' to read.",
          style: GruvboxText.body(color: GruvboxColors.faded),
        ),
      ),
      RichText(text: const TextSpan(text: '')),
    ];
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
