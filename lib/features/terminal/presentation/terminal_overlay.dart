import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/terminal_bloc.dart';
import '../bloc/terminal_state.dart';
import 'widgets/terminal_body.dart';

/// Slide-up terminal overlay activated via backtick or triple-tap.
class TerminalOverlay extends StatelessWidget {
  const TerminalOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      builder: (context, state) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          offset: state.isOpen ? Offset.zero : const Offset(0, 1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: state.isOpen ? 1.0 : 0.0,
            child: TerminalBody(state: state),
          ),
        );
      },
    );
  }
}
