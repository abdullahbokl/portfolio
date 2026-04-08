import 'package:flutter/material.dart';

import '../../../bloc/navigation/navigation_cubit.dart';
import '../../../core/widgets/section_wrapper.dart';
import '../../../features/about/presentation/about_section.dart';
import '../../../features/contact/presentation/contact_section.dart';
import '../../../features/experience/presentation/experience_section.dart';
import '../../../features/hero/presentation/hero_section.dart';
import '../../../features/projects/presentation/projects_section.dart';
import '../../../features/skills/presentation/skills_section.dart';

class SectionList extends StatelessWidget {
  const SectionList({
    required this.navCubit,
    this.onSectionChanged,
    super.key,
  });

  final NavigationCubit navCubit;
  final Function(int)? onSectionChanged;

  @override
  Widget build(BuildContext context) {
    final keys = navCubit.sectionKeys;

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionWrapper(
            sectionKey: keys[0],
            onVisible: () {
              navCubit.setActive(0);
              onSectionChanged?.call(0);
            },
            isInitial: true,
            child: const HeroSection(),
          ),
          SectionWrapper(
            sectionKey: keys[1],
            onVisible: () {
              navCubit.setActive(1);
              onSectionChanged?.call(1);
            },
            child: const AboutSection(),
          ),
          SectionWrapper(
            sectionKey: keys[2],
            onVisible: () {
              navCubit.setActive(2);
              onSectionChanged?.call(2);
            },
            child: const ProjectsSection(),
          ),
          SectionWrapper(
            sectionKey: keys[3],
            onVisible: () {
              navCubit.setActive(3);
              onSectionChanged?.call(3);
            },
            child: const ExperienceSection(),
          ),
          SectionWrapper(
            sectionKey: keys[4],
            onVisible: () {
              navCubit.setActive(4);
              onSectionChanged?.call(4);
            },
            child: const SkillsSection(),
          ),
          SectionWrapper(
            sectionKey: keys[5],
            onVisible: () {
              navCubit.setActive(5);
              onSectionChanged?.call(5);
            },
            child: const ContactSection(),
          ),
        ],
      ),
    );
  }
}
