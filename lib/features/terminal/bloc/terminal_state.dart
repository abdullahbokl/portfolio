class TerminalLine {
  const TerminalLine({required this.text, this.isCommand = false});

  final String text;
  final bool isCommand;
}

class TerminalState {
  const TerminalState({
    this.isOpen = false,
    this.outputLines = const [],
    this.commandHistory = const [],
    this.historyIndex = -1,
  });

  final bool isOpen;
  final List<TerminalLine> outputLines;
  final List<String> commandHistory;
  final int historyIndex;

  TerminalState copyWith({
    bool? isOpen,
    List<TerminalLine>? outputLines,
    List<String>? commandHistory,
    int? historyIndex,
  }) {
    return TerminalState(
      isOpen: isOpen ?? this.isOpen,
      outputLines: outputLines ?? this.outputLines,
      commandHistory: commandHistory ?? this.commandHistory,
      historyIndex: historyIndex ?? this.historyIndex,
    );
  }
}
