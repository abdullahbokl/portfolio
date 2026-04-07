import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/bloc/navigation/navigation_cubit.dart';
import 'package:portfolio/app/widgets/nav_bar.dart';
import 'package:portfolio/app/widgets/section_list.dart';
import 'package:portfolio/features/terminal/bloc/terminal_bloc.dart';
import 'package:portfolio/features/terminal/bloc/terminal_event.dart';
import 'package:portfolio/features/terminal/bloc/terminal_state.dart';
import 'package:portfolio/features/terminal/presentation/terminal_overlay.dart';
import 'package:portfolio/core/widgets/progress_indicator.dart';
import 'package:portfolio/core/widgets/scroll_to_top.dart';
import 'package:portfolio/core/widgets/keyboard_navigation.dart';

class PortfolioRouter extends StatefulWidget {
  const PortfolioRouter({super.key});

  @override
  State<PortfolioRouter> createState() => _PortfolioRouterState();
}

class _PortfolioRouterState extends State<PortfolioRouter> {
  int _tapCount = 0;
  DateTime? _lastTapTime;
  late final FocusNode _focusNode;
  int _activeSection = 0;

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

  void _toggleTerminal(BuildContext context) {
    final bloc = context.read<TerminalBloc>();
    if (bloc.state.isOpen) {
      bloc.add(TerminalClosed());
    } else {
      bloc.add(TerminalOpened());
    }
  }

  void _handleTripleTap(BuildContext context) {
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
      _toggleTerminal(context);
    }
  }

  void _onSectionChanged(int index) {
    setState(() {
      _activeSection = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navCubit = context.read<NavigationCubit>();
    final keys = navCubit.sectionKeys;

    return BlocProvider(
      create: (_) => TerminalBloc(),
      child: BlocBuilder<TerminalBloc, TerminalState>(
        builder: (blocContext, terminalState) {
          return KeyboardNavigation(
            scrollController: navCubit.scrollController,
            sectionKeys: keys,
            onToggleTerminal: () => _toggleTerminal(blocContext),
            onCloseOverlay: () {
              if (terminalState.isOpen) {
                blocContext.read<TerminalBloc>().add(TerminalClosed());
              }
            },
            child: Listener(
              onPointerDown: (_) => _handleTripleTap(blocContext),
              child: Scaffold(
                extendBodyBehindAppBar: true,
                body: Stack(
                  children: [
                    CustomScrollView(
                      controller: navCubit.scrollController,
                      slivers: [
                        const NavBar(),
                        SectionList(
                          navCubit: navCubit,
                          onSectionChanged: _onSectionChanged,
                        ),
                      ],
                    ),
                    const TerminalOverlay(),
                    // Progress indicator
                    SectionProgressIndicator(
                      scrollController: navCubit.scrollController,
                      sectionCount: 6,
                      activeIndex: _activeSection,
                      onSectionTap: (index) => navCubit.scrollTo(index),
                    ),
                    // Scroll to top button
                    ScrollToTopButton(
                      scrollController: navCubit.scrollController,
                    ),
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
