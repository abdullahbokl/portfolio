import 'package:flutter/material.dart';

/// 3D-style skill bar with depth effect and glow.
class SkillBar3D extends StatelessWidget {
  const SkillBar3D({
    required this.skill,
    required this.animation,
    required this.accent,
    this.height = 24.0,
    this.borderRadius = 12.0,
    super.key,
  });

  final String skill;
  final Animation<double> animation;
  final Color accent;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final progress = (animation.value * 100).round();
                return Text(
                  '$progress%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accent.withValues(alpha: 0.8),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        RepaintBoundary(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  return FractionallySizedBox(
                    widthFactor: animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accent.withValues(alpha: 0.7),
                            accent,
                            accent.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Skill category card with 3D effect.
class SkillCard3D extends StatelessWidget {
  const SkillCard3D({
    required this.title,
    required this.icon,
    required this.skills,
    required this.animation,
    required this.accent,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<String> skills;
  final Animation<double> animation;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accent, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...skills.asMap().entries.map((entry) {
              final index = entry.key;
              final skill = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < skills.length - 1 ? 16 : 0,
                ),
                child: SkillBar3D(
                  skill: skill,
                  animation: animation,
                  accent: accent,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
