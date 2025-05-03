import 'dart:math';

import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';

class ResistanceRepository {
  ResistanceResult? calculateResistance(MeasurementConfig? measurementConfig) {
    final rollingResistance =
        (measurementConfig?.undergroundType.rollingResistanceCoefficient ??
            0.0) *
        (measurementConfig?.weight ?? 0.0);
    final gradientResistance =
        (measurementConfig?.weight ?? 0.0) *
        sin(measurementConfig?.angle ?? 0.0 * pi / 180.0);

    return ResistanceResult(
      rollingResistance: rollingResistance,
      gradientResistance: gradientResistance,
      overallResistance: rollingResistance + gradientResistance,
    );
  }
}
