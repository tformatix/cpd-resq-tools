class SubstanceResult {
  final String zvgNumber;
  final String rank;
  final String casNumber;
  final String name;
  Uri? detailUrl;

  SubstanceResult({
    required this.zvgNumber,
    required this.rank,
    required this.casNumber,
    required this.name,
  });

  factory SubstanceResult.fromJson(Map<String, dynamic> json) =>
      SubstanceResult(
        zvgNumber: json['zvg_nr'] ?? '',
        rank: json['rank'] ?? '',
        casNumber: json['cas_nr'] ?? '',
        name: json['name'] ?? '',
      );
}
