import 'package:flutter/material.dart';
import 'package:resq_tools/models/common/bottom_sheet_item.dart';

class BottomSheetList extends StatelessWidget {
  final List<BottomSheetItem> items;

  const BottomSheetList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              items.map((item) {
                return ListTile(
                  leading: item.icon != null ? Icon(item.icon) : null,
                  selected: item.isSelected,
                  title: Text(item.title),
                  trailing: item.isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    item.onTap();
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
