import 'package:flutter_test/flutter_test.dart';
import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';

void main() {
  // TODO #9: Add real test cases once the full implementation is done
  group('ResistanceRepository', () {
    test('calculateResistance', () {
      final repository = ResistanceRepository();
      final config = MeasurementConfig(
        vehicleType: VehicleType.car,
        weight: 75,
        undergroundType: UndergroundType.aphalt,
      );
      final result = repository.calculateResistance(config);
      expect(result?.angle, inClosedOpenRange(0, 50));
      expect(result?.rollingResistance, inClosedOpenRange(0, 100));
      expect(result?.gradientResistance, inClosedOpenRange(0, 100));
      expect(result?.overallResistance, inClosedOpenRange(0, 2000));
    });
  });
}
