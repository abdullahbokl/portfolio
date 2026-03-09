import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

/// Full-bleed animated particle background with connecting lines.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _particles = [];
  }

  void _initParticles(Size size, bool isMobile, bool isTablet) {
    if (_initialized) return;
    _initialized = true;

    final count = isMobile
        ? 20
        : isTablet
            ? 30
            : 50;

    _particles = List.generate(count, (_) {
      return _Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        radius: 1.0 + _random.nextDouble() * 2.0,
        opacity: 0.1 + _random.nextDouble() * 0.3,
        dx: (_random.nextDouble() - 0.5) * 0.5,
        dy: (_random.nextDouble() - 0.5) * 0.5,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return const SizedBox.expand();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size, context.isMobile, context.isTablet);

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              _updateParticles(size);
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  accentColor: context.accent.accent,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _updateParticles(Size size) {
    for (final p in _particles) {
      p.x += p.dx;
      p.y += p.dy;

      if (p.x < 0) p.x = size.width;
      if (p.x > size.width) p.x = 0;
      if (p.y < 0) p.y = size.height;
      if (p.y > size.height) p.y = 0;
    }
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.dx,
    required this.dy,
  });

  double x;
  double y;
  final double radius;
  final double opacity;
  final double dx;
  final double dy;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.particles, required this.accentColor});

  final List<_Particle> particles;
  final Color accentColor;

  static const _connectionDistance = 120.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connection lines
    final linePaint = Paint()..strokeWidth = 0.5;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < _connectionDistance) {
          final opacity = (1 - distance / _connectionDistance) * 0.15;
          linePaint.color = accentColor.withValues(alpha: opacity);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }

    // Draw particles
    for (final p in particles) {
      final paint = Paint()
        ..color = accentColor.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}


