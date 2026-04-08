import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/theme/theme_state.dart';
import '../../core/extensions/context_extensions.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.accent.accent;

    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, mode) {
        final icon = switch (mode) {
          AppThemeMode.dark => Icons.dark_mode_outlined,
          AppThemeMode.uvGreen => Icons.bolt,
          AppThemeMode.uvViolet => Icons.auto_awesome,
        };
        final tooltip = switch (mode) {
          AppThemeMode.dark => 'Dark Mode',
          AppThemeMode.uvGreen => 'UV Green',
          AppThemeMode.uvViolet => 'UV Violet',
        };
        return Semantics(
          button: true,
          label: 'Toggle theme: $tooltip',
          child: IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleAccent(),
            icon: Icon(icon, color: accent),
            tooltip: tooltip,
          ),
        );
      },
    );
  }
}
