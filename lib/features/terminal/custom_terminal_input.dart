import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/colors.dart';
import '../../config/text_styles.dart';
import '../../config/constants.dart';
import 'terminal_controller.dart';

class CustomTerminalInput extends StatefulWidget {
  final TerminalController controller;

  const CustomTerminalInput({super.key, required this.controller});

  @override
  State<CustomTerminalInput> createState() => _CustomTerminalInputState();
}

class _CustomTerminalInputState extends State<CustomTerminalInput> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  String _ghostSuffix = '';
  bool _skipGhostSuggest = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    _textController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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

  void _handleTab() {
    _skipGhostSuggest = true;
    final current = _textController.text;
    final suggestion = widget.controller.cycleSuggestion(current);

    if (suggestion != null) {
      _textController.value = TextEditingValue(
        text: suggestion,
        selection: TextSelection.collapsed(offset: suggestion.length),
      );
      _ghostSuffix = '';
      setState(() {});
    }
  }

  void _handleArrowUp() {
    final prev = widget.controller.historyUp();
    if (prev != null) {
      _textController.value = TextEditingValue(
        text: prev,
        selection: TextSelection.collapsed(offset: prev.length),
      );
    }
  }

  void _handleArrowDown() {
    final next = widget.controller.historyDown();
    if (next != null) {
      _textController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
  }

  void _submit(String value) {
    if (widget.controller.waitingForExitConfirm) {
      widget.controller.handleExitConfirmation(value);
      _textController.clear();
      _ghostSuffix = '';
      setState(() {});
      return;
    }
    setState(() => _ghostSuffix = '');
    _textController.clear();
    widget.controller.handleInput(value);
    _focusNode.requestFocus();
  }

  Widget _buildPrompt() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'visitor@portfolio',
            style: GruvboxText.body(color: GruvboxColors.green),
          ),
          TextSpan(text: ':', style: GruvboxText.body()),
          TextSpan(
            text: '~/portfolio',
            style: GruvboxText.body(color: GruvboxColors.blue),
          ),
          TextSpan(text: r'$ ', style: GruvboxText.body()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            _handleTab();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _handleArrowUp();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _handleArrowDown();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          return Container(
            height: TerminalConstants.inputRowHeight,
            decoration: const BoxDecoration(
              color: GruvboxColors.bg_hard,
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
                        ClipRect(
                          child: _GhostSuggestion(
                            typed: _textController.text,
                            ghost: _ghostSuffix,
                          ),
                        ),
                      EditableText(
                        controller: _textController,
                        focusNode: _focusNode,
                        autofocus: true,
                        style: GruvboxText.body(),
                        cursorColor: GruvboxColors.body,
                        backgroundCursorColor: GruvboxColors.bg_hard,
                        maxLines: 1,
                        onSubmitted: _submit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
    return IgnorePointer(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: typed,
              style: GruvboxText.body(color: Colors.transparent),
            ),
            TextSpan(
              text: ghost,
              style: GruvboxText.body(color: GruvboxColors.surface),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
