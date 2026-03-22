import 'package:flutter/material.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../widgets/typewriter_engine.dart';
import 'terminal_controller.dart';

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
    _engine = TypewriterEngine(
      lines: FastfetchBuilder.buildLines(),
      onLineComplete: (line) {
        if (mounted) widget.controller.appendLine(line);
      },
      onDone: () {
        if (!mounted) return;
        widget.controller.appendLines(FastfetchBuilder.buildFooter());
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

class FastfetchBuilder {
  static const double _breakpoint = 576.0;

  static const List<String> _artRows = [
    '                                      ',
    '                                      ',
    '                  =======.              ',
    '                =======.                ',
    '              -======.                  ',
    '            .======-                    ',
    '          .=======                      ',
    '        .=======   .......              ',
    '        .=====   =======.               ',
    '          .=   -======.                 ',
    '             .======-                   ',
    '              -====##:                  ',
    '                =######.                ',
    '                  #######.              ',
    '                                      ',
    '                                      ',
  ];

  static const List<String> _infoLines = [
    'visitor@portfolio',
    '─────────────────────────────────',
    'OS:        Flutter Web',
    'Shell:     portfolio.sh',
    'Name:      Aritra Sanyal',
    'Role:      Flutter Developer',
    'Location:  Jaipur, India',
    'GitHub:    AritraSanyal',
    'Skills:    Flutter · Dart · Firebase',
    'Projects:  1 shipped apps',
    'Contact:   aritra.sanyal.official@gmail.com',
  ];

  static FastfetchDisplay buildDisplay() {
    return FastfetchDisplay(
      artRows: _artRows,
      infoLines: _infoLines,
      breakpoint: _breakpoint,
    );
  }

  static List<Widget> buildLines() => [buildDisplay()];

  static List<Widget> buildFooter() => [
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

class FastfetchDisplay extends StatelessWidget {
  final List<String> artRows;
  final List<String> infoLines;
  final double breakpoint;

  const FastfetchDisplay({
    super.key,
    required this.artRows,
    required this.infoLines,
    required this.breakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= breakpoint;
        return isWide ? _buildSideBySide() : _buildStacked();
      },
    );
  }

  Widget _buildSideBySide() {
    final artColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: artRows.map((row) => _buildArtRow(row)).toList(),
    );

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: infoLines.map((line) => _buildInfoLine(line)).toList(),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        artColumn,
        const SizedBox(width: 24),
        infoColumn,
      ],
    );
  }

  Widget _buildStacked() {
    final artColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: artRows.map((row) => _buildArtRow(row)).toList(),
    );

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: infoLines.map((line) => _buildInfoLine(line)).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: artColumn),
        const SizedBox(height: 8),
        infoColumn,
      ],
    );
  }

  Widget _buildArtRow(String row) {
    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (int i = 0; i < row.length; i++) {
      final char = row[i];
      if (char == '=' || char == '-' || char == '.') {
        if (i > lastEnd) {
          spans.add(TextSpan(
            text: row.substring(lastEnd, i),
            style: GruvboxText.body(color: GruvboxColors.cyan, size: 11),
          ));
        }
        spans.add(TextSpan(
          text: char,
          style: GruvboxText.body(color: const Color(0xFFfe8019), size: 11),
        ));
        lastEnd = i + 1;
      }
    }

    if (lastEnd < row.length) {
      spans.add(TextSpan(
        text: row.substring(lastEnd),
        style: GruvboxText.body(color: GruvboxColors.cyan, size: 11),
      ));
    }

    if (spans.isEmpty) {
      return RichText(
          text: TextSpan(text: ' ', style: GruvboxText.body(size: 11)));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildInfoLine(String line) {
    final colonIndex = line.indexOf(':');
    if (colonIndex > 0) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${line.substring(0, colonIndex + 1)} ',
              style: GruvboxText.body(color: GruvboxColors.cyan),
            ),
            TextSpan(
              text: line.substring(colonIndex + 1).trimLeft(),
              style: GruvboxText.body(color: GruvboxColors.body),
            ),
          ],
        ),
      );
    }
    if (line.startsWith('-')) {
      return RichText(
        text: TextSpan(
          text: line,
          style: GruvboxText.body(color: GruvboxColors.surface),
        ),
      );
    }
    return RichText(
      text: TextSpan(
        text: line,
        style: GruvboxText.body(color: GruvboxColors.yellow),
      ),
    );
  }
}
