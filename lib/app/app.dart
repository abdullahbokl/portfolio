import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/app/router.dart';
import 'package:portfolio/app/theme/app_theme.dart';
import 'package:portfolio/bloc/navigation/navigation_cubit.dart';
import 'package:portfolio/bloc/theme/theme_cubit.dart';
import 'package:portfolio/bloc/theme/theme_state.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) {
          final themeData = switch (mode) {
            AppThemeMode.dark => AppTheme.dark,
            AppThemeMode.uvGreen => AppTheme.uvGreen,
            AppThemeMode.uvViolet => AppTheme.uvViolet,
          };

          return MaterialApp(
            title: 'Abdullah Khaled Elbokl — Portfolio',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: const PortfolioRouter(),
          );
        },
      ),
    );
  }
}


