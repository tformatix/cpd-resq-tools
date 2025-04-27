import 'dart:math';

import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';

class ResistanceRepository {
  ResistanceResult? calculateResistance(MeasurementConfig? measurementConfig) =>
      ResistanceResult(
          angle: measurementConfig?.angle ?? 0.0,
          rollingResistance: Random().nextDouble() * 100,
          gradientResistance: Random().nextDouble() * 100,
          overallResistance: Random().nextDouble() * 2000);
}
