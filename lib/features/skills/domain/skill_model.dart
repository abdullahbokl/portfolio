import 'package:flutter/material.dart';

class Skill {
  const Skill({
    required this.name,
    required this.proficiency,
    required this.level,
  });

  final String name;
  final double proficiency; // 0.0 to 1.0
  final String level;
}

class SkillCategory {
  const SkillCategory({
    required this.title,
    required this.icon,
    required this.skills,
  });

  final String title;
  final IconData icon;
  final List<Skill> skills;
}
