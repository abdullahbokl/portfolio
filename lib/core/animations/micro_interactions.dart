import 'package:flutter/material.dart';

/// Button with scale-down animation on tap.
/// Provides tactile feedback without jank.
class TapScaleButton extends StatefulWidget {
  const TapScaleButton({
    required this.child,
    required this.onPressed,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 100),
    super.key,
  });

  final Widget child;
  final VoidCallback onPressed;
  final double scaleFactor;
  final Duration duration;

  @override
  State<TapScaleButton> createState() => _TapScaleButtonState();
}

class _TapScaleButtonState extends State<TapScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isPressed) {
      _isPressed = true;
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isPressed) {
      _isPressed = false;
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    if (_isPressed) {
      _isPressed = false;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Hover effect with smooth scale and shadow animation.
class HoverScale extends StatefulWidget {
  const HoverScale({
    required this.child,
    this.scaleFactor = 1.05,
    this.duration = const Duration(milliseconds: 200),
    this.elevation = 8.0,
    super.key,
  });

  final Widget child;
  final double scaleFactor;
  final Duration duration;
  final double elevation;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  final _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: RepaintBoundary(
        child: ValueListenableBuilder<bool>(
          valueListenable: _hovered,
          builder: (context, hovered, _) {
            return AnimatedScale(
              scale: hovered ? widget.scaleFactor : 1.0,
              duration: widget.duration,
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: widget.duration,
                decoration: BoxDecoration(
                  boxShadow: hovered
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: widget.elevation,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Ripple effect on tap for Material-like feedback.
class RippleButton extends StatefulWidget {
  const RippleButton({
    required this.child,
    required this.onPressed,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    super.key,
  });

  final Widget child;
  final VoidCallback onPressed;
  final Color? color;
  final BorderRadius borderRadius;

  @override
  State<RippleButton> createState() => _RippleButtonState();
}

class _RippleButtonState extends State<RippleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusAnimation;
  late Animation<double> _opacityAnimation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _radiusAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTap: widget.onPressed,
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Stack(
          children: [
            widget.child,
            if (_tapPosition != null)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color ??
                          Theme.of(context).colorScheme.primary.withValues(alpha: _opacityAnimation.value),
                    ),
                    constraints: BoxConstraints(
                      minWidth: _radiusAnimation.value * 2,
                      minHeight: _radiusAnimation.value * 2,
                    ),
                    transform: Matrix4.translationValues(
                      _tapPosition!.dx - _radiusAnimation.value,
                      _tapPosition!.dy - _radiusAnimation.value,
                      0,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Pulse animation for attention-grabbing elements.
class PulseAnimation extends StatefulWidget {
  const PulseAnimation({
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 1.0,
    this.maxScale = 1.1,
    this.repeat = true,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Glow effect that intensifies on hover.
class HoverGlow extends StatefulWidget {
  const HoverGlow({
    required this.child,
    this.color,
    this.baseBlur = 0.0,
    this.hoverBlur = 20.0,
    this.baseAlpha = 0.0,
    this.hoverAlpha = 0.3,
    this.duration = const Duration(milliseconds: 200),
    super.key,
  });

  final Widget child;
  final Color? color;
  final double baseBlur;
  final double hoverBlur;
  final double baseAlpha;
  final double hoverAlpha;
  final Duration duration;

  @override
  State<HoverGlow> createState() => _HoverGlowState();
}

class _HoverGlowState extends State<HoverGlow> {
  final _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: RepaintBoundary(
        child: ValueListenableBuilder<bool>(
          valueListenable: _hovered,
          builder: (context, hovered, _) {
            return AnimatedContainer(
              duration: widget.duration,
              decoration: BoxDecoration(
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: glowColor.withValues(alpha: widget.hoverAlpha),
                          blurRadius: widget.hoverBlur,
                          spreadRadius: 2,
                        ),
                      ]
                    : widget.baseBlur > 0
                        ? [
                            BoxShadow(
                              color: glowColor.withValues(alpha: widget.baseAlpha),
                              blurRadius: widget.baseBlur,
                            ),
                          ]
                        : [],
              ),
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
