import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../extensions/context_extensions.dart';

/// Wraps each portfolio section with consistent padding, fade-in animation,
/// and visibility detection for navigation tracking.
class SectionWrapper extends StatefulWidget {
  const SectionWrapper({
    required this.sectionKey,
    required this.child,
    this.onVisible,
    this.isInitial = false,
    super.key,
  });

  final GlobalKey sectionKey;
  final Widget child;
  final VoidCallback? onVisible;
  final bool isInitial;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  bool _alreadyAppeared = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05), // Subtle 5% slide up
      end: Offset.zero,
    ).animate(_animation);

    if (widget.isInitial) {
      _alreadyAppeared = true;
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAppear() {
    if (_alreadyAppeared) return;
    _alreadyAppeared = true;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.isDesktop
        ? 24.0
        : context.isTablet
            ? 20.0
            : 16.0;
    final verticalPadding = context.isDesktop
        ? 80.0
        : context.isTablet
            ? 64.0
            : 48.0;

    return RepaintBoundary(
      child: VisibilityDetector(
        key: Key('section-${widget.sectionKey.hashCode}'),
        onVisibilityChanged: (info) {
          // Animate in as soon as it starts appearing (0.05 threshold)
          if (info.visibleFraction > 0.05) {
            _onAppear();
          }
          // Notify about section change (0.5 threshold)
          if (info.visibleFraction > 0.5) {
            widget.onVisible?.call();
          }
        },
        child: Container(
          key: widget.sectionKey,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.98, end: 1.0).animate(_animation),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
