import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  // GlobalKeys are stable and not recreated on state changes
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  NavigationCubit() : super(const NavigationState(activeIndex: 0));

  List<GlobalKey> get sectionKeys => _sectionKeys;

  final ScrollController scrollController = ScrollController();

  void setActive(int index) {
    if (index != state.activeIndex) {
      emit(state.copyWith(activeIndex: index));
    }
  }

  Future<void> scrollTo(int index) async {
    final key = _sectionKeys[index];
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
