import 'package:flutter/material.dart';

import '../../../../core/constants/project_strings.dart';
import '../domain/project_model.dart';

abstract final class ProjectData {
  static const projects = [
    ProjectModel(
      title: ProjectStrings.bokloTitle,
      subtitle: ProjectStrings.bokloSubtitle,
      description: ProjectStrings.bokloDescription,
      techTags: ProjectStrings.bokloTech,
      architectureHighlights: ProjectStrings.bokloHighlights,
      icon: Icons.account_balance_wallet,
      imageUrls: ProjectStrings.bokloImages,
      githubUrl: ProjectStrings.bokloGithubUrl,
    ),
    ProjectModel(
      title: ProjectStrings.crmTitle,
      subtitle: ProjectStrings.crmSubtitle,
      description: ProjectStrings.crmDescription,
      techTags: ProjectStrings.crmTech,
      architectureHighlights: ProjectStrings.crmHighlights,
      icon: Icons.business_center,
      imageUrls: ProjectStrings.crmImages,
      liveUrl: ProjectStrings.crmPlayStoreUrl,
      appleStoreUrl: ProjectStrings.crmAppleStoreUrl,
    ),
    ProjectModel(
      title: ProjectStrings.kiranaTitle,
      subtitle: ProjectStrings.kiranaSubtitle,
      description: ProjectStrings.kiranaDescription,
      techTags: ProjectStrings.kiranaTech,
      architectureHighlights: ProjectStrings.kiranaHighlights,
      icon: Icons.inventory,
      imageUrls: ProjectStrings.kiranaImages,
      liveUrl: ProjectStrings.kiranaPlayStoreUrl,
      appleStoreUrl: ProjectStrings.kiranaAppleStoreUrl,
      webUrl: ProjectStrings.kiranaWebUrl,
    ),
    ProjectModel(
      title: ProjectStrings.jobHubTitle,
      subtitle: ProjectStrings.jobHubSubtitle,
      description: ProjectStrings.jobHubDescription,
      techTags: ProjectStrings.jobHubTech,
      architectureHighlights: ProjectStrings.jobHubHighlights,
      icon: Icons.work,
      imageUrls: ProjectStrings.jobHubImages,
      githubUrl: ProjectStrings.jobHubGithubUrl,
    ),
    ProjectModel(
      title: ProjectStrings.netflixTitle,
      subtitle: ProjectStrings.netflixSubtitle,
      description: ProjectStrings.netflixDescription,
      techTags: ProjectStrings.netflixTech,
      architectureHighlights: ProjectStrings.netflixHighlights,
      icon: Icons.movie,
      githubUrl: ProjectStrings.netflixGithubUrl,
    ),
  ];
}
