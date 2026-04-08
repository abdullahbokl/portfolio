import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../bloc/terminal_bloc.dart';
import '../../bloc/terminal_event.dart';
import '../../bloc/terminal_state.dart';
import 'terminal_input.dart';
import 'terminal_output.dart';

class TerminalBody extends StatelessWidget {
  const TerminalBody({required this.state, super.key});

  final TerminalState state;

  @override
  Widget build(BuildContext context) {
    final height = context.isMobile
        ? context.screenHeight * 0.7
        : context.screenHeight * 0.5;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.terminalBg.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(
                color: AppColors.terminalGreen.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Column(
            children: [
              // Header bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.terminalGreen.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGreen,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Terminal — guest@elbokl-portfolio',
                      style: AppTextStyles.code(context).copyWith(
                        color: AppColors.terminalGreen.withValues(alpha: 0.8),
                      ),
                    ),
                    const Spacer(),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () =>
                            context.read<TerminalBloc>().add(TerminalClosed()),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.terminalGreen,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Output
              Expanded(child: TerminalOutput(lines: state.outputLines)),
              // Input
              if (state.isOpen) const TerminalInput(),
            ],
          ),
        ),
      ),
    );
  }
}
