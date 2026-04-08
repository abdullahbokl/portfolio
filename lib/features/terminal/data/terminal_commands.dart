import '../../../core/constants/app_strings.dart';
import 'commands/command_result.dart';
import 'commands/command_strings.dart';

export 'commands/command_result.dart';

abstract final class TerminalCommands {
  static CommandResult execute(String input) {
    final trimmed = input.trim().toLowerCase();

    return switch (trimmed) {
      'help' => (
        response: CommandStrings.help,
        shouldDownload: false,
        shouldClose: false,
      ),
      'about' => (
        response: CommandStrings.about,
        shouldDownload: false,
        shouldClose: false,
      ),
      'projects' => (
        response: CommandStrings.projects,
        shouldDownload: false,
        shouldClose: false,
      ),
      'experience' => (
        response: CommandStrings.experience,
        shouldDownload: false,
        shouldClose: false,
      ),
      'education' => (
        response: CommandStrings.education,
        shouldDownload: false,
        shouldClose: false,
      ),
      'skills' => (
        response: CommandStrings.skills,
        shouldDownload: false,
        shouldClose: false,
      ),
      'contact' => (
        response:
            '''
GitHub:     ${AppStrings.githubUrl}
LinkedIn:   ${AppStrings.linkedinUrl}
LeetCode:   ${AppStrings.leetcodeUrl}
Codeforces: ${AppStrings.codeforcesUrl}
Email:      ${AppStrings.emailAddress}''',
        shouldDownload: false,
        shouldClose: false,
      ),
      'whoami' => (
        response: 'guest@elbokl-portfolio',
        shouldDownload: false,
        shouldClose: false,
      ),
      'ls' => (
        response:
            'hero/  about/  projects/  experience/  skills/  contact/  .secret/',
        shouldDownload: false,
        shouldClose: false,
      ),
      'cd .secret' => (
        response: 'Permission denied. Nice try though.',
        shouldDownload: false,
        shouldClose: false,
      ),
      'neofetch' => (
        response: CommandStrings.neofetch,
        shouldDownload: false,
        shouldClose: false,
      ),
      'sudo download_resume' => (
        response: '[ACCESS GRANTED] Initiating secure download...',
        shouldDownload: true,
        shouldClose: false,
      ),
      'sudo' => (
        response: "Usage: sudo <command>. Try 'sudo download_resume'",
        shouldDownload: false,
        shouldClose: false,
      ),
      'clear' => (response: '', shouldDownload: false, shouldClose: false),
      'exit' => (
        response: 'Closing terminal...',
        shouldDownload: false,
        shouldClose: true,
      ),
      _ => (
        response:
            "Command not found: $trimmed. Type 'help' for available commands.",
        shouldDownload: false,
        shouldClose: false,
      ),
    };
  }
}
