import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Enhanced typing text with typewriter effect + cursor.
class TypingText extends StatefulWidget {
  const TypingText({required this.phrases, super.key});

  final List<String> phrases;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  late final ValueNotifier<String> _textNotifier;
  late final ValueNotifier<bool> _cursorNotifier;
  int _phraseIndex = 0;
  bool _isDeleting = false;
  Timer? _typingTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _textNotifier = ValueNotifier('');
    _cursorNotifier = ValueNotifier(true);
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _cursorNotifier.value = !_cursorNotifier.value;
    });
    _startTyping();
  }

  void _startTyping() {
    final phrase = widget.phrases[_phraseIndex];
    final currentText = _textNotifier.value;

    if (_isDeleting) {
      if (currentText.isNotEmpty) {
        _typingTimer = Timer(const Duration(milliseconds: 30), () {
          if (!mounted) return;
          _textNotifier.value = currentText.substring(0, currentText.length - 1);
          _startTyping();
        });
      } else {
        _isDeleting = false;
        _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
        _typingTimer = Timer(const Duration(milliseconds: 500), _startTyping);
      }
    } else {
      if (currentText.length < phrase.length) {
        _typingTimer = Timer(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          _textNotifier.value = phrase.substring(0, currentText.length + 1);
          _startTyping();
        });
      } else {
        _typingTimer = Timer(const Duration(milliseconds: 2000), () {
          if (!mounted) return;
          _isDeleting = true;
          _startTyping();
        });
      }
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer?.cancel();
    _textNotifier.dispose();
    _cursorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = context.reduceMotion;
    final accent = context.accent.accent;
    final style = AppTextStyles.h2(context).copyWith(color: accent);

    if (reduceMotion) {
      return Semantics(
        label: widget.phrases.join(', '),
        child: Text(
          widget.phrases.join('\n'),
          style: style,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Semantics(
      label: widget.phrases.join(', '),
      child: ListenableBuilder(
        listenable: Listenable.merge([_textNotifier, _cursorNotifier]),
        builder: (context, _) {
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: _textNotifier.value),
                TextSpan(
                  text: _cursorNotifier.value ? '|' : ' ',
                  style: style.copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            ),
            style: style,
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}

/// Staggered letter reveal animation for hero name.
class StaggeredNameReveal extends StatefulWidget {
  const StaggeredNameReveal({
    required this.name,
    required this.accentColor,
    super.key,
  });

  final String name;
  final Color accentColor;

  @override
  State<StaggeredNameReveal> createState() => _StaggeredNameRevealState();
}

class _StaggeredNameRevealState extends State<StaggeredNameReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _letterAnimations;
  final List<String> _letters = [];

  @override
  void initState() {
    super.initState();
    _letters.addAll(widget.name.split(''));
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800 + (_letters.length * 100)),
    );

    _letterAnimations = List.generate(_letters.length, (index) {
      final start = index * 0.08;
      final end = start + 0.5;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOutBack),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) {
      return Text(
        widget.name,
        style: TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          color: widget.accentColor,
          letterSpacing: 2,
        ),
        textAlign: TextAlign.center,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_letters.length, (index) {
            final letter = _letters[index];
            final opacity = _letterAnimations[index].value;
            final translateY = 20 * (1 - _letterAnimations[index].value);
            
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, translateY),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Animated floating shapes for hero background.
class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return const SizedBox.shrink();

    final accent = context.accent.accent;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // Hexagon shape
            Positioned(
              top: 100 + sin(_controller.value * 2 * pi) * 30,
              right: 80 + cos(_controller.value * 2 * pi) * 20,
              child: Transform.rotate(
                angle: _controller.value * 2 * pi * 0.1,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accent.withValues(alpha: 0.15),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Circle shape
            Positioned(
              top: 200 + cos(_controller.value * 2 * pi) * 40,
              left: 60 + sin(_controller.value * 2 * pi) * 30,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Small square
            Positioned(
              bottom: 150 + sin(_controller.value * 2 * pi + 1) * 25,
              right: 120 + cos(_controller.value * 2 * pi + 1) * 20,
              child: Transform.rotate(
                angle: _controller.value * 2 * pi * 0.05,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: accent.withValues(alpha: 0.12),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}