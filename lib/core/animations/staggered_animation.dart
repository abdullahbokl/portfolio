import 'package:flutter/material.dart';

/// Animates children with a staggered delay for cascading effect.
/// Each child appears one after another with [staggerDelay] between them.
class StaggeredAnimation extends StatefulWidget {
  const StaggeredAnimation({
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.staggerDelay = const Duration(milliseconds: 100),
    this.startOffset = const Offset(0, 0.1),
    this.startScale = 0.95,
    super.key,
  });

  final List<Widget> children;
  final Duration delay;
  final Duration staggerDelay;
  final Offset startOffset;
  final double startScale;

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _opacityAnimations;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _scaleAnimations;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _opacityAnimations = List.generate(
      widget.children.length,
      (i) => CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimations = List.generate(
      widget.children.length,
      (i) => Tween<Offset>(
        begin: widget.startOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      )),
    );

    _scaleAnimations = List.generate(
      widget.children.length,
      (i) => Tween<double>(
        begin: widget.startScale,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      )),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;
    _hasStarted = true;
    for (int i = 0; i < _controllers.length; i++) {
      if (!mounted) break;
      await _controllers[i].forward();
      await Future.delayed(widget.staggerDelay);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        widget.children.length,
        (i) => AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimations[i].value,
              child: SlideTransition(
                position: _slideAnimations[i],
                child: ScaleTransition(
                  scale: _scaleAnimations[i],
                  child: widget.children[i],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Staggered row animation for horizontal layouts
class StaggeredRow extends StatefulWidget {
  const StaggeredRow({
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.staggerDelay = const Duration(milliseconds: 80),
    this.startOffset = const Offset(0.1, 0),
    this.startScale = 0.95,
    super.key,
  });

  final List<Widget> children;
  final Duration delay;
  final Duration staggerDelay;
  final Offset startOffset;
  final double startScale;

  @override
  State<StaggeredRow> createState() => _StaggeredRowState();
}

class _StaggeredRowState extends State<StaggeredRow>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _opacityAnimations;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _opacityAnimations = List.generate(
      widget.children.length,
      (i) => CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimations = List.generate(
      widget.children.length,
      (i) => Tween<Offset>(
        begin: widget.startOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      )),
    );

    _scaleAnimations = List.generate(
      widget.children.length,
      (i) => Tween<double>(
        begin: widget.startScale,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      )),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(widget.delay);
    if (!mounted) return;
    for (int i = 0; i < _controllers.length; i++) {
      if (!mounted) break;
      await _controllers[i].forward();
      await Future.delayed(widget.staggerDelay);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.children.length,
        (i) => Expanded(
          child: AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimations[i].value,
                child: SlideTransition(
                  position: _slideAnimations[i],
                  child: ScaleTransition(
                    scale: _scaleAnimations[i],
                    child: widget.children[i],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
