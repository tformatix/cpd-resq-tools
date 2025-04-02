import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';

class MeasurementConfig {
  final VehicleType vehicleType;
  final int weight;
  final UndergroundType undergroundType;

  const MeasurementConfig(
      {required this.vehicleType,
      required this.weight,
      required this.undergroundType});

  MeasurementConfig.empty()
      : vehicleType = VehicleType.car,
        weight = 0,
        undergroundType = UndergroundType.aphalt;

  MeasurementConfig copyWith({
    VehicleType? vehicleType,
    int? weight,
    UndergroundType? undergroundType,
  }) =>
      MeasurementConfig(
        vehicleType: vehicleType ?? this.vehicleType,
        weight: weight ?? this.weight,
        undergroundType: undergroundType ?? this.undergroundType,
      );
}
