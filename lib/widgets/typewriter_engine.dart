import 'dart:async';
import 'package:flutter/widgets.dart';
import '../config/constants.dart';

class TypewriterEngine {
  final List<Widget> lines;
  final int charDelayMs;
  final int lineDelayMs;
  final void Function(Widget line) onLineComplete;
  final void Function() onDone;

  Timer? _timer;
  bool _cancelled = false;

  TypewriterEngine({
    required this.lines,
    this.charDelayMs = TerminalConstants.typewriterCharMs,
    this.lineDelayMs = TerminalConstants.typewriterLineMs,
    required this.onLineComplete,
    required this.onDone,
  });

  void start() {
    _cancelled = false;
    _emitLine(0);
  }

  void _emitLine(int index) {
    if (_cancelled) return;
    if (index >= lines.length) {
      onDone();
      return;
    }

    onLineComplete(lines[index]);

    _timer = Timer(
      Duration(milliseconds: lineDelayMs),
      () => _emitLine(index + 1),
    );
  }

  void cancel() {
    _cancelled = true;
    _timer?.cancel();
  }
}
