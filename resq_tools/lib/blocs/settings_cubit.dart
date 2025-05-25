import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/settings_repository.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale? languageLocale;

  const SettingsState({required this.themeMode, required this.languageLocale});

  SettingsState copyWith({ThemeMode? themeMode, Locale? languageLocale}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageLocale: languageLocale ?? this.languageLocale,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository)
    : super(
        const SettingsState(themeMode: ThemeMode.system, languageLocale: null),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedState = await repository.loadSettings();
    emit(savedState);
  }

  void setThemeMode(ThemeMode mode) {
    final newState = state.copyWith(themeMode: mode);
    repository.saveTheme(newState);
    emit(newState);
  }

  void setLanguage(Locale locale) {
    final newState = state.copyWith(languageLocale: locale);
    repository.saveLanguage(newState);
    emit(newState);
  }
}
