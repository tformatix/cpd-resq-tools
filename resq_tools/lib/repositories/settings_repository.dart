import 'package:flutter/material.dart';
import 'package:resq_tools/blocs/settings_cubit.dart';
import 'package:resq_tools/constants/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

const languageSystemDefault = 'system';

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

    final languageLocaleString =
        sharedPrefs.getString(SharedPrefsKeys.language) ??
        languageSystemDefault;
    var languageLocale =
        languageLocaleString == languageSystemDefault
            ? null
            : Locale.fromSubtags(languageCode: languageLocaleString);

    return SettingsState(themeMode: theme, languageLocale: languageLocale);
  }

  Future<void> saveTheme(SettingsState state) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
      SharedPrefsKeys.themeMode,
      state.themeMode.name,
    );
  }

  Future<void> saveLanguage(SettingsState state) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
      SharedPrefsKeys.language,
      state.languageLocale?.languageCode ?? languageSystemDefault,
    );
  }
}
