import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(
          NavigationState(
            activeIndex: 0,
            sectionKeys: List.generate(6, (_) => GlobalKey()),
          ),
        );

  final ScrollController scrollController = ScrollController();

  void setActive(int index) {
    if (index != state.activeIndex) {
      emit(state.copyWith(activeIndex: index));
    }
  }

  Future<void> scrollTo(int index) async {
    final key = state.sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      setActive(index);
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}

