import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';

class MeasurementConfig {
  final VehicleType vehicleType;
  final int weight;
  final UndergroundType undergroundType;
  final double? angle;

  const MeasurementConfig({
    required this.vehicleType,
    required this.weight,
    required this.undergroundType,
    this.angle,
  });

  MeasurementConfig.empty()
    : vehicleType = VehicleType.car,
      weight = 0,
      undergroundType = UndergroundType.asphalt,
      angle = null;

  MeasurementConfig copyWith({
    VehicleType? vehicleType,
    int? weight,
    UndergroundType? undergroundType,
    double? angle,
  }) => MeasurementConfig(
    vehicleType: vehicleType ?? this.vehicleType,
    weight: weight ?? this.weight,
    undergroundType: undergroundType ?? this.undergroundType,
    angle: angle ?? this.angle,
  );
}
