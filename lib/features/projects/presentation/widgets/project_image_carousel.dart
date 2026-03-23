import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/theme/app_colors.dart';
import 'image_lightbox.dart';

class ProjectImageCarousel extends StatefulWidget {
  const ProjectImageCarousel({
    required this.images,
    required this.accent,
    super.key,
  });

  final List<String> images;
  final Color accent;

  @override
  State<ProjectImageCarousel> createState() => _ProjectImageCarouselState();
}

class _ProjectImageCarouselState extends State<ProjectImageCarousel> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    final screenH = MediaQuery.of(context).size.height;
    final carouselH = (screenH * 0.45).clamp(280.0, 480.0);

    return Column(
      children: [
        SizedBox(
          height: carouselH,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final imageUrl = widget.images[index];
                return GestureDetector(
                  onTap: () => ImageLightbox.show(
                    context,
                    widget.images,
                    index,
                    widget.accent,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.zoomIn,
                    child: Container(
                      color: AppColors.surfaceSecondary,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.surfaceTertiary,
                          highlightColor: AppColors.surfaceQuaternary,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surfaceTertiary,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.textTertiary,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          SmoothPageIndicator(
            controller: _pageController,
            count: widget.images.length,
            effect: ScrollingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: widget.accent,
              dotColor: AppColors.surfaceQuaternary,
            ),
          ),
        ],
      ],
    );
  }
}
