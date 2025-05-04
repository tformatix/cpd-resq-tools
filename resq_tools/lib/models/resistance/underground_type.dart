import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UndergroundType {
  asphalt(1.0 / 25.0),
  grass(1.0 / 7.0),
  gravel(1.0 / 5.0),
  looseGround(1.0 / 4.0),
  upToAxleInMud(1.0),
  upToWheelsInMud(2.0),
  upToBodyInMud(3.0),
  rail(0.003);

  final double rollingResistanceCoefficient;
  const UndergroundType(this.rollingResistanceCoefficient);

  String? getTranslation(AppLocalizations? appLocalizations) => switch (this) {
    asphalt => appLocalizations?.resistance_underground_type_asphalt,
    grass => appLocalizations?.resistance_underground_type_grass,
    gravel => appLocalizations?.resistance_underground_type_gravel,
    looseGround => appLocalizations?.resistance_underground_type_looseGround,
    upToAxleInMud =>
      appLocalizations?.resistance_underground_type_up_to_axle_in_mud,
    upToWheelsInMud =>
      appLocalizations?.resistance_underground_type_up_to_wheels_in_mud,
    upToBodyInMud =>
      appLocalizations?.resistance_underground_type_up_to_body_in_mud,
    rail => appLocalizations?.resistance_underground_type_rail,
  };
}
