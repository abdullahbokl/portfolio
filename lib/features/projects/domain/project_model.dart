import 'package:flutter/material.dart';

class ProjectModel {
  const ProjectModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.techTags,
    required this.architectureHighlights,
    required this.icon,
    this.liveUrl,
    this.appleStoreUrl,
    this.webUrl,
    this.githubUrl,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> techTags;
  final List<String> architectureHighlights;
  final IconData icon;
  final String? liveUrl; // Google Play
  final String? appleStoreUrl;
  final String? webUrl;
  final String? githubUrl;
}

