import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'package:http/http.dart' as http;
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_car.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_car.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';

class EuroRescueRepository {
  static const String _variantsUrl =
      'https://api.rescue.euroncap.com/euro-rescue/variants';
  static const int _fuzzySearchThreshold = 90;
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };
  static const String _query =
      'SELECT * FROM c WHERE UPPER(c.make_name) LIKE @make_name'
      ' AND c.powertrain LIKE @powertrain';

  Future<void> fetchEuroRescue(LicencePlateResult licencePlateResult) async {
    for (final licencePlateCar in licencePlateResult.cars) {
      try {
        final euroRescueResult = await _fetchRescueVariants(licencePlateCar);

        final filteredCars = _filterByRegistrationYear(
          euroRescueResult.cars,
          licencePlateCar.initialRegistrationDate?.year,
        );

        final bestMatches = _filterByModelName(
          filteredCars,
          licencePlateCar.model,
        );

        licencePlateCar.euroRescueResult = EuroRescueResult(cars: bestMatches);
      } on Exception catch (_) {
        licencePlateCar.euroRescueResult = EuroRescueResult(cars: []);
      }
    }
  }

  Future<EuroRescueResult> _fetchRescueVariants(
    LicencePlateCar licencePlateCar,
  ) async {
    final makeName = licencePlateCar.make?.toUpperCase() ?? '';
    final powertrainIdentifier =
        licencePlateCar.powertrain.euroRescueIdentifier;

    final requestBody = jsonEncode({
      'query': _query,
      'parameters': [
        {'name': '@make_name', 'value': makeName},
        {'name': '@powertrain', 'value': '%$powertrainIdentifier%'},
      ],
    });

    final response = await http.post(
      Uri.parse(_variantsUrl),
      headers: _headers,
      body: requestBody,
    );

    return EuroRescueResult.fromJson(jsonDecode(response.body));
  }

  List<EuroRescueCar> _filterByRegistrationYear(
    List<EuroRescueCar> cars,
    int? registrationYear,
  ) {
    if (registrationYear == null) return cars;

    return cars.where((car) {
      final from = car.buildYearFrom;
      final until = car.buildYearUntil;

      if (until == null) return from <= registrationYear;
      return registrationYear >= from && registrationYear <= until;
    }).toList();
  }

  List<EuroRescueCar> _filterByModelName(
    List<EuroRescueCar> cars,
    String? licencePlateModel,
  ) {
    if (licencePlateModel == null || cars.isEmpty) return cars;

    final normalizedLicencePlateModel = _normalize(licencePlateModel);

    return cars.where((car) {
      final normalizedEuroRescueModel = _normalize(car.modelName);

      final partialRatio = fuzzy.partialRatio(
        normalizedEuroRescueModel,
        normalizedLicencePlateModel,
      );
      final tokenSetRatio = fuzzy.tokenSetRatio(
        normalizedEuroRescueModel,
        normalizedLicencePlateModel,
      );

      return partialRatio >= _fuzzySearchThreshold ||
          tokenSetRatio >= _fuzzySearchThreshold;
    }).toList();
  }

  String _normalize(String input) {
    return removeDiacritics(input.toUpperCase());
  }
}
