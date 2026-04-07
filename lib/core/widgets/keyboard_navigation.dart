import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard navigation manager for the portfolio.
/// Provides keyboard shortcuts for navigation.
class KeyboardNavigation extends StatefulWidget {
  const KeyboardNavigation({
    required this.child,
    required this.scrollController,
    required this.sectionKeys,
    this.onToggleTerminal,
    this.onCloseOverlay,
    super.key,
  });

  final Widget child;
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;
  final VoidCallback? onToggleTerminal;
  final VoidCallback? onCloseOverlay;

  @override
  State<KeyboardNavigation> createState() => _KeyboardNavigationState();
}

class _KeyboardNavigationState extends State<KeyboardNavigation> {
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is! KeyDownEvent) return;

        // Number keys 1-6 for direct section navigation
        if (event.logicalKey == LogicalKeyboardKey.digit1 ||
            event.logicalKey == LogicalKeyboardKey.numpad1) {
          _scrollToSection(0);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit2 ||
            event.logicalKey == LogicalKeyboardKey.numpad2) {
          _scrollToSection(1);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit3 ||
            event.logicalKey == LogicalKeyboardKey.numpad3) {
          _scrollToSection(2);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit4 ||
            event.logicalKey == LogicalKeyboardKey.numpad4) {
          _scrollToSection(3);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit5 ||
            event.logicalKey == LogicalKeyboardKey.numpad5) {
          _scrollToSection(4);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.digit6 ||
            event.logicalKey == LogicalKeyboardKey.numpad6) {
          _scrollToSection(5);
          return;
        }

        // Arrow keys for navigation
        if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _handleArrowNavigation(event.logicalKey);
          return;
        }

        // Page navigation
        if (event.logicalKey == LogicalKeyboardKey.space) {
          _handleSpaceNavigation(event);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          _scrollRelative(-0.8);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          _scrollRelative(0.8);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.home) {
          _scrollToSection(0);
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.end) {
          _scrollToSection(widget.sectionKeys.length - 1);
          return;
        }

        // Terminal shortcuts
        if (event.logicalKey == LogicalKeyboardKey.backquote) {
          widget.onToggleTerminal?.call();
          return;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onCloseOverlay?.call();
          return;
        }
      },
      child: widget.child,
    );
  }

  void _scrollToSection(int index) {
    if (index < 0 || index >= widget.sectionKeys.length) return;
    final key = widget.sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
      setState(() {
        _currentSection = index;
      });
    }
  }

  void _handleArrowNavigation(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_currentSection < widget.sectionKeys.length - 1) {
        _scrollToSection(_currentSection + 1);
      } else {
        _scrollRelative(0.3);
      }
    } else if (key == LogicalKeyboardKey.arrowUp) {
      if (_currentSection > 0) {
        _scrollToSection(_currentSection - 1);
      } else {
        _scrollRelative(-0.3);
      }
    }
  }

  void _handleSpaceNavigation(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Check if shift is pressed
      if (HardwareKeyboard.instance.isShiftPressed) {
        _scrollRelative(-0.8);
      } else {
        _scrollRelative(0.8);
      }
    }
  }

  void _scrollRelative(double screenFraction) {
    if (!widget.scrollController.hasClients) return;
    final currentOffset = widget.scrollController.offset;
    final viewportHeight = widget.scrollController.position.viewportDimension;
    final targetOffset = currentOffset + (viewportHeight * screenFraction);
    final maxScroll = widget.scrollController.position.maxScrollExtent;

    widget.scrollController.animateTo(
      targetOffset.clamp(0, maxScroll),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }
}

/// Shows keyboard shortcuts help overlay.
class KeyboardShortcutsOverlay extends StatelessWidget {
  const KeyboardShortcutsOverlay({
    required this.isVisible,
    super.key,
  });

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.8),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Keyboard Shortcuts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ShortcutRow(keys: ['1', '2', '3', '4', '5', '6'], action: 'Go to section'),
                  _ShortcutRow(keys: ['↑', '↓'], action: 'Navigate sections'),
                  _ShortcutRow(keys: ['Space'], action: 'Scroll down'),
                  _ShortcutRow(keys: ['Shift', 'Space'], action: 'Scroll up'),
                  _ShortcutRow(keys: ['Page Up', 'Page Down'], action: 'Scroll page'),
                  _ShortcutRow(keys: ['Home', 'End'], action: 'Go to start/end'),
                  _ShortcutRow(keys: ['`'], action: 'Toggle terminal'),
                  _ShortcutRow(keys: ['Esc'], action: 'Close overlays'),
                  const SizedBox(height: 16),
                  const Text(
                    'Press any key to continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({
    required this.keys,
    required this.action,
  });

  final List<String> keys;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Wrap(
            spacing: 8,
            children: keys.map((key) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              action,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
