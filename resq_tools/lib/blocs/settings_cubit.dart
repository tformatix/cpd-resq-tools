import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/settings_repository.dart';

class SettingsState {
  final ThemeMode themeMode;

  const SettingsState({required this.themeMode});

  SettingsState copyWith({ThemeMode? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository repository;

  SettingsCubit(this.repository)
    : super(const SettingsState(themeMode: ThemeMode.system)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedState = await repository.loadSettings();
    emit(savedState);
  }

  void setThemeMode(ThemeMode mode) {
    final newState = state.copyWith(themeMode: mode);
    repository.saveSettings(newState);
    emit(newState);
  }
}
