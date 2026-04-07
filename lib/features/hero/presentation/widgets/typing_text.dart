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

    // Combined builder to avoid nested rebuilds
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
