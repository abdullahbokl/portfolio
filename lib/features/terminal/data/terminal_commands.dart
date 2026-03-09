import '../../../core/constants/app_strings.dart';

typedef CommandResult = ({String response, bool shouldDownload, bool shouldClose});

abstract final class TerminalCommands {
  static CommandResult execute(String input) {
    final trimmed = input.trim().toLowerCase();

    return switch (trimmed) {
      'help' => (
          response: '''
Available commands:
  help              Show this help message
  about             About Abdullah Khaled Elbokl
  projects          List featured projects
  experience        Show work experience
  education         Show education
  skills            Show technical skills
  contact           Show contact information
  whoami            Who are you?
  ls                List portfolio sections
  cd .secret        Try to access secret directory
  neofetch          System information
  sudo download_resume   Download resume
  clear             Clear terminal output
  exit              Close terminal''',
          shouldDownload: false,
          shouldClose: false,
        ),
      'about' => (
          response:
              'Eng. Abdullah Khaled Elbokl — Mobile Application Developer focused on '
                  'designing scalable architectures and leading complex system migrations.\n'
                  'Specialized in high-integrity, backend-authoritative systems ensuring '
                  'data security & auditability across mobile and web platforms.\n'
                  '1000+ problems solved on LeetCode & Codeforces.',
          shouldDownload: false,
          shouldClose: false,
        ),
      'projects' => (
          response: '''
[1] Boklo Wallet   — High-Integrity Fintech System
[2] Smart CRM      — Enterprise ERP & Field Management
[3] Billing Fast   — Scalable Inventory Suite
[4] Job-Hub        — Full-Stack Ecosystem
[5] Netflix Clone  — Native iOS Engineering''',
          shouldDownload: false,
          shouldClose: false,
        ),
      'experience' => (
          response: '''
Smart Life       | Senior Flutter Dev    | Feb 2024 – Oct 2024
  → N-layer BLoC migration · Shorebird OTA · Page-level privileges

Xero-Apps        | Flutter Developer     | Jun 2023 – Jan 2024
  → Kiranafast inventory suite · Batch System · Multi-tier pricing

Arunoday-Tech    | Flutter Developer     | Mar 2023 – May 2023
  → BLoC-MVVM architecture · REST API optimization

ITI              | iOS / Flutter Dev     | Aug 2022 – Feb 2023
  → Native Swift/UIKit · Riverpod DI · 15+ features/month

ICPC Training    | Technical Lead        | 2021 – 2024
  → 120+ students mentored · 1000+ problems · 1st university-wide''',
          shouldDownload: false,
          shouldClose: false,
        ),
      'education' => (
          response: '''
Port-Said University | B.Sc. Technology and Information Systems | 2019 – 2023
  → 1st place university-wide in ICPC competitive programming
  → Strong foundation in algorithms, data structures & OOP''',
          shouldDownload: false,
          shouldClose: false,
        ),
      'skills' => (
          response: '''
Core Engineering:    Algorithms · Data Structures · OOP
Architecture:        Clean Architecture · N-Layered · MVC · MVVM
State Management:    BLoC · Provider · Riverpod · GetX · Mobx · Redux
App Development:     Flutter (Expert) · Native iOS (Swift) · Flutter Web
Backend & Database:  Firebase · Cloud Functions · Supabase · REST API
DevOps & Tools:      Shorebird OTA · Doppler · Firebase Emulators · Git
Quality & Security:  SOLID · Clean Code · Unit Testing · Backend-Auth Security''',
          shouldDownload: false,
          shouldClose: false,
        ),
      'contact' => (
          response: '''
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
          response: 'hero/  about/  projects/  experience/  skills/  contact/  .secret/',
          shouldDownload: false,
          shouldClose: false,
        ),
      'cd .secret' => (
          response: 'Permission denied. Nice try though.',
          shouldDownload: false,
          shouldClose: false,
        ),
      'neofetch' => (
          response: '''
       ╔═══════════════════════╗
       ║  elbokl-portfolio     ║
       ╠═══════════════════════╣
       ║  OS: Flutter Web      ║
       ║  SDK: Dart 3.10       ║
       ║  State: Bloc/Cubit    ║
       ║  Arch: Clean Arch     ║
       ║  Theme: UV-Reactive   ║
       ║  Uptime: ∞            ║
       ╚═══════════════════════╝''',
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
      'clear' => (
          response: '',
          shouldDownload: false,
          shouldClose: false,
        ),
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

