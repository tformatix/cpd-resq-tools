import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_car.dart';

class EuroRescueResult {
  final List<EuroRescueCar> cars;

  const EuroRescueResult({required this.cars});

  factory EuroRescueResult.fromJson(Map<String, dynamic> json) {
    return EuroRescueResult(
      cars:
          (json['Documents'] as List)
              .map((car) => EuroRescueCar.fromJson(car))
              .toList(),
    );
  }
}
