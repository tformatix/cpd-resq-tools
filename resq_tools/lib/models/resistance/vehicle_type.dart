import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum VehicleType {
  car(15),
  suv(17),
  offroadCar(25),
  truckTwoAxis(180),
  truckThreeAxis(260),
  truckFourAxis(320),
  custom(0);

  final int weight;
  const VehicleType(this.weight);

  String? getTranslation(AppLocalizations? appLocalizations) => switch (this) {
    car => appLocalizations?.resistance_vehicle_type_car,
    suv => appLocalizations?.resistance_vehicle_type_suv,
    offroadCar => appLocalizations?.resistance_vehicle_type_offroad_car,
    truckTwoAxis => appLocalizations?.resistance_vehicle_type_truck_two_axis,
    truckThreeAxis =>
      appLocalizations?.resistance_vehicle_type_truck_three_axis,
    truckFourAxis => appLocalizations?.resistance_vehicle_type_truck_four_axis,
    custom => appLocalizations?.resistance_vehicle_type_custom,
  };
}
