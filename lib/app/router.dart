import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/app/theme/app_colors.dart';
import 'package:portfolio/app/theme/app_text_styles.dart';
import 'package:portfolio/bloc/navigation/navigation_cubit.dart';
import 'package:portfolio/bloc/navigation/navigation_state.dart';
import 'package:portfolio/bloc/theme/theme_cubit.dart';
import 'package:portfolio/bloc/theme/theme_state.dart';
import 'package:portfolio/core/constants/app_strings.dart';
import 'package:portfolio/core/extensions/context_extensions.dart';
import 'package:portfolio/core/widgets/section_wrapper.dart';
import 'package:portfolio/features/about/presentation/about_section.dart';
import 'package:portfolio/features/contact/presentation/contact_section.dart';
import 'package:portfolio/features/experience/presentation/experience_section.dart';
import 'package:portfolio/features/hero/presentation/hero_section.dart';
import 'package:portfolio/features/projects/presentation/projects_section.dart';
import 'package:portfolio/features/skills/presentation/skills_section.dart';
import 'package:portfolio/features/terminal/bloc/terminal_bloc.dart';
import 'package:portfolio/features/terminal/bloc/terminal_event.dart';
import 'package:portfolio/features/terminal/bloc/terminal_state.dart';
import 'package:portfolio/features/terminal/presentation/terminal_overlay.dart';

class PortfolioRouter extends StatefulWidget {
  const PortfolioRouter({super.key});

  @override
  State<PortfolioRouter> createState() => _PortfolioRouterState();
}

class _PortfolioRouterState extends State<PortfolioRouter> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleTerminal() {
    final bloc = context.read<TerminalBloc>();
    if (bloc.state.isOpen) {
      bloc.add(TerminalClosed());
    } else {
      bloc.add(TerminalOpened());
    }
  }

  void _handleTripleTap() {
    final now = DateTime.now();
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 500) {
      _tapCount++;
    } else {
      _tapCount = 1;
    }
    _lastTapTime = now;

    if (_tapCount >= 3) {
      _tapCount = 0;
      _toggleTerminal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navCubit = context.read<NavigationCubit>();
    final keys = navCubit.state.sectionKeys;

    return BlocProvider(
      create: (_) => TerminalBloc(),
      child: BlocBuilder<TerminalBloc, TerminalState>(
        builder: (context, terminalState) {
          return KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backquote) {
                final bloc = context.read<TerminalBloc>();
                if (bloc.state.isOpen) {
                  bloc.add(TerminalClosed());
                } else {
                  bloc.add(TerminalOpened());
                }
              }
              if (terminalState.isOpen &&
                  event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                context.read<TerminalBloc>().add(TerminalClosed());
              }
            },
            child: Listener(
              onPointerDown: (_) => _handleTripleTap(),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                body: Stack(
                  children: [
                    CustomScrollView(
                      controller: navCubit.scrollController,
                      slivers: [
                        const _NavBar(),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              SectionWrapper(
                                sectionKey: keys[0],
                                onVisible: () => navCubit.setActive(0),
                                child: const HeroSection(),
                              ),
                              SectionWrapper(
                                sectionKey: keys[1],
                                onVisible: () => navCubit.setActive(1),
                                child: const AboutSection(),
                              ),
                              SectionWrapper(
                                sectionKey: keys[2],
                                onVisible: () => navCubit.setActive(2),
                                child: const ProjectsSection(),
                              ),
                              SectionWrapper(
                                sectionKey: keys[3],
                                onVisible: () => navCubit.setActive(3),
                                child: const ExperienceSection(),
                              ),
                              SectionWrapper(
                                sectionKey: keys[4],
                                onVisible: () => navCubit.setActive(4),
                                child: const SkillsSection(),
                              ),
                              SectionWrapper(
                                sectionKey: keys[5],
                                onVisible: () => navCubit.setActive(5),
                                child: const ContactSection(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const TerminalOverlay(),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final accent = context.accent.accent;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceTertiary.withValues(alpha: 0.9),
      toolbarHeight: 64,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.read<NavigationCubit>().scrollTo(0),
          child: Text(
            'AE',
            style: AppTextStyles.h3(context).copyWith(color: accent),
          ),
        ),
      ),
      actions: [
        if (isDesktop)
          BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, navState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(AppStrings.navSections.length, (i) {
                  final isActive = navState.activeIndex == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: TextButton(
                        onPressed: () =>
                            context.read<NavigationCubit>().scrollTo(i),
                        child: Text(
                          AppStrings.navSections[i],
                          style: AppTextStyles.caption(context).copyWith(
                            color: isActive ? accent : AppColors.textSecondary,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        // Accent toggle button
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: BlocBuilder<ThemeCubit, AppThemeMode>(
            builder: (context, mode) {
              final icon = switch (mode) {
                AppThemeMode.dark => Icons.dark_mode_outlined,
                AppThemeMode.uvGreen => Icons.bolt,
                AppThemeMode.uvViolet => Icons.auto_awesome,
              };
              final tooltip = switch (mode) {
                AppThemeMode.dark => 'Dark Mode',
                AppThemeMode.uvGreen => 'UV Green',
                AppThemeMode.uvViolet => 'UV Violet',
              };
              return Semantics(
                button: true,
                label: 'Toggle theme: $tooltip',
                child: IconButton(
                  onPressed: () => context.read<ThemeCubit>().toggleAccent(),
                  icon: Icon(icon, color: accent),
                  tooltip: tooltip,
                ),
              );
            },
          ),
        ),
        // Mobile hamburger
        if (!isDesktop)
          Builder(
            builder: (ctx) {
              return IconButton(
                onPressed: () => _showMobileNav(ctx),
                icon: Icon(Icons.menu, color: accent),
                tooltip: 'Navigation menu',
              );
            },
          ),
      ],
    );
  }

  void _showMobileNav(BuildContext context) {
    final accent = context.accent.accent;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceTertiary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(AppStrings.navSections.length, (i) {
              return ListTile(
                title: Text(
                  AppStrings.navSections[i],
                  style: AppTextStyles.body(context).copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                leading: Icon(
                  _sectionIcon(i),
                  color: accent,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<NavigationCubit>().scrollTo(i);
                },
              );
            }),
          ),
        );
      },
    );
  }

  static IconData _sectionIcon(int index) {
    return switch (index) {
      0 => Icons.home_outlined,
      1 => Icons.person_outline,
      2 => Icons.code_outlined,
      3 => Icons.work_history_outlined,
      4 => Icons.psychology_outlined,
      5 => Icons.mail_outlined,
      _ => Icons.circle_outlined,
    };
  }
}




