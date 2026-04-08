import 'package:flutter/material.dart';

/// Vertical progress indicator showing scroll progress through sections.
/// Displays dots for each section with the active section highlighted.
class SectionProgressIndicator extends StatefulWidget {
  const SectionProgressIndicator({
    required this.scrollController,
    required this.sectionCount,
    required this.activeIndex,
    this.onSectionTap,
    this.color,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final ScrollController scrollController;
  final int sectionCount;
  final int activeIndex;
  final Function(int)? onSectionTap;
  final Color? color;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  State<SectionProgressIndicator> createState() => _SectionProgressIndicatorState();
}

class _SectionProgressIndicatorState extends State<SectionProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? Theme.of(context).colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? Colors.grey.withValues(alpha: 0.5);

    return Positioned(
      right: 16,
      top: 0,
      bottom: 0,
      child: Center(
        child: RepaintBoundary(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.sectionCount,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _ProgressDot(
                  isActive: index == widget.activeIndex,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  onTap: widget.onSectionTap != null
                      ? () => widget.onSectionTap!(index)
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressDot extends StatefulWidget {
  const _ProgressDot({
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    this.onTap,
  });

  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback? onTap;

  @override
  State<_ProgressDot> createState() => _ProgressDotState();
}

class _ProgressDotState extends State<_ProgressDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_ProgressDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              width: 12 * _scaleAnimation.value,
              height: 12 * _scaleAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive ? widget.activeColor : widget.inactiveColor,
                border: widget.isActive
                    ? null
                    : Border.all(color: widget.inactiveColor, width: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Linear progress bar at top showing overall scroll progress.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({
    required this.scrollController,
    required this.maxScroll,
    this.color,
    this.height = 3.0,
    super.key,
  });

  final ScrollController scrollController;
  final double maxScroll;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? Theme.of(context).colorScheme.primary;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: scrollController,
          builder: (context, _) {
            final progress = scrollController.hasClients && maxScroll > 0
                ? (scrollController.offset / maxScroll).clamp(0.0, 1.0)
                : 0.0;

            return FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      progressColor,
                      progressColor.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Circular progress indicator showing scroll percentage.
class CircularScrollProgress extends StatelessWidget {
  const CircularScrollProgress({
    required this.scrollController,
    required this.maxScroll,
    this.size = 50.0,
    this.strokeWidth = 4.0,
    this.color,
    this.backgroundColor,
    this.showPercentage = true,
    super.key,
  });

  final ScrollController scrollController;
  final double maxScroll;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? Theme.of(context).colorScheme.primary;
    final bgColor = backgroundColor ?? Colors.grey.withValues(alpha: 0.2);

    return Positioned(
      right: 16,
      bottom: 16,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: scrollController,
          builder: (context, _) {
            final progress = scrollController.hasClients && maxScroll > 0
                ? (scrollController.offset / maxScroll).clamp(0.0, 1.0)
                : 0.0;

            return SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(bgColor),
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: size,
                    height: size,
                    child: Transform.rotate(
                      angle: -0.25 * 3.14159,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: strokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      ),
                    ),
                  ),
                  // Percentage text
                  if (showPercentage)
                    Center(
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: size * 0.22,
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
