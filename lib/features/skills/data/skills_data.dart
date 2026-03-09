import 'package:flutter/material.dart';

import '../domain/skill_model.dart';

abstract final class SkillsData {
  static const categories = [
    SkillCategory(
      title: 'Core Engineering',
      icon: Icons.memory_outlined,
      skills: [
        Skill(name: 'Programming Languages (C++, Dart, Swift, Python, Java, JavaScript, etc.)', proficiency: 0.95, level: 'Expert'),
        Skill(name: 'Algorithmic Problem Solving', proficiency: 0.95, level: 'Expert'),
        Skill(name: 'Data Structures', proficiency: 0.95, level: 'Expert'),
        Skill(name: 'OOP', proficiency: 0.90, level: 'Expert'),
      ],
    ),
    SkillCategory(
      title: 'Architectural Patterns',
      icon: Icons.architecture_outlined,
      skills: [
        Skill(name: 'Clean Architecture', proficiency: 0.92, level: 'Expert'),
        Skill(name: 'Event-Driven Architecture', proficiency: 0.88, level: 'Advanced'),
        Skill(name: 'MVC', proficiency: 0.85, level: 'Advanced'),
        Skill(name: 'MVVM', proficiency: 0.85, level: 'Advanced'),
      ],
    ),
    SkillCategory(
      title: 'State Management',
      icon: Icons.account_tree_outlined,
      skills: [
        Skill(name: 'BLoC / Cubit', proficiency: 0.95, level: 'Expert'),
        Skill(name: 'Provider', proficiency: 0.85, level: 'Advanced'),
        Skill(name: 'Riverpod', proficiency: 0.75, level: 'Proficient'),
        Skill(name: 'GetX / Mobx / Redux', proficiency: 0.70, level: 'Proficient'),
      ],
    ),
    SkillCategory(
      title: 'App Development',
      icon: Icons.phone_iphone_outlined,
      skills: [
        Skill(name: 'Flutter (Cross-platform)', proficiency: 0.95, level: 'Expert'),
        Skill(name: 'Native iOS (Swift)', proficiency: 0.70, level: 'Proficient'),
        Skill(name: 'Responsive UI / UX', proficiency: 0.88, level: 'Advanced'),
        Skill(name: 'Flutter Web', proficiency: 0.82, level: 'Advanced'),
      ],
    ),
    SkillCategory(
      title: 'Backend & Database',
      icon: Icons.cloud_outlined,
      skills: [
        Skill(name: 'Firebase / Firestore', proficiency: 0.90, level: 'Expert'),
        Skill(name: 'Cloud Functions / Eventarc', proficiency: 0.85, level: 'Advanced'),
        Skill(name: 'Supabase', proficiency: 0.72, level: 'Proficient'),
        Skill(name: 'REST API Integration', proficiency: 0.88, level: 'Advanced'),
      ],
    ),
    SkillCategory(
      title: 'DevOps & Tools',
      icon: Icons.build_outlined,
      skills: [
        Skill(name: 'Shorebird OTA', proficiency: 0.80, level: 'Advanced'),
        Skill(name: 'Doppler (Secrets)', proficiency: 0.75, level: 'Proficient'),
        Skill(name: 'Firebase Emulators', proficiency: 0.78, level: 'Proficient'),
        Skill(name: 'Git / GitHub', proficiency: 0.90, level: 'Expert'),
      ],
    ),
    SkillCategory(
      title: 'Quality & Security',
      icon: Icons.verified_user_outlined,
      skills: [
        Skill(name: 'SOLID Principles', proficiency: 0.92, level: 'Expert'),
        Skill(name: 'Clean Code', proficiency: 0.90, level: 'Expert'),
        Skill(name: 'Unit Testing', proficiency: 0.78, level: 'Proficient'),
        Skill(name: 'Backend-Auth Security', proficiency: 0.85, level: 'Advanced'),
      ],
    ),
  ];
}

