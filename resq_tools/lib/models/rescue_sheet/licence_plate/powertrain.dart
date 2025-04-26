import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

enum Powertrain {
  cng('CNG'),
  diesel('Diesel'),
  electric('Elektro'),
  gasoline('Benzin'),
  hybrid('Hybr.'),
  lng('LNG');

  static const _pattern = r'(.*) &nbsp;.*';
  final String apiIdentifier;

  const Powertrain(this.apiIdentifier);

  static Powertrain? from(String? input) {
    if (input == null) return null;

    final regex = RegExp(_pattern);
    final parsedInput = regex.firstMatch(input)?.group(1);

    return Powertrain.values.firstWhereOrNull(
      (pt) => pt.apiIdentifier == parsedInput,
    );
  }

  String? toLocalizedString(BuildContext context) {
    return switch (this) {
      Powertrain.cng => context.l10n?.powertrain_cng,
      Powertrain.diesel => context.l10n?.powertrain_diesel,
      Powertrain.electric => context.l10n?.powertrain_electric,
      Powertrain.gasoline => context.l10n?.powertrain_gasoline,
      Powertrain.hybrid => context.l10n?.powertrain_hybrid,
      Powertrain.lng => context.l10n?.powertrain_lng,
    };
  }
}
