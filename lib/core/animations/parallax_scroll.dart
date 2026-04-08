import 'package:flutter/material.dart';

/// Widget that applies parallax scrolling effect to its child.
/// The child moves at a different speed than the scroll, creating depth.
class ParallaxScroll extends StatefulWidget {
  const ParallaxScroll({
    required this.child,
    this.parallaxFactor = 0.5,
    this.direction = Axis.vertical,
    super.key,
  });

  final Widget child;
  final double parallaxFactor; // 0 = no movement, 1 = full scroll speed
  final Axis direction;

  @override
  State<ParallaxScroll> createState() => _ParallaxScrollState();
}

class _ParallaxScrollState extends State<ParallaxScroll> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            _scrollOffset = notification.metrics.extentBefore;
          });
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final offset = widget.direction == Axis.vertical
              ? Offset(0, _scrollOffset * widget.parallaxFactor)
              : Offset(_scrollOffset * widget.parallaxFactor, 0);

          return Transform.translate(
            offset: offset,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Widget that tracks scroll position and provides it to its builder.
/// Useful for custom parallax effects without setState.
class ScrollAwareBuilder extends StatefulWidget {
  const ScrollAwareBuilder({
    required this.builder,
    this.scrollController,
    super.key,
  });

  final Widget Function(BuildContext context, double scrollOffset) builder;
  final ScrollController? scrollController;

  @override
  State<ScrollAwareBuilder> createState() => _ScrollAwareBuilderState();
}

class _ScrollAwareBuilderState extends State<ScrollAwareBuilder> {
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ScrollAwareBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = widget.scrollController?.offset ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _scrollOffset);
  }
}

/// Applies a parallax transform based on scroll position.
/// More efficient than ParallaxScroll as it uses AnimatedBuilder.
class ParallaxTransform extends StatelessWidget {
  const ParallaxTransform({
    required this.child,
    required this.scrollController,
    this.parallaxFactor = 0.5,
    this.direction = Axis.vertical,
    super.key,
  });

  final Widget child;
  final ScrollController scrollController;
  final double parallaxFactor;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = direction == Axis.vertical
            ? Offset(0, scrollController.offset * parallaxFactor)
            : Offset(scrollController.offset * parallaxFactor, 0);

        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
    );
  }
}
