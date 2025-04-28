import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

enum BodyType {
  cabrio('Cabrio'),
  coupe('Coupé'),
  hatchback('Hatchback'),
  mpv('MPV'),
  roadster('Roadster'),
  pickUp('Pick-up'),
  sedan('Sedan'),
  stationwagon('Stationwagon'),
  suv('SUV'),
  van('Van'),
  undefined('');

  final String euroRescueIdentifier;

  const BodyType(this.euroRescueIdentifier);

  String? toLocalizedString(BuildContext context) {
    return switch (this) {
      cabrio => context.l10n?.body_type_cabrio,
      coupe => context.l10n?.body_type_coupe,
      hatchback => context.l10n?.body_type_hatchback,
      mpv => context.l10n?.body_type_mpv,
      roadster => context.l10n?.body_type_roadster,
      pickUp => context.l10n?.body_type_pickUp,
      sedan => context.l10n?.body_type_sedan,
      stationwagon => context.l10n?.body_type_stationwagon,
      suv => context.l10n?.body_type_suv,
      van => context.l10n?.body_type_van,
      undefined => context.l10n?.body_type_undefined,
    };
  }

  factory BodyType.from(String? input) {
    return BodyType.values.firstWhereOrNull(
          (pt) => pt.euroRescueIdentifier == input,
        ) ??
        BodyType.undefined;
  }
}
