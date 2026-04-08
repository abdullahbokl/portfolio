import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../bloc/terminal_bloc.dart';
import '../../bloc/terminal_event.dart';

/// Styled text field for terminal command input with history navigation.
class TerminalInput extends StatefulWidget {
  const TerminalInput({super.key});

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TerminalBloc>().add(CommandSubmitted(text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final codeStyle = AppTextStyles.code(context);
    final bloc = context.read<TerminalBloc>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.terminalGreen.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            final history = bloc.state.commandHistory;
            if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                history.isNotEmpty) {
              final idx = bloc.state.historyIndex;
              final newIdx = idx < 0
                  ? history.length - 1
                  : (idx - 1).clamp(0, history.length - 1);
              _controller.text = history[newIdx];
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
              // Update history index in bloc
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                history.isNotEmpty) {
              final idx = bloc.state.historyIndex;
              if (idx >= 0 && idx < history.length - 1) {
                _controller.text = history[idx + 1];
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
              } else {
                _controller.clear();
              }
            }
          }
        },
        child: Row(
          children: [
            Text(
              AppStrings.terminalPrompt,
              style: codeStyle.copyWith(color: AppColors.accentGreen),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: codeStyle.copyWith(color: AppColors.terminalGreen),
                cursorColor: AppColors.terminalGreen,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
