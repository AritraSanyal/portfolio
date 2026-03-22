import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../config/constants.dart';
import 'terminal_controller.dart';

class InputRow extends StatefulWidget {
  final TerminalController controller;

  const InputRow({super.key, required this.controller});

  @override
  State<InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _editableFocus = FocusNode();

  String _ghostSuffix = '';
  bool _skipGhostSuggest = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    HardwareKeyboard.instance.addHandler(_onGlobalKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onGlobalKeyEvent);
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _editableFocus.dispose();
    super.dispose();
  }

  bool _onGlobalKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    if (event.logicalKey == LogicalKeyboardKey.tab) {
      _skipGhostSuggest = true;
      final current = _textController.text;
      final ghost = widget.controller.cycleSuggestion(current);

      if (ghost != null) {
        setState(() {});
      } else {
        final accepted = widget.controller.getCurrentSuggestion(current);
        if (accepted != null) {
          final withSpace = '$accepted ';
          _textController.value = TextEditingValue(
            text: withSpace,
            selection: TextSelection.collapsed(offset: withSpace.length),
          );
        }
      }
      _editableFocus.requestFocus();
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final prev = widget.controller.historyUp();
      if (prev != null) {
        _textController.value = TextEditingValue(
          text: prev,
          selection: TextSelection.collapsed(offset: prev.length),
        );
      }
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final next = widget.controller.historyDown();
      if (next != null) {
        _textController.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
      return true;
    }

    return false;
  }

  void _onTextChanged() {
    if (_skipGhostSuggest) {
      _skipGhostSuggest = false;
      _ghostSuffix = '';
      return;
    }
    final ghost = widget.controller.ghostSuggest(_textController.text);
    final next = ghost ?? '';
    if (next != _ghostSuffix) {
      setState(() => _ghostSuffix = next);
    }
  }

  void _submit(String value) {
    setState(() => _ghostSuffix = '');
    _textController.clear();
    widget.controller.handleInput(value);
    _editableFocus.requestFocus();
  }

  Widget _buildPrompt() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'visitor@portfolio',
            style: GruvboxText.terminal(color: GruvboxColors.green),
          ),
          TextSpan(text: ':', style: GruvboxText.terminal()),
          TextSpan(
            text: '~/portfolio',
            style: GruvboxText.terminal(color: GruvboxColors.blue),
          ),
          TextSpan(text: r'$ ', style: GruvboxText.terminal()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TerminalConstants.inputRowHeight,
      decoration: const BoxDecoration(
        color: GruvboxColors.bgHard,
        border: Border(
          top: BorderSide(color: GruvboxColors.overlay, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _buildPrompt(),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (_ghostSuffix.isNotEmpty)
                  _GhostSuggestion(
                    typed: _textController.text,
                    ghost: _ghostSuffix,
                  ),
                EditableText(
                  controller: _textController,
                  focusNode: _editableFocus,
                  autofocus: true,
                  style: GruvboxText.terminal(),
                  cursorColor: GruvboxColors.body,
                  backgroundCursorColor: GruvboxColors.bgHard,
                  obscureText: false,
                  maxLines: 1,
                  onChanged: (value) => _onTextChanged(),
                  onSubmitted: (value) => _submit(value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GhostSuggestion extends StatelessWidget {
  final String typed;
  final String ghost;

  const _GhostSuggestion({required this.typed, required this.ghost});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: typed,
            style: GruvboxText.terminal(color: Colors.transparent),
          ),
          TextSpan(
            text: ghost,
            style: GruvboxText.terminal(color: GruvboxColors.surface),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }
}
