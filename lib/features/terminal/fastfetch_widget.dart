import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../widgets/typewriter_engine.dart';
import 'terminal_controller.dart';

const _artRows = [
  r'   ______     __  __                ',
  r'  / ____/    / /_/ /____  __________',
  r' / /_   __  / __/ __/ _ \/ ___/ ___/',
  r'/ __/  /_/ / /_/ /_/  __/ /  (__  ) ',
  r'/_/       \__/\__/\___/_/  /____/   ',
];

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
    final lines = FastfetchLines.buildLines();
    _engine = TypewriterEngine(
      lines: lines,
      onLineComplete: (line) {
        if (mounted) widget.controller.appendLine(line);
      },
      onDone: () {
        if (!mounted) return;
        widget.controller.appendLines(FastfetchLines.footer());
      },
    );
    _engine!.start();
  }

  @override
  void dispose() {
    _engine?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class FastfetchLines {
  static RichText _row(List<TextSpan> spans) =>
      RichText(text: TextSpan(children: spans));

  static TextSpan _art(String t, {Color? color}) => TextSpan(
      text: t,
      style: GruvboxText.body(color: color ?? GruvboxColors.cyan, size: 11));

  static TextSpan _host(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.yellow));

  static TextSpan _sep(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.surface));

  static TextSpan _key(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.cyan));

  static TextSpan _val(String t) =>
      TextSpan(text: t, style: GruvboxText.body(color: GruvboxColors.body));

  static List<TextSpan> _artRow(int i) {
    switch (i) {
      case 0:
        return [_art(_artRows[0])];
      case 1:
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

  static List<Widget> buildLines() {
    const artW = 38;
    final infoLines = <List<TextSpan>>[
      [_host('visitor@portfolio')],
      [_sep('─────────────────────────────────')],
      [_key('OS       '), _val('Flutter Web')],
      [_key('Shell    '), _val('portfolio.sh')],
      [_key('Name     '), _val('TODO_NAME')],
      [_key('Role     '), _val('Flutter Developer')],
      [_key('Location '), _val('TODO_CITY')],
      [_key('GitHub   '), _val('TODO_GITHUB')],
      [_key('Skills   '), _val('Flutter · Dart · Firebase')],
      [_key('Projects '), _val('TODO_N shipped apps')],
      [_key('Contact  '), _val('TODO_EMAIL')],
    ];

    final rows = <Widget>[];
    final maxRows =
        infoLines.length > _artRows.length ? infoLines.length : _artRows.length;

    for (int i = 0; i < maxRows; i++) {
      final List<TextSpan> artSpans =
          i < _artRows.length ? _artRow(i) : [_art(' ' * artW)];
      final List<TextSpan> infoSpans = i < infoLines.length ? infoLines[i] : [];
      rows.add(_row([...artSpans, ...infoSpans]));
    }

    return rows;
  }

  static List<Widget> footer() {
    return [
      const SizedBox(height: 8),
      RichText(
        text: TextSpan(
          text:
              "Type 'help' for commands. 'ls' to explore. 'cat <file>' to read.",
          style: GruvboxText.body(color: GruvboxColors.faded),
        ),
      ),
      const SizedBox(height: 8),
    ];
  }
}
