import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/powertrain.dart';

class LicencePlateCar {
  final Powertrain powertrain;
  final String make;
  final String model;
  final String type;
  final int maxTotalWeight;
  final DateTime initialRegistrationDate;
  final String vin;
  final String variant;
  final String version;

  EuroRescueResult? euroRescueResult;

  LicencePlateCar({
    required this.powertrain,
    required this.make,
    required this.model,
    required this.type,
    required this.maxTotalWeight,
    required this.initialRegistrationDate,
    required this.vin,
    required this.variant,
    required this.version,
    this.euroRescueResult,
  });

  void setEuroRescueResult(EuroRescueResult euroRescueResult) {
    this.euroRescueResult = euroRescueResult;
  }
}
