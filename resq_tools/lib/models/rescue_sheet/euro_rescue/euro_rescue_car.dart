import 'package:resq_tools/models/rescue_sheet/euro_rescue/body_type.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_document.dart';

class EuroRescueCar {
  String name;
  String makeId;
  String makeName;
  String modelId;
  String modelName;
  BodyType bodyType;
  int buildYearFrom;
  int? buildYearUntil;
  String doors;
  String powertrain;
  List<EuroRescueResultDocument> documents;
  String pictureUrl;

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
}
