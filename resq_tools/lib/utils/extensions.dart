import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

extension LocalizedThemeMode on ThemeMode {
  String localizedName(BuildContext context) {
    return switch (this) {
      ThemeMode.system => '${context.l10n?.settings_item_theme_system_default}',
      ThemeMode.light => '${context.l10n?.settings_item_theme_light}',
      ThemeMode.dark => '${context.l10n?.settings_item_theme_dark}',
    };
  }
}
