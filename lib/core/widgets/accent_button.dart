import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../extensions/context_extensions.dart';

/// Reusable CTA button with primary (filled) and secondary (outlined) variants.
class AccentButton extends StatefulWidget {
  const AccentButton({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  @override
  State<AccentButton> createState() => _AccentButtonState();
}

class _AccentButtonState extends State<AccentButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    if (widget.isPrimary) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Semantics(
          button: true,
          label: widget.label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: _hovered ? 0.4 : 0.2),
                  blurRadius: _hovered ? 24 : 16,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              child: _buildContent(AppColors.surfacePrimary),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        label: widget.label,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor:
                _hovered ? accent.withValues(alpha: 0.1) : Colors.transparent,
          ),
          child: _buildContent(accent),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(widget.label),
        ],
      );
    }
    return Text(widget.label);
  }
}

