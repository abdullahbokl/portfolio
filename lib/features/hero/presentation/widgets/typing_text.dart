import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Animated typing text that cycles through phrases with a blinking cursor.
class TypingText extends StatefulWidget {
  const TypingText({required this.phrases, super.key});

  final List<String> phrases;

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = '';
  bool _cursorVisible = true;
  int _phraseIndex = 0;
  bool _isDeleting = false;
  Timer? _typingTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        if (mounted) setState(() => _cursorVisible = !_cursorVisible);
      },
    );
    _startTyping();
  }

  void _startTyping() {
    final phrase = widget.phrases[_phraseIndex];

    if (_isDeleting) {
      if (_displayedText.isNotEmpty) {
        _typingTimer = Timer(const Duration(milliseconds: 30), () {
          if (!mounted) return;
          setState(() {
            _displayedText =
                _displayedText.substring(0, _displayedText.length - 1);
          });
          _startTyping();
        });
      } else {
        _isDeleting = false;
        _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
        _typingTimer = Timer(const Duration(milliseconds: 500), _startTyping);
      }
    } else {
      if (_displayedText.length < phrase.length) {
        _typingTimer = Timer(const Duration(milliseconds: 50), () {
          if (!mounted) return;
          setState(() {
            _displayedText = phrase.substring(0, _displayedText.length + 1);
          });
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
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: _displayedText),
            TextSpan(
              text: _cursorVisible ? '|' : ' ',
              style: style.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

