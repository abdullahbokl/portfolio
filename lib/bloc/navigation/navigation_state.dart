import 'package:flutter/material.dart';

class NavigationState {
  const NavigationState({
    required this.activeIndex,
    required this.sectionKeys,
  });

  final int activeIndex;
  final List<GlobalKey> sectionKeys;

  NavigationState copyWith({int? activeIndex}) {
    return NavigationState(
      activeIndex: activeIndex ?? this.activeIndex,
      sectionKeys: sectionKeys,
    );
  }
}

