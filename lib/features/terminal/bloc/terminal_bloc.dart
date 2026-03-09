import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../data/terminal_commands.dart';
import 'terminal_event.dart';
import 'terminal_state.dart';

class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  TerminalBloc() : super(const TerminalState()) {
    on<TerminalOpened>(_onOpened);
    on<TerminalClosed>(_onClosed);
    on<CommandSubmitted>(_onCommand);
    on<TerminalCleared>(_onCleared);
  }

  void _onOpened(TerminalOpened event, Emitter<TerminalState> emit) {
    if (state.isOpen) return;
    emit(state.copyWith(
      isOpen: true,
      outputLines: [
        const TerminalLine(text: AppStrings.terminalWelcome),
      ],
    ));
  }

  void _onClosed(TerminalClosed event, Emitter<TerminalState> emit) {
    emit(state.copyWith(isOpen: false));
  }

  void _onCleared(TerminalCleared event, Emitter<TerminalState> emit) {
    emit(state.copyWith(outputLines: []));
  }

  Future<void> _onCommand(
    CommandSubmitted event,
    Emitter<TerminalState> emit,
  ) async {
    final cmd = event.command.trim();
    if (cmd.isEmpty) return;

    final result = TerminalCommands.execute(cmd);
    final newHistory = [...state.commandHistory, cmd];

    if (cmd.toLowerCase() == 'clear') {
      emit(state.copyWith(
        outputLines: [],
        commandHistory: newHistory,
        historyIndex: -1,
      ));
      return;
    }

    final newLines = [
      ...state.outputLines,
      TerminalLine(text: cmd, isCommand: true),
      if (result.response.isNotEmpty) TerminalLine(text: result.response),
    ];

    emit(state.copyWith(
      outputLines: newLines,
      commandHistory: newHistory,
      historyIndex: -1,
    ));

    if (result.shouldDownload) {
      final uri = Uri.parse(AppAssets.resumeUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (result.shouldClose) {
      emit(state.copyWith(isOpen: false));
    }
  }
}

