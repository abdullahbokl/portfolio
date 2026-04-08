import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_text_styles.dart';

class LinkButton extends StatefulWidget {
  const LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.accent,
    super.key,
  });

  final String label;
  final IconData icon;
  final String url;
  final Color accent;

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        button: true,
        label: '${widget.label} link',
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _hovered ? widget.accent.withValues(alpha: 0.15) : Colors.transparent,
              border: Border.all(
                color: _hovered ? widget.accent : widget.accent.withValues(alpha: 0.4),
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.accent.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            transform: Matrix4.identity()..translate(_hovered ? -1.0 : 0.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: widget.accent),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: AppTextStyles.caption(context).copyWith(
                    color: widget.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}