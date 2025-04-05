import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

enum Powertrain {
  cng,
  diesel,
  electric,
  gasoline,
  hybrid,
  hydrogen,
  lng,
  unknown;

  String? toLocalizedString(BuildContext context) {
    return switch (this) {
      Powertrain.cng => context.l10n?.powertrain_cng,
      Powertrain.diesel => context.l10n?.powertrain_diesel,
      Powertrain.electric => context.l10n?.powertrain_electric,
      Powertrain.gasoline => context.l10n?.powertrain_gasoline,
      Powertrain.hybrid => context.l10n?.powertrain_hybrid,
      Powertrain.hydrogen => context.l10n?.powertrain_hydrogen,
      Powertrain.lng => context.l10n?.powertrain_lng,
      Powertrain.unknown => context.l10n?.powertrain_unknown,
    };
  }
}
