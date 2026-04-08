import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../bloc/terminal_state.dart';

/// Displays terminal output lines with command styling.
class TerminalOutput extends StatefulWidget {
  const TerminalOutput({required this.lines, super.key});

  final List<TerminalLine> lines;

  @override
  State<TerminalOutput> createState() => _TerminalOutputState();
}

class _TerminalOutputState extends State<TerminalOutput> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant TerminalOutput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lines.length != oldWidget.lines.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codeStyle = AppTextStyles.code(context);

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.lines.length,
      itemBuilder: (context, index) {
        final line = widget.lines[index];
        if (line.isCommand) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.terminalPrompt,
                    style: codeStyle.copyWith(color: AppColors.accentGreen),
                  ),
                  TextSpan(
                    text: line.text,
                    style: codeStyle.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            line.text,
            style: codeStyle.copyWith(color: AppColors.terminalGreen),
          ),
        );
      },
    );
  }
}
