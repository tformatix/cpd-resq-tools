import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum UndergroundType {
  aphalt,
  grass,
  gravel,
  looseGround,
  upToAxleInMud,
  upToWheelsInMud,
  upToBodyInMud,
  rail;

  const UndergroundType();

  String? getTranslation(AppLocalizations? appLocalizations) => switch (this) {
        aphalt => appLocalizations?.resistance_underground_type_asphalt,
        grass => appLocalizations?.resistance_underground_type_grass,
        gravel => appLocalizations?.resistance_underground_type_gravel,
        looseGround =>
          appLocalizations?.resistance_underground_type_looseGround,
        upToAxleInMud =>
          appLocalizations?.resistance_underground_type_up_to_axle_in_mud,
        upToWheelsInMud =>
          appLocalizations?.resistance_underground_type_up_to_wheels_in_mud,
        upToBodyInMud =>
          appLocalizations?.resistance_underground_type_up_to_body_in_mud,
        rail => appLocalizations?.resistance_underground_type_rail
      };
}
