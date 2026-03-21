import 'dart:async';
import 'package:flutter/material.dart';
import '../../commands/command_registry.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../config/constants.dart';
import '../../filesystem/easter_eggs.dart';
import '../../filesystem/virtual_fs.dart';
import '../../widgets/typewriter_engine.dart';

class TerminalController extends ChangeNotifier {
  final CommandRegistry registry;

  final List<Widget> outputLines = [];
  final List<String> _history = [];
  int _historyIndex = -1;

  final ScrollController scrollController = ScrollController();

  Timer? _cursorTimer;
  bool _cursorVisible = true;
  bool get cursorVisible => _cursorVisible;

  final Map<String, List<Widget>> _easterEggs = buildEasterEggs();

  // Commands that accept a filename as their first argument
  static const _fileCommands = {'cat', 'open'};

  // All known filenames from the virtual FS (public + hidden)
  static final List<String> _allFiles = [
    'about.md',
    'skills.md',
    'projects.md',
    'contact.md',
    'resume.pdf',
    '.secret'
  ];

  // Autocomplete suggestion state
  List<String> _suggestions = [];
  int _suggestionIndex = 0;
  String _currentInput = '';

  TerminalController({required this.registry}) {
    _cursorTimer = Timer.periodic(
      Duration(milliseconds: TerminalConstants.cursorBlinkMs),
      (_) {
        _cursorVisible = !_cursorVisible;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  // ── Scroll ──────────────────────────────────────────────────────────────────

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Output ──────────────────────────────────────────────────────────────────

  void appendLines(List<Widget> lines) {
    outputLines.addAll(lines);
    notifyListeners();
    _scheduleScrollToBottom();
  }

  void appendLine(Widget line) {
    outputLines.add(line);
    notifyListeners();
    _scheduleScrollToBottom();
  }

  void clear() {
    outputLines.clear();
    notifyListeners();
    _scheduleScrollToBottom();
  }

  // ── Input Handling ───────────────────────────────────────────────────────────

  Future<void> handleInput(String raw) async {
    final trimmed = raw.trim();

    appendLine(_buildPromptLine(trimmed));

    if (trimmed.isEmpty) return;

    _history.add(trimmed);
    _historyIndex = _history.length;

    final parts = trimmed.split(RegExp(r'\s+'));
    final cmd = parts[0].toLowerCase();
    final args = parts.sublist(1);

    if (cmd == 'clear') {
      clear();
      return;
    }

    final rawLower = trimmed.toLowerCase();
    if (_easterEggs.containsKey(rawLower)) {
      appendLines(_easterEggs[rawLower]!);
      return;
    }

    final handler = registry.resolve(cmd);
    if (handler != null) {
      final result = await handler.execute(args);
      if (result.isNotEmpty) {
        if (cmd == 'cat') {
          _typewriteLines(result);
        } else {
          appendLines(result);
        }
      }
      return;
    }

    appendLine(
      RichText(
        text: TextSpan(
          text: 'bash: $cmd: command not found',
          style: GruvboxText.body(color: GruvboxColors.red),
        ),
      ),
    );
  }

  void _typewriteLines(List<Widget> lines) {
    final engine = TypewriterEngine(
      lines: lines,
      onLineComplete: (line) => appendLine(line),
      onDone: () {},
    );
    engine.start();
  }

  Widget _buildPromptLine(String command) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'visitor@portfolio',
              style: GruvboxText.body(color: GruvboxColors.green)),
          TextSpan(text: ':', style: GruvboxText.body()),
          TextSpan(
              text: '~/portfolio',
              style: GruvboxText.body(color: GruvboxColors.blue)),
          TextSpan(text: r'$ ', style: GruvboxText.body()),
          TextSpan(text: command, style: GruvboxText.command()),
        ],
      ),
    );
  }

  // ── History navigation ───────────────────────────────────────────────────────

  String? historyUp() {
    if (_history.isEmpty) return null;
    _historyIndex = (_historyIndex - 1).clamp(0, _history.length - 1);
    return _history[_historyIndex];
  }

  String? historyDown() {
    if (_history.isEmpty) return null;
    _historyIndex++;
    if (_historyIndex >= _history.length) {
      _historyIndex = _history.length;
      return '';
    }
    return _history[_historyIndex];
  }

  // ── Smart Autocomplete ────────────────────────────────────────────────────────
  //
  // Handles three patterns:
  //   1. "ca"  → shows ghost "t" (single match) or cycles through options
  //   2. "cat " → shows ghost "about.md" (single match) or cycles through files
  //   3. "cat ski" → shows ghost "lls.md" for "skills.md"

  /// Returns the ghost suffix to show after the current input.
  /// Returns null if no single suggestion exists.
  String? ghostSuggest(String input) {
    if (input.isEmpty) {
      _suggestions = [];
      return null;
    }

    final trimmed = input.trim();
    final parts = trimmed.split(RegExp(r'\s+'));

    // Case 1: single token — complete command name
    if (parts.length == 1 && !trimmed.endsWith(' ')) {
      final prefix = parts[0].toLowerCase();
      final matches = registry.matchPrefix(prefix);

      if (matches.isNotEmpty) {
        _currentInput = input;
        final match = matches[0];
        if (match.length > input.length) {
          _suggestions = matches;
          _suggestionIndex = 0;
          return match.substring(input.length);
        }
        return null;
      }

      return null;
    }

    // Case 2 & 3: "cmd arg" or "cmd " — complete filename argument
    final cmd = parts[0].toLowerCase();
    if (!_fileCommands.contains(cmd)) {
      _suggestions = [];
      return null;
    }

    // The file prefix is whatever follows the command (may be empty string)
    final filePrefix =
        trimmed.endsWith(' ') ? '' : (parts.length > 1 ? parts[1] : '');

    final fileMatches = _allFiles
        .where((f) => f.toLowerCase().startsWith(filePrefix.toLowerCase()))
        .toList();

    if (fileMatches.isEmpty) {
      return null;
    }

    _currentInput = input;

    final fullMatch = '$cmd ${fileMatches[0]}';
    if (fullMatch.length > input.length) {
      _suggestions = fileMatches;
      _suggestionIndex = 0;
      return fullMatch.substring(input.length);
    }
    return null;
  }

  /// Cycles to the next suggestion. Returns the new ghost suffix.
  /// If input changed, resets suggestions first.
  String? cycleSuggestion(String input) {
    // If input changed, reset suggestions
    if (input != _currentInput) {
      ghostSuggest(input);
    }

    if (_suggestions.isEmpty) return null;
    if (_suggestions.length == 1) return null; // No cycling needed

    _suggestionIndex = (_suggestionIndex + 1) % _suggestions.length;

    final parts = input.trim().split(RegExp(r'\s+'));
    final isFileCommand = parts.length > 1 || input.trim().endsWith(' ');

    String newFull;
    if (isFileCommand && parts.isNotEmpty) {
      final cmd = parts[0];
      newFull = '$cmd ${_suggestions[_suggestionIndex]}';
    } else {
      newFull = _suggestions[_suggestionIndex];
    }

    if (newFull.length > input.length) {
      return newFull.substring(input.length);
    }
    return null;
  }

  /// Returns the currently selected suggestion (for accepting with Enter).
  String? getCurrentSuggestion(String input) {
    if (_suggestions.isEmpty || input != _currentInput) return null;

    final parts = input.trim().split(RegExp(r'\s+'));
    final isFileCommand = parts.length > 1 || input.trim().endsWith(' ');

    if (isFileCommand && parts.isNotEmpty) {
      return '${parts[0]} ${_suggestions[_suggestionIndex]}';
    }
    return _suggestions[_suggestionIndex];
  }
}
