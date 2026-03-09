import 'package:flutter/material.dart';

/// A grid that ensures all items in the same row have equal height.
/// Uses [IntrinsicHeight] + [Row] per visual row so cards stretch
/// to match the tallest sibling in their row.
class EqualHeightGrid extends StatelessWidget {
  const EqualHeightGrid({
    required this.columns,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    super.key,
  });

  final int columns;
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final rows = <List<Widget>>[];

    for (int i = 0; i < children.length; i += columns) {
      final end =
          (i + columns > children.length) ? children.length : i + columns;
      rows.add(children.sublist(i, end));
    }

    return Column(
      children: [
        for (int r = 0; r < rows.length; r++) ...[
          if (r > 0) SizedBox(height: runSpacing),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int c = 0; c < rows[r].length; c++) ...[
                  if (c > 0) SizedBox(width: spacing),
                  Expanded(child: rows[r][c]),
                ],
                // Fill remaining columns in the last row with empty Expanded
                // to maintain consistent card widths
                for (int c = rows[r].length; c < columns; c++) ...[
                  SizedBox(width: spacing),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

