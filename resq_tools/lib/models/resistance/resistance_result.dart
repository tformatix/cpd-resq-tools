class ResistanceResult {
  final int angle;
  final double rollingResistance;
  final double gradientResistance;
  final double overallResistance;

  const ResistanceResult({
    required this.angle,
    required this.rollingResistance,
    required this.gradientResistance,
    required this.overallResistance,
  });
}
