import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';

void main() {
  group('ResistanceRepository', () {
    test(
      'calculateResistance returns correct values for asphalt + 30° angle',
      () {
        // Arrange
        final repository = ResistanceRepository();
        final config = MeasurementConfig(
          vehicleType: VehicleType.car,
          weight: 1000,
          undergroundType: UndergroundType.asphalt,
          angle: 30,
        );

        // Act
        final result = repository.calculateResistance(config);

        // Assert
        final expectedRolling =
            config.weight * config.undergroundType.rollingResistanceCoefficient;
        final expectedGradient =
            config.weight * sin(config.angle! * (pi / 180.0));
        final expectedTotal = expectedRolling + expectedGradient;

        expect(result, isNotNull);
        expect(result!.rollingResistance, closeTo(expectedRolling, 0.001));
        expect(result.gradientResistance, closeTo(expectedGradient, 0.001));
        expect(result.overallResistance, closeTo(expectedTotal, 0.001));
      },
    );

    test('calculateResistance handles null config gracefully', () {
      final repository = ResistanceRepository();
      final result = repository.calculateResistance(null);
      expect(result, isNotNull);
      expect(result!.rollingResistance, 0.0);
      expect(result.gradientResistance, 0.0);
      expect(result.overallResistance, 0.0);
    });
  });
}
