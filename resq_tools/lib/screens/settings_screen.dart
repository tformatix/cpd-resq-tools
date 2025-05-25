import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/settings_cubit.dart';
import 'package:resq_tools/models/common/bottom_sheet_item.dart';
import 'package:resq_tools/models/settings/settings_item.dart';
import 'package:resq_tools/screens/onboarding_screen.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/bottom_sheet_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${context.l10n?.settings_title}')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return _getSettingsWidget(context, state);
        },
      ),
    );
  }

  Widget _getSettingsWidget(BuildContext context, SettingsState state) {
    final settingsItems = <SettingsItem>[
      SettingsItem(
        title: '${context.l10n?.settings_item_language}',
        subtitle:
            state.languageLocale?.localizedName(context) ??
            '${context.l10n?.settings_item_label_system_default}',
        icon: Icons.language,
        onTap: () => _showLanguageBottomSheet(context, state),
      ),
      SettingsItem(
        title: '${context.l10n?.settings_item_theme}',
        subtitle: state.themeMode.localizedName(context),
        icon: _getThemeIcon(state.themeMode),
        onTap: () => _showThemeBottomSheet(context, state),
      ),
      SettingsItem(
        title: '${context.l10n?.settings_item_change_token}',
        subtitle: '${context.l10n?.settings_item_change_token_subtitle}',
        icon: Icons.key,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: ListView.builder(
        itemCount: settingsItems.length,
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return Card(
            child: ListTile(
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.subtitle),
              leading: Icon(item.icon),
              onTap: item.onTap,
            ),
          );
        },
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context, SettingsState state) {
    final items = <ThemeMode, (String title, IconData icon)>{
      ThemeMode.system: (
        '${context.l10n?.settings_item_label_system_default}',
        _getThemeIcon(ThemeMode.system),
      ),
      ThemeMode.light: (
        '${context.l10n?.settings_item_theme_light}',
        _getThemeIcon(ThemeMode.light),
      ),
      ThemeMode.dark: (
        '${context.l10n?.settings_item_theme_dark}',
        _getThemeIcon(ThemeMode.dark),
      ),
    };

    final currentThemeMode = state.themeMode;
    final bottomSheetItems =
        items.entries.map((entry) {
          final theme = entry.key;
          final (label, icon) = entry.value;

          return BottomSheetItem(
            title: label,
            icon: icon,
            isSelected: currentThemeMode == theme,
            onTap: () {
              context.read<SettingsCubit>().setThemeMode(theme);
              Navigator.pop(context);
            },
          );
        }).toList();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return BottomSheetList(items: bottomSheetItems);
      },
    );
  }

  IconData _getThemeIcon(ThemeMode mode) => switch (mode) {
    ThemeMode.system => Icons.brightness_auto,
    ThemeMode.light => Icons.light_mode,
    ThemeMode.dark => Icons.dark_mode,
  };

  void _showLanguageBottomSheet(BuildContext context, SettingsState state) {
    final items = <Locale>{
      const Locale('de'),
      const Locale('en'),
    };

    final currentLocale = state.languageLocale;
    final bottomSheetItems =
        items.map((locale) {
          return BottomSheetItem(
            title: locale.localizedName(context),
            isSelected: currentLocale?.languageCode == locale.languageCode,
            onTap: () {
              context.read<SettingsCubit>().setLanguage(locale);
              Navigator.pop(context);
            },
          );
        }).toList();

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return BottomSheetList(items: bottomSheetItems);
      },
    );
  }
}
