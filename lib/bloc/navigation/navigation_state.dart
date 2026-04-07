import 'package:flutter/material.dart';

class NavigationState {
  const NavigationState({required this.activeIndex});

  final int activeIndex;

  NavigationState copyWith({int? activeIndex}) {
    return NavigationState(
      activeIndex: activeIndex ?? this.activeIndex,
    );
  }
}
