import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.uvGreen);

  void toggleAccent() {
    switch (state) {
      case AppThemeMode.dark:
        emit(AppThemeMode.uvGreen);
      case AppThemeMode.uvGreen:
        emit(AppThemeMode.uvViolet);
      case AppThemeMode.uvViolet:
        emit(AppThemeMode.dark);
    }
  }

  void setMode(AppThemeMode mode) => emit(mode);
}

