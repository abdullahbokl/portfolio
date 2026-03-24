import 'dart:math';

import 'package:flutter/material.dart';

import 'particle.dart';

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    required this.accentColor,
    required Listenable repaint,
  }) : super(repaint: repaint) {
    _linePaint = Paint()..strokeWidth = 0.5;
    _particlePaint = Paint()..style = PaintingStyle.fill;
  }

  final List<Particle> particles;
  final Color accentColor;
  late final Paint _linePaint;
  late final Paint _particlePaint;

  static const _connectionDistance = 120.0;
  static const _connectionDistanceSq = _connectionDistance * _connectionDistance;

  @override
  void paint(Canvas canvas, Size size) {
    _updateParticles(size);

    // 1. Connection lines
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final dx = p1.x - p2.x;
        final dy = p1.y - p2.y;
        final distSq = dx * dx + dy * dy;

        if (distSq < _connectionDistanceSq) {
          final dist = sqrt(distSq);
          final opacity = (1 - dist / _connectionDistance) * 0.15;
          _linePaint.color = accentColor.withValues(alpha: opacity);
          
          canvas.drawLine(
            Offset(p1.x, p1.y),
            Offset(p2.x, p2.y),
            _linePaint,
          );
        }
      }
    }

    // 2. Individual particles
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      _particlePaint.color = accentColor.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, _particlePaint);
    }
  }

  void _updateParticles(Size size) {
    for (final p in particles) {
      p.x += p.dx;
      p.y += p.dy;

      if (p.x < 0) p.x = size.width;
      if (p.x > size.width) p.x = 0;
      if (p.y < 0) p.y = size.height;
      if (p.y > size.height) p.y = 0;
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.accentColor != accentColor ||
        oldDelegate.particles != particles;
  }
}
