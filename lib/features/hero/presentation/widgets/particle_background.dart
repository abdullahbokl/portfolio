import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

import 'particle.dart';
import 'particle_painter.dart';

/// Full-bleed animated particle background with connecting lines.
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final _random = Random();
  bool _initialized = false;

  // Optimized particle counts (reduced for better performance)
  static const _particleCountMobile = 15;
  static const _particleCountTablet = 25;
  static const _particleCountDesktop = 35;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _particles = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _initParticles(size, context.isMobile, context.isTablet);
  }

  void _initParticles(Size size, bool isMobile, bool isTablet) {
    if (_initialized) return;
    _initialized = true;

    final count = isMobile
        ? _particleCountMobile
        : isTablet
        ? _particleCountTablet
        : _particleCountDesktop;

    _particles = List.generate(count, (_) {
      return Particle(
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
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size, context.isMobile, context.isTablet);

        return RepaintBoundary(
          child: CustomPaint(
            size: size,
            painter: ParticlePainter(
              particles: _particles,
              accentColor: context.accent.accent,
              repaint: _controller,
            ),
          ),
        );
      },
    );
  }
}
