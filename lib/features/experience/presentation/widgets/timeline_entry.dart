import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../domain/experience_model.dart';
import 'timeline_card.dart';
import 'timeline_dot.dart';

class TimelineEntry extends StatefulWidget {
  const TimelineEntry({
    required this.experience,
    required this.isLast,
    super.key,
  });

  final ExperienceModel experience;
  final bool isLast;

  @override
  State<TimelineEntry> createState() => _TimelineEntryState();
}

class _TimelineEntryState extends State<TimelineEntry> {
  final _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;
    final isMobile = context.isMobile;
    final exp = widget.experience;

    return MouseRegion(
      onEnter: (_) => _hovered.value = true,
      onExit: (_) => _hovered.value = false,
      child: RepaintBoundary(
        child: ValueListenableBuilder<bool>(
          valueListenable: _hovered,
          builder: (context, hovered, _) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline rail
                  SizedBox(
                    width: isMobile ? 40 : 56,
                    child: TimelineDot(
                      isHovered: hovered,
                      isLeadership: exp.isLeadership,
                      accent: accent,
                      isLast: widget.isLast,
                    ),
                  ),
                  // Content card
                  Expanded(
                    child: TimelineCard(
                      experience: exp,
                      isHovered: hovered,
                      accent: accent,
                      isMobile: isMobile,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
