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
  final FocusNode _inputFocus = FocusNode();
  final FocusNode _keyFocus = FocusNode();

  String _ghostSuffix = '';

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final ghost = widget.controller.ghostSuggest(_textController.text);
    final next = ghost ?? '';
    if (next != _ghostSuffix) {
      setState(() => _ghostSuffix = next);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _inputFocus.dispose();
    _keyFocus.dispose();
    super.dispose();
  }

  void _submit(String value) {
    setState(() => _ghostSuffix = '');
    _textController.clear();
    widget.controller.handleInput(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _inputFocus.requestFocus();
    });
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final prev = widget.controller.historyUp();
      if (prev != null) {
        _textController.text = prev;
        _textController.selection =
            TextSelection.collapsed(offset: prev.length);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final next = widget.controller.historyDown();
      if (next != null) {
        _textController.text = next;
        _textController.selection =
            TextSelection.collapsed(offset: next.length);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.tab) {
      // Cycle through suggestions with Tab
      final current = _textController.text;
      final ghost = widget.controller.cycleSuggestion(current);
      if (ghost != null) {
        // Cycle found - update ghost suffix
        setState(() {});
      } else {
        // No cycling (single match or no suggestions) - accept it
        final accepted = widget.controller.getCurrentSuggestion(current);
        if (accepted != null) {
          _textController.text = accepted;
          _textController.selection =
              TextSelection.collapsed(offset: accepted.length);
        }
      }
      // Prevent focus tab-out
    }
  }

  // Build the prompt prefix widget
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
    return Container(
      height: TerminalConstants.inputRowHeight,
      decoration: const BoxDecoration(
        color: GruvboxColors.bg_hard,
        border: Border(
          top: BorderSide(color: GruvboxColors.overlay, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: KeyboardListener(
        focusNode: _keyFocus,
        onKeyEvent: _handleKey,
        child: Row(
          children: [
            _buildPrompt(),
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Ghost suggestion layer (behind the real text field)
                  if (_ghostSuffix.isNotEmpty)
                    _GhostSuggestion(
                      typed: _textController.text,
                      ghost: _ghostSuffix,
                    ),
                  // Real input field (transparent background so ghost shows through)
                  TextField(
                    controller: _textController,
                    focusNode: _inputFocus,
                    autofocus: true,
                    style: GruvboxText.body(),
                    cursorColor: GruvboxColors.body,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    onSubmitted: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders the typed text in transparent ink + the ghost suffix in muted color.
/// Sits below the real TextField so the cursor and selection still work normally.
class _GhostSuggestion extends StatelessWidget {
  final String typed;
  final String ghost;

  const _GhostSuggestion({required this.typed, required this.ghost});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          // Typed portion — invisible (same color as bg) so it perfectly
          // underlays the TextField text without any visual doubling
          TextSpan(
            text: typed,
            style: GruvboxText.body(color: Colors.transparent),
          ),
          // Ghost suffix — visible in muted/faded color
          TextSpan(
            text: ghost,
            style: GruvboxText.body(color: GruvboxColors.surface),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.clip,
    );
  }
}
