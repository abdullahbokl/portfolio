import 'package:flutter/material.dart';

/// Skeleton loader for text content.
class TextSkeleton extends StatelessWidget {
  const TextSkeleton({
    this.width = double.infinity,
    this.height = 16.0,
    this.borderRadius = 4.0,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Skeleton loader for card/image content.
class CardSkeleton extends StatelessWidget {
  const CardSkeleton({
    this.height = 200.0,
    this.borderRadius = 12.0,
    this.showImage = true,
    this.showText = true,
    super.key,
  });

  final double height;
  final double borderRadius;
  final bool showImage;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: showText
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showImage)
                      Container(
                        height: height * 0.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    if (showImage) const SizedBox(height: 12),
                    const TextSkeleton(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    const TextSkeleton(width: 200, height: 12),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}

/// Skeleton loader for list items.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    required this.itemCount,
    this.itemHeight = 60.0,
    this.spacing = 8.0,
    this.showAvatar = true,
    super.key,
  });

  final int itemCount;
  final double itemHeight;
  final double spacing;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: Row(
              children: [
                if (showAvatar) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextSkeleton(width: 150, height: 12),
                      const SizedBox(height: 6),
                      const TextSkeleton(width: double.infinity, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated shimmer effect wrapper.
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.color,
    this.highlightColor,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Color? color;
  final Color? highlightColor;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? Colors.grey.withValues(alpha: 0.3);
    final highlightColor = widget.highlightColor ?? Colors.grey.withValues(alpha: 0.5);

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  baseColor,
                  highlightColor,
                  baseColor,
                ],
                stops: [
                  (_animation.value - 0.5).clamp(0.0, 1.0),
                  _animation.value.clamp(0.0, 1.0),
                  (_animation.value + 0.5).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Full page skeleton loader.
class PageSkeleton extends StatelessWidget {
  const PageSkeleton({
    this.showHeader = true,
    this.showContent = true,
    this.contentLines = 3,
    super.key,
  });

  final bool showHeader;
  final bool showContent;
  final int contentLines;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              const TextSkeleton(width: 200, height: 32),
              const SizedBox(height: 16),
              const TextSkeleton(width: 300, height: 16),
              const SizedBox(height: 32),
            ],
            if (showContent) ...[
              for (int i = 0; i < contentLines; i++) ...[
                const TextSkeleton(width: double.infinity, height: 14),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
