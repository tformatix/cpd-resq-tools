import 'dart:math';

import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';

class ResistanceRepository {
  ResistanceResult? calculateResistance(MeasurementConfig? measurementConfig) {
    final weight = measurementConfig?.weight ?? 0.0;
    final rollingResistanceCoefficient =
        measurementConfig?.undergroundType.rollingResistanceCoefficient ?? 0.0;
    final angle = measurementConfig?.angle ?? 0.0;
    final angleInRad = angle * (pi / 180.0);

    final rollingResistance = rollingResistanceCoefficient * weight;
    final gradientResistance = weight * sin(angleInRad);

    return ResistanceResult(
      rollingResistance: rollingResistance,
      gradientResistance: gradientResistance,
      overallResistance: rollingResistance + gradientResistance,
    );
  }
}
