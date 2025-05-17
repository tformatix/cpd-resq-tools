import 'package:flutter/material.dart';

class SettingsItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
