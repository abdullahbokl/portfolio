import 'package:flutter/material.dart';

import '../domain/experience_model.dart';

abstract final class ExperienceData {
  static const experiences = [
    ExperienceModel(
      company: 'Smart Life',
      role: 'Senior / Mid-Level Flutter Developer',
      period: 'Feb 2024 – Oct 2024',
      icon: Icons.rocket_launch_outlined,
      highlights: [
        'Led mission-critical migration from Provider/MVVM to N-layer BLoC architecture',
        'Integrated Shorebird for seamless OTA updates & Doppler for secret management',
        'Architected responsive Flutter Web version solving complex SPA routing challenges',
        'Engineered granular page-level privilege system for secure enterprise operations',
      ],
    ),
    ExperienceModel(
      company: 'Xero-Apps',
      role: 'Flutter Developer',
      period: 'Jun 2023 – Jan 2024',
      icon: Icons.inventory_2_outlined,
      highlights: [
        'Developed Kiranafast & Ease My Store using Firebase for live stock management',
        'Engineered Batch System handling variable arrival dates & multi-tier pricing',
        'Optimized async streams & Google Maps for real-time order tracking accuracy',
      ],
    ),
    ExperienceModel(
      company: 'Arunoday-Tech',
      role: 'Flutter Developer',
      period: 'Mar 2023 – May 2023',
      icon: Icons.code_outlined,
      highlights: [
        'Implemented BLoC-based MVVM architecture for modular code & clean state separation',
        'Optimized REST API consumption for efficient data fetching & real-time UI updates',
      ],
    ),
    ExperienceModel(
      company: 'ITI & Internships',
      role: 'iOS Developer / Flutter Developer',
      period: 'Aug 2022 – Feb 2023',
      icon: Icons.school_outlined,
      highlights: [
        'Built high-performance native iOS apps using Swift, UIKit, and Alamofire',
        'Delivered 15+ features in a single month using Riverpod for scalable DI',
      ],
    ),
    ExperienceModel(
      company: 'ICPC Algorithmic Training',
      role: 'Technical Leadership',
      period: '2021 – 2024',
      icon: Icons.emoji_events_outlined,
      isLeadership: true,
      highlights: [
        'Designed & delivered algorithmic curriculum for 120+ students',
        'Solved 1,000+ challenges on LeetCode & Codeforces',
        'Ranked 1st at university level — 2x ICPC Regional Finalist',
      ],
    ),
    ExperienceModel(
      company: 'Port-Said University',
      role: 'B.Sc. Technology and Information Systems',
      period: '2019 – 2023',
      icon: Icons.school_outlined,
      isEducation: true,
      // computer science topics
      highlights: [
        '1st place university-wide in ICPC competitive programming',
        'Strong foundation in algorithms, data structures, and OOP',
      ],
    ),
  ];
}
