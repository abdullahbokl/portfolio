import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/theme/app_colors.dart';

/// Full-screen image lightbox with pinch-to-zoom, zoom buttons, and swipe nav.
class ImageLightbox extends StatefulWidget {
  const ImageLightbox({
    required this.images,
    required this.initialIndex,
    required this.accent,
    super.key,
  });

  final List<String> images;
  final int initialIndex;
  final Color accent;

  static void show(
    BuildContext context,
    List<String> images,
    int initialIndex,
    Color accent,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) => ImageLightbox(
          images: images,
          initialIndex: initialIndex,
          accent: accent,
        ),
        transitionsBuilder: (context, anim, secondary, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  State<ImageLightbox> createState() => _ImageLightboxState();
}

class _ImageLightboxState extends State<ImageLightbox> {
  late final PageController _pageController;
  late final FocusNode _focusNode;
  late int _currentIndex;

  // One TransformationController per page so zooms are independent
  // Store controllers lazily to save memory
  final Map<int, TransformationController> _transformControllers = {};

  TransformationController _getController(int index) {
    return _transformControllers.putIfAbsent(
      index,
      () => TransformationController(),
    );
  }

  static const double _minScale = 1.0;
  static const double _maxScale = 5.0;
  static const double _zoomStep = 0.75;

  double get _currentScale {
    final m = _getController(_currentIndex).value;
    return m.getMaxScaleOnAxis();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _focusNode = FocusNode()..requestFocus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    for (final c in _transformControllers.values) {
      c.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  void _zoomIn() => _animateScale(_currentScale + _zoomStep);
  void _zoomOut() => _animateScale(_currentScale - _zoomStep);
  void _resetZoom() {
    _getController(_currentIndex).value = Matrix4.identity();
    setState(() {});
  }

  void _animateScale(double targetScale) {
    final clamped = targetScale.clamp(_minScale, _maxScale);
    final controller = _getController(_currentIndex);
    final size = MediaQuery.of(context).size;
    // Scale around the viewport center so image stays centered
    final cx = size.width / 2;
    final cy = size.height / 2;
    final newM = Matrix4.identity()
      ..setEntry(0, 0, clamped)
      ..setEntry(1, 1, clamped)
      // Translation that keeps the focal point (center) stationary
      ..setEntry(0, 3, cx * (1.0 - clamped))
      ..setEntry(1, 3, cy * (1.0 - clamped));
    controller.value = newM;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final canZoomIn = _currentScale < _maxScale - 0.1;
    final canZoomOut = _currentScale > _minScale + 0.1;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.escape) _close();
          if (event.logicalKey == LogicalKeyboardKey.equal) _zoomIn();
          if (event.logicalKey == LogicalKeyboardKey.minus) _zoomOut();
          if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              _currentIndex < widget.images.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              _currentIndex > 0) {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            // Tapping background dismisses (only at 1x zoom)
            GestureDetector(
              onTap: _currentScale <= _minScale + 0.01 ? _close : null,
              child: Container(color: Colors.transparent),
            ),

            // Image pager with pinch-to-zoom
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              physics: _currentScale > _minScale + 0.01
                  ? const NeverScrollableScrollPhysics()
                  : const PageScrollPhysics(),
              onPageChanged: (i) => setState(() {
                _currentIndex = i;
              }),
              itemBuilder: (context, index) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return InteractiveViewer(
                      transformationController: _getController(index),
                      minScale: _minScale,
                      maxScale: _maxScale,
                      // Constrained boundary — content stays on-screen
                      boundaryMargin: EdgeInsets.zero,
                      constrained: true,
                      onInteractionUpdate: (_) => setState(() {}),
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: Center(
                          child: Padding(
                            // Reserve space for top/bottom UI bars
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: CachedNetworkImage(
                              imageUrl: widget.images[index],
                              fit: BoxFit.contain,
                              // Full resolution for lightbox view
                              maxWidthDiskCache: 1200,
                              maxHeightDiskCache: 900,
                              memCacheWidth: 600,
                              memCacheHeight: 450,
                              placeholder: (context, url) => RepaintBoundary(
                                child: Shimmer.fromColors(
                                  baseColor: AppColors.surfaceTertiary,
                                  highlightColor: AppColors.surfaceQuaternary,
                                  child: Container(
                                    color: Colors.white,
                                    width: 300,
                                    height: 500,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.textTertiary,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // ── Top bar: counter + close ─────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 8,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    _IconBtn(
                      icon: Icons.close,
                      tooltip: 'Close (Esc)',
                      onTap: _close,
                    ),
                  ],
                ),
              ),
            ),

            // ── Left / Right arrows ──────────────────────────────────────
            if (widget.images.length > 1) ...[
              if (_currentIndex > 0)
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavArrow(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
              if (_currentIndex < widget.images.length - 1)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _NavArrow(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
            ],

            // ── Bottom toolbar: zoom controls + dot indicator ────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicator
                    if (widget.images.length > 1)
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: widget.images.length,
                        effect: ScrollingDotsEffect(
                          dotHeight: 6,
                          dotWidth: 6,
                          activeDotColor: widget.accent,
                          dotColor: Colors.white30,
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Zoom controls row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ZoomButton(
                          icon: Icons.remove_rounded,
                          label: 'Zoom out',
                          enabled: canZoomOut,
                          accent: widget.accent,
                          onTap: canZoomOut ? _zoomOut : null,
                        ),
                        const SizedBox(width: 8),
                        // Scale label / reset button
                        GestureDetector(
                          onTap: _resetZoom,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: canZoomOut || canZoomIn
                                  ? Colors.white12
                                  : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: canZoomOut || canZoomIn
                                    ? Colors.white30
                                    : Colors.white10,
                              ),
                            ),
                            child: Text(
                              '${(_currentScale * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _ZoomButton(
                          icon: Icons.add_rounded,
                          label: 'Zoom in',
                          enabled: canZoomIn,
                          accent: widget.accent,
                          onTap: canZoomIn ? _zoomIn : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ───────────────────────────────────────────────────────────

class _IconBtn extends StatefulWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.tooltip = '',
  });
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _hovered
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black45,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}

class _NavArrow extends StatefulWidget {
  const _NavArrow({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_NavArrow> createState() => _NavArrowState();
}

class _NavArrowState extends State<_NavArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.black.withValues(alpha: 0.7)
                : Colors.black45,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _hovered ? Colors.white30 : Colors.transparent,
            ),
          ),
          child: Icon(widget.icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _ZoomButton extends StatefulWidget {
  const _ZoomButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.accent,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool enabled;
  final Color accent;
  final VoidCallback? onTap;

  @override
  State<_ZoomButton> createState() => _ZoomButtonState();
}

class _ZoomButtonState extends State<_ZoomButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: !widget.enabled
                  ? Colors.white10
                  : _hovered
                  ? widget.accent.withValues(alpha: 0.25)
                  : Colors.white12,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: !widget.enabled
                    ? Colors.white10
                    : _hovered
                    ? widget.accent.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              widget.icon,
              color: !widget.enabled
                  ? Colors.white24
                  : _hovered
                  ? widget.accent
                  : Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
