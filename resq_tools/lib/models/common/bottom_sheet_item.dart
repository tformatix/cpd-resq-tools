import 'package:flutter/material.dart';

class BottomSheetItem {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  BottomSheetItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
}
