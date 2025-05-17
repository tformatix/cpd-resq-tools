import 'package:flutter/material.dart';
import 'package:resq_tools/blocs/settings_cubit.dart';
import 'package:resq_tools/constants/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  Future<SettingsState> loadSettings() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final savedThemeString =
        sharedPrefs.getString(SharedPrefsKeys.themeMode) ??
        ThemeMode.system.name;
    final theme = ThemeMode.values.firstWhere(
      (theme) => savedThemeString == theme.name,
      orElse: () => ThemeMode.system,
    );

    return SettingsState(themeMode: theme);
  }

  Future<void> saveSettings(SettingsState state) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
      SharedPrefsKeys.themeMode,
      state.themeMode.name,
    );
  }
}
