import 'dart:math';

import 'package:flutter/material.dart';

/// Multi-layer parallax hero section with depth effect.
/// Each layer moves at different speeds for 3D depth perception.
class MultiLayerParallax extends StatefulWidget {
  const MultiLayerParallax({
    required this.background,
    required this.midground,
    required this.foreground,
    this.parallaxFactor = 0.3,
    super.key,
  });

  final Widget background;
  final Widget midground;
  final Widget foreground;
  final double parallaxFactor;

  @override
  State<MultiLayerParallax> createState() => _MultiLayerParallaxState();
}

class _MultiLayerParallaxState extends State<MultiLayerParallax> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        setState(() {
          // Normalize to -1 to 1 range
          _offset = Offset(
            (event.position.dx / size.width - 0.5) * 2,
            (event.position.dy / size.height - 0.5) * 2,
          );
        });
      },
      onExit: (_) {
        setState(() {
          _offset = Offset.zero;
        });
      },
      child: ClipRect(
        child: Stack(
          children: [
            // Background layer (moves least)
            Transform.translate(
              offset: Offset(
                _offset.dx * 20 * widget.parallaxFactor,
                _offset.dy * 20 * widget.parallaxFactor,
              ),
              child: widget.background,
            ),
            // Midground layer (moves medium)
            Transform.translate(
              offset: Offset(
                _offset.dx * 40 * widget.parallaxFactor,
                _offset.dy * 40 * widget.parallaxFactor,
              ),
              child: widget.midground,
            ),
            // Foreground layer (moves most)
            Transform.translate(
              offset: Offset(
                _offset.dx * 60 * widget.parallaxFactor,
                _offset.dy * 60 * widget.parallaxFactor,
              ),
              child: widget.foreground,
            ),
          ],
        ),
      ),
    );
  }
}

/// Parallax hero content with layered text and elements.
class ParallaxHeroContent extends StatefulWidget {
  const ParallaxHeroContent({
    required this.name,
    required this.subtitle,
    required this.typingText,
    required this.ctaButtons,
    required this.accentColor,
    super.key,
  });

  final String name;
  final String subtitle;
  final Widget typingText;
  final Widget ctaButtons;
  final Color accentColor;

  @override
  State<ParallaxHeroContent> createState() => _ParallaxHeroContentState();
}

class _ParallaxHeroContentState extends State<ParallaxHeroContent> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _offset = Offset(
            (event.position.dx / size.width - 0.5) * 2,
            (event.position.dy / size.height - 0.5) * 2,
          );
        });
      },
      onExit: (_) {
        setState(() {
          _offset = Offset.zero;
        });
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name layer (moves most - closest)
                Transform.translate(
                  offset: Offset(_offset.dx * 30, _offset.dy * 20),
                  child: Transform.scale(
                    scale: 1 + (_offset.distance * 0.02).clamp(0.0, 0.05),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: widget.accentColor,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle layer (moves medium)
                Transform.translate(
                  offset: Offset(_offset.dx * 20, _offset.dy * 15),
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                // Typing text layer (moves less)
                Transform.translate(
                  offset: Offset(_offset.dx * 10, _offset.dy * 10),
                  child: widget.typingText,
                ),
                const SizedBox(height: 40),
                // CTA buttons layer (moves least - furthest from text)
                Transform.translate(
                  offset: Offset(_offset.dx * 5, _offset.dy * 5),
                  child: widget.ctaButtons,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating particles with parallax depth.
class ParallaxParticles extends StatefulWidget {
  const ParallaxParticles({
    required this.particles,
    this.parallaxFactor = 0.5,
    super.key,
  });

  final List<ParticleLayer> particles;
  final double parallaxFactor;

  @override
  State<ParallaxParticles> createState() => _ParallaxParticlesState();
}

class _ParallaxParticlesState extends State<ParallaxParticles> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final size = MediaQuery.of(context).size;
        setState(() {
          _offset = Offset(
            (event.position.dx / size.width - 0.5) * 2,
            (event.position.dy / size.height - 0.5) * 2,
          );
        });
      },
      onExit: (_) {
        setState(() {
          _offset = Offset.zero;
        });
      },
      child: Stack(
        children: widget.particles.map((particle) {
          final parallax = _offset * particle.depth * widget.parallaxFactor * 50;
          return Positioned(
            left: particle.x + parallax.dx,
            top: particle.y + parallax.dy,
            child: RepaintBoundary(
              child: Opacity(
                opacity: particle.opacity,
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: particle.color,
                    boxShadow: [
                      BoxShadow(
                        color: particle.color.withValues(alpha: 0.5),
                        blurRadius: particle.size * 2,
                        spreadRadius: particle.size / 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Particle data for parallax effect.
class ParticleLayer {
  const ParticleLayer({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.opacity,
    required this.depth,
  });

  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;
  final double depth; // 0 = far, 1 = close
}

/// Generates random particles for background.
List<ParticleLayer> generateParticles({
  required int count,
  required Color color,
  required Size size,
}) {
  final random = Random();
  return List.generate(
    count,
    (i) => ParticleLayer(
      x: random.nextDouble() * size.width,
      y: random.nextDouble() * size.height,
      size: 2 + random.nextDouble() * 4,
      color: color,
      opacity: 0.1 + random.nextDouble() * 0.3,
      depth: 0.2 + random.nextDouble() * 0.6,
    ),
  );
}
