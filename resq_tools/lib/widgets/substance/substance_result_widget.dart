import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

class SubstanceResultWidget extends StatelessWidget {
  final String casNumber;
  final String name;
  final Function() onTap;

  const SubstanceResultWidget({
    super.key,
    required this.casNumber,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Icon(Icons.open_in_browser),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('${context.l10n?.substance_cas_number}: $casNumber')],
      ),
      onTap: onTap,
    ),
  );
}