import 'package:flutter/material.dart';

class ExperienceModel {
  const ExperienceModel({
    required this.company,
    required this.role,
    required this.period,
    required this.highlights,
    required this.icon,
    this.isLeadership = false,
    this.isEducation = false,
  });

  final String company;
  final String role;
  final String period;
  final List<String> highlights;
  final IconData icon;
  final bool isLeadership;
  final bool isEducation;
}
