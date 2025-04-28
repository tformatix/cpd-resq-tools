import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_car.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/powertrain.dart';

class LicencePlateResult {
  static const _pattern = r'<td>(.*?)</td>\s*<td>(?:<h3>)?(.*?)(?:</h3>)?</td>';

  final List<LicencePlateCar> cars;

  const LicencePlateResult({required this.cars});

  factory LicencePlateResult.fromHtml(String html) {
    if (html.isEmpty) return LicencePlateResult(cars: []);

    final parsedCarValues = _extractKeyValuePairs(html);
    if (parsedCarValues.isEmpty) return LicencePlateResult(cars: []);

    final cars =
        parsedCarValues.map((values) {
          return LicencePlateCar(
            powertrain: Powertrain.from(values['Antrieb']),
            make: values['Marke'],
            model: values['Name'],
            type: values['Type'],
            maxTotalWeight: _parseInt(values['Höchstzul. Masse']),
            initialRegistrationDate: _parseDate(values['Erstzulassung']),
            vin: values['FIN'],
            variant: values['Variante'],
            version: values['Version'],
          );
        }).toList();

    return LicencePlateResult(cars: cars);
  }

  static List<Map<String, String>> _extractKeyValuePairs(String html) {
    final regex = RegExp(_pattern);
    final matches = regex.allMatches(html);
    final List<Map<String, String>> cars = [];
    var currentCar = <String, String>{};

    for (final match in matches) {
      final key = match.group(1)?.trim();
      final value = match.group(2)?.trim();

      if (key == null || value == null) continue;

      if (currentCar.containsKey(key)) {
        cars.add(currentCar);
        currentCar = {};
      }

      currentCar[key] = value;
    }

    if (currentCar.isNotEmpty) {
      cars.add(currentCar);
    }

    return cars;
  }

  static int? _parseInt(String? value) =>
      value != null ? int.tryParse(value) : null;

  static DateTime? _parseDate(String? value) =>
      value != null ? DateTime.tryParse(value) : null;
}
