import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../domain/project_model.dart';

abstract final class ProjectData {
  static const projects = [
    ProjectModel(
      title: AppStrings.bokloTitle,
      subtitle: AppStrings.bokloSubtitle,
      description: AppStrings.bokloDescription,
      techTags: AppStrings.bokloTech,
      architectureHighlights: AppStrings.bokloHighlights,
      icon: Icons.account_balance_wallet_outlined,
      githubUrl: AppStrings.bokloGithubUrl,
    ),
    ProjectModel(
      title: AppStrings.crmTitle,
      subtitle: AppStrings.crmSubtitle,
      description: AppStrings.crmDescription,
      techTags: AppStrings.crmTech,
      architectureHighlights: AppStrings.crmHighlights,
      icon: Icons.business_center_outlined,
      liveUrl: AppStrings.crmPlayStoreUrl,
      appleStoreUrl: AppStrings.crmAppleStoreUrl,
    ),
    ProjectModel(
      title: AppStrings.kiranaTitle,
      subtitle: AppStrings.kiranaSubtitle,
      description: AppStrings.kiranaDescription,
      techTags: AppStrings.kiranaTech,
      architectureHighlights: AppStrings.kiranaHighlights,
      icon: Icons.inventory_2_outlined,
      liveUrl: AppStrings.kiranaPlayStoreUrl,
      appleStoreUrl: AppStrings.kiranaAppleStoreUrl,
      webUrl: AppStrings.kiranaWebUrl,
    ),
    ProjectModel(
      title: AppStrings.jobHubTitle,
      subtitle: AppStrings.jobHubSubtitle,
      description: AppStrings.jobHubDescription,
      techTags: AppStrings.jobHubTech,
      architectureHighlights: AppStrings.jobHubHighlights,
      icon: Icons.work_outline,
      githubUrl: AppStrings.jobHubGithubUrl,
    ),
    ProjectModel(
      title: AppStrings.netflixTitle,
      subtitle: AppStrings.netflixSubtitle,
      description: AppStrings.netflixDescription,
      techTags: AppStrings.netflixTech,
      architectureHighlights: AppStrings.netflixHighlights,
      icon: Icons.play_circle_outline,
      githubUrl: AppStrings.netflixGithubUrl,
    ),
  ];
}

