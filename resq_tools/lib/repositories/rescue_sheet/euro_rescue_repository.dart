import 'dart:math';

import 'package:resq_tools/models/rescue_sheet/euro_rescue/body_type.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_car.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_document.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';

class EuroRescueRepository {
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
