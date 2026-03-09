import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Animated counter that counts up from 0 to [targetValue] on first scroll.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    required this.targetValue,
    required this.label,
    this.suffix = '',
    this.prefix = '',
    this.duration = const Duration(milliseconds: 2000),
    super.key,
  });

  final int targetValue;
  final String label;
  final String suffix;
  final String prefix;
  final Duration duration;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = IntTween(begin: 0, end: widget.targetValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final reduceMotion = context.reduceMotion;

    if (reduceMotion && !_hasAnimated) {
      _hasAnimated = true;
      _controller.value = 1.0;
    }

    return VisibilityDetector(
      key: Key('counter-${widget.label.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.6) _triggerAnimation();
      },
      child: Semantics(
        label: '${widget.prefix}${widget.targetValue}${widget.suffix} ${widget.label}',
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.prefix}${_animation.value}${widget.suffix}',
                  style: AppTextStyles.h2(context).copyWith(color: accent),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: AppTextStyles.caption(context).copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

