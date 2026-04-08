sealed class TerminalEvent {}

class TerminalOpened extends TerminalEvent {}

class TerminalClosed extends TerminalEvent {}

class CommandSubmitted extends TerminalEvent {
  CommandSubmitted(this.command);
  final String command;
}

class TerminalCleared extends TerminalEvent {}
