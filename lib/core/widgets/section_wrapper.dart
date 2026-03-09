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
    super.key,
  });

  final GlobalKey sectionKey;
  final Widget child;
  final VoidCallback? onVisible;

  @override
  State<SectionWrapper> createState() => _SectionWrapperState();
}

class _SectionWrapperState extends State<SectionWrapper> {
  bool _hasAppeared = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final horizontalPadding = isDesktop
        ? 24.0
        : isTablet
            ? 20.0
            : 16.0;
    final verticalPadding = isDesktop
        ? 80.0
        : isTablet
            ? 64.0
            : 48.0;

    final reduceMotion = context.reduceMotion;

    return VisibilityDetector(
      key: Key('section-${widget.sectionKey.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          widget.onVisible?.call();
        }
        if (!_hasAppeared && info.visibleFraction > 0.2) {
          setState(() => _hasAppeared = true);
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
            child: AnimatedOpacity(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 600),
              opacity: _hasAppeared ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                offset: _hasAppeared ? Offset.zero : const Offset(0, 0.05),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

