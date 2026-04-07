import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class TiltCardWrapper extends StatefulWidget {
  const TiltCardWrapper({
    required this.child,
    this.maxTilt = 0.05,
    super.key,
  });

  final Widget child;
  final double maxTilt;

  @override
  State<TiltCardWrapper> createState() => _TiltCardWrapperState();
}

class _TiltCardWrapperState extends State<TiltCardWrapper>
    with SingleTickerProviderStateMixin {
  double _targetX = 0;
  double _targetY = 0;
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _xAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _yAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    if (context.reduceMotion) return;

    final size = context.size;
    if (size == null) return;

    final localPosition = event.localPosition;
    // Normalize coordinates to range [-1, 1]
    final dx = (localPosition.dx - (size.width / 2)) / (size.width / 2);
    final dy = (localPosition.dy - (size.height / 2)) / (size.height / 2);

    // Only update if values changed significantly (debouncing)
    final newX = dy * widget.maxTilt;
    final newY = -dx * widget.maxTilt;
    if ((newX - _targetX).abs() > 0.001 || (newY - _targetY).abs() > 0.001) {
      setState(() {
        _targetX = newX;
        _targetY = newY;
      });
      _xAnimation = Tween<double>(begin: _xAnimation.value, end: _targetX)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _yAnimation = Tween<double>(begin: _yAnimation.value, end: _targetY)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  void _onExit(PointerEvent event) {
    if (_targetX != 0 || _targetY != 0) {
      _xAnimation = Tween<double>(begin: _xAnimation.value, end: 0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _yAnimation = Tween<double>(begin: _yAnimation.value, end: 0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
      setState(() {
        _targetX = 0;
        _targetY = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_xAnimation.value)
            ..rotateY(_yAnimation.value);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: widget.child,
          );
        },
      ),
    );
  }
}
