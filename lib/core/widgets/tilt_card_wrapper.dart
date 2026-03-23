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

class _TiltCardWrapperState extends State<TiltCardWrapper> {
  double _x = 0;
  double _y = 0;

  void _onHover(PointerEvent event) {
    if (context.reduceMotion) return;
    
    final size = context.size;
    if (size == null) return;

    final localPosition = event.localPosition;
    // Normalize coordinates to range [-1, 1]
    final dx = (localPosition.dx - (size.width / 2)) / (size.width / 2);
    final dy = (localPosition.dy - (size.height / 2)) / (size.height / 2);

    setState(() {
      _x = dy * widget.maxTilt;
      _y = -dx * widget.maxTilt;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _x = 0;
      _y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateX(_x)
      ..rotateY(_y);

    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<Matrix4>(
        tween: Matrix4Tween(begin: Matrix4.identity(), end: transform),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        builder: (context, matrix, child) {
          return Transform(
            transform: matrix,
            alignment: FractionalOffset.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
