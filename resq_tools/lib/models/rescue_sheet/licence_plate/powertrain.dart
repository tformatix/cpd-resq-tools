import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

enum Powertrain {
  cng('CNG', 'CNG', isPartialMatch: true),
  diesel('Diesel', 'Diesel'),
  electric('Elektro', 'Electric'),
  gasoline('Benzin', 'Gasoline'),
  hybrid('Hybr.', 'Hybrid', isPartialMatch: true),
  lng('LNG', 'LNG', isPartialMatch: true),
  undefined('', '');

  static const _pattern = r'(.*) &nbsp;.*';
  final String licencePlateIdentifier;
  final String euroRescueIdentifier;
  final bool isPartialMatch;

  const Powertrain(
    this.licencePlateIdentifier,
    this.euroRescueIdentifier, {
    this.isPartialMatch = false,
  });

  factory Powertrain.from(String? input) {
    if (input == null) return Powertrain.undefined;

    final regex = RegExp(_pattern);
    final parsedInput = regex.firstMatch(input)?.group(1);

    return Powertrain.values.firstWhereOrNull(
          (pt) =>
              pt.isPartialMatch
                  ? parsedInput?.contains(pt.licencePlateIdentifier) == true
                  : parsedInput == pt.licencePlateIdentifier,
        ) ??
        Powertrain.undefined;
  }

  String? toLocalizedString(BuildContext context) {
    return switch (this) {
      Powertrain.cng => context.l10n?.powertrain_cng,
      Powertrain.diesel => context.l10n?.powertrain_diesel,
      Powertrain.electric => context.l10n?.powertrain_electric,
      Powertrain.gasoline => context.l10n?.powertrain_gasoline,
      Powertrain.hybrid => context.l10n?.powertrain_hybrid,
      Powertrain.lng => context.l10n?.powertrain_lng,
      Powertrain.undefined => context.l10n?.powertrain_undefined,
    };
  }
}
