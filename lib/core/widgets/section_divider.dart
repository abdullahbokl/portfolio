import 'package:flutter/material.dart';

/// Animated section divider with icon and gradient line.
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    required this.title,
    this.icon,
    this.subtitle,
    this.color,
    this.lineGradient,
    this.showIcon = true,
    this.showSubtitle = true,
    super.key,
  });

  final String title;
  final IconData? icon;
  final String? subtitle;
  final Color? color;
  final Gradient? lineGradient;
  final bool showIcon;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showIcon && icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        if (showSubtitle && subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 16),
        // Animated gradient line
        RepaintBoundary(
          child: Container(
            height: 3,
            width: 120,
            decoration: BoxDecoration(
              gradient: lineGradient ??
                  LinearGradient(
                    colors: [
                      accentColor,
                      accentColor.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Simple animated underline for section titles.
class AnimatedUnderline extends StatefulWidget {
  const AnimatedUnderline({
    this.width = 60.0,
    this.color,
    this.height = 3.0,
    this.delay = const Duration(milliseconds: 200),
    super.key,
  });

  final double width;
  final Color? color;
  final double height;
  final Duration delay;

  @override
  State<AnimatedUnderline> createState() => _AnimatedUnderlineState();
}

class _AnimatedUnderlineState extends State<AnimatedUnderline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _widthAnimation = Tween<double>(begin: 0, end: widget.width).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            height: widget.height,
            width: _widthAnimation.value,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
          );
        },
      ),
    );
  }
}

/// Dotted line divider.
class DottedDivider extends StatelessWidget {
  const DottedDivider({
    this.color,
    this.dashWidth = 8.0,
    this.dashSpace = 4.0,
    this.thickness = 2.0,
    super.key,
  });

  final Color? color;
  final double dashWidth;
  final double dashSpace;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Colors.grey.withValues(alpha: 0.3);

    return RepaintBoundary(
      child: CustomPaint(
        size: Size(double.infinity, thickness),
        painter: _DottedLinePainter(
          color: color,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          thickness: thickness,
        ),
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  _DottedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.thickness,
  });

  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.thickness != thickness;
  }
}
