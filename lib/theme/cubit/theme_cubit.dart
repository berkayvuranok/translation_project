import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/repository/settings_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SettingsRepository _settingsRepository;

  ThemeCubit(this._settingsRepository) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() async {
    final themeMode = await _settingsRepository.loadTheme();
    emit(themeMode);
  }

  void setTheme(ThemeMode themeMode) {
    _settingsRepository.saveTheme(themeMode);
    emit(themeMode);
  }
}
