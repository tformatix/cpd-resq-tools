import 'package:resq_tools/models/rescue_sheet/euro_rescue/body_type.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_document.dart';

class EuroRescueCar {
  final String name;
  final String makeId;
  final String makeName;
  final String modelId;
  final String modelName;
  final BodyType bodyType;
  final int buildYearFrom;
  final int? buildYearUntil;
  final String doors;
  final String powertrain;
  final List<EuroRescueResultDocument> documents;
  final String? pictureUrl;

  EuroRescueCar({
    required this.buildYearUntil,
    required this.name,
    required this.makeId,
    required this.makeName,
    required this.modelId,
    required this.modelName,
    required this.bodyType,
    required this.buildYearFrom,
    required this.doors,
    required this.powertrain,
    required this.documents,
    required this.pictureUrl,
  });

  factory EuroRescueCar.fromJson(Map<String, dynamic> json) => EuroRescueCar(
    name: json['name'],
    makeId: json['make_id'],
    makeName: json['make_name'],
    modelId: json['model_id'],
    modelName: json['model_name'],
    bodyType: BodyType.from(json['body_type']),
    buildYearFrom: int.parse(json['build_year_from']),
    buildYearUntil: int.tryParse(json['build_year_until'] ?? ''),
    doors: json['doors'],
    powertrain: json['powertrain'],
    documents:
        (json['documents'] as List)
            .map((doc) => EuroRescueResultDocument.fromJson(doc))
            .toList(),
    pictureUrl: json['picture_url'],
  );
}
