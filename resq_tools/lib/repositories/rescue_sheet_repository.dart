import 'dart:math';

import 'package:resq_tools/models/rescue_sheet/euro_rescue/body_type.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_car.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_document.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_car.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/powertrain.dart';

class RescueSheetRepository {
  Future<LicencePlateResult?> fetchLicencePlate(String licensePlate) async {
    //TODO: make network request
    return Future.delayed(
      Duration(milliseconds: Random().nextInt(2000)),
      () => LicencePlateResult(
        cars: [
          LicencePlateCar(
            powertrain: Powertrain.gasoline,
            make: 'BMW',
            model: '316i',
            type: 'E90',
            maxTotalWeight: 1350,
            initialRegistrationDate: DateTime(2011, 3, 14),
            vin: 'WVWZZZ1JZ3W386752',
            variant: 'DA0FCBB12',
            version: 'BK2G2JBDK5',
          ),
          LicencePlateCar(
            powertrain: Powertrain.gasoline,
            make: 'Opel',
            model: 'Astra',
            type: 'B-K',
            maxTotalWeight: 1930,
            initialRegistrationDate: DateTime(2018, 4, 4),
            vin: 'W0VBXXEK5J8012345',
            variant: 'DA0FCBB12',
            version: 'BK2G2JBDK5',
          ),
        ],
      ),
    );
  }

  Future<LicencePlateResult?> fetchEuroRescue(
    LicencePlateResult licencePlateResult,
  ) async {
    //TODO: make network request
    return Future.delayed(Duration(milliseconds: Random().nextInt(2000)), () {
      licencePlateResult.cars.first.setEuroRescueResult(
        EuroRescueResult(
          cars: [
            EuroRescueCar(
              name: 'BMW 316i',
              makeId: 'BMW',
              makeName: 'BMW',
              modelId: '316i',
              modelName: '316i',
              bodyType: BodyType.sedan,
              buildYearFrom: 2007,
              buildYearUntil: 2011,
              doors: '5',
              powertrain: 'Gasoline',
              documents: [
                EuroRescueResultDocument(
                  language: 'EN',
                  type: 'Rescue Sheet',
                  url:
                      'https://api.rescue.euroncap.com/euro-rescue/rescue-documents/en/BMW_3_Series__Sedan_2005_4d_GD_EN.pdf',
                ),
                EuroRescueResultDocument(
                  language: 'DE',
                  type: 'Rescue Sheet',
                  url:
                      'https://api.rescue.euroncap.com/euro-rescue/rescue-documents/de/BMW_3_Series__Sedan_2005_4d_GD_DE.pdf',
                ),
              ],
              pictureUrl:
                  'https://api.rescue.euroncap.com/euro-rescue/rescue-pictures/variants/BMW_3_Series__Sedan_2005_4d_GD.PNG',
            ),
          ],
        ),
      );

      return licencePlateResult;
    });
  }
}
