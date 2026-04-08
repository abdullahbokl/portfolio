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

  // Spatial hash grid for optimized neighbor lookup
  final Map<String, List<Particle>> _spatialGrid = {};
  static const _cellSize = _connectionDistance;

  @override
  void paint(Canvas canvas, Size size) {
    _updateParticles(size);
    _buildSpatialGrid();

    // 1. Connection lines using spatial hashing (O(n) instead of O(n²))
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      final cellX = (p1.x / _cellSize).floor();
      final cellY = (p1.y / _cellSize).floor();

      // Check only neighboring cells
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          final key = '${cellX + dx},${cellY + dy}';
          final neighbors = _spatialGrid[key];
          if (neighbors == null) continue;

          for (final p2 in neighbors) {
            // Skip self and avoid duplicate checks
            if (identical(p1, p2) || p1.hashCode < p2.hashCode) continue;

            final ddx = p1.x - p2.x;
            final ddy = p1.y - p2.y;
            final distSq = ddx * ddx + ddy * ddy;

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
      }
    }

    // 2. Individual particles
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      _particlePaint.color = accentColor.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, _particlePaint);
    }
  }

  void _buildSpatialGrid() {
    _spatialGrid.clear();
    for (final p in particles) {
      final cellX = (p.x / _cellSize).floor();
      final cellY = (p.y / _cellSize).floor();
      final key = '$cellX,$cellY';
      _spatialGrid.putIfAbsent(key, () => []).add(p);
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
