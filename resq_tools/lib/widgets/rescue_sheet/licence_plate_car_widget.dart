import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_car.dart';
import 'package:resq_tools/screens/resistance_screen.dart';

class LicencePlateCarWidget extends StatelessWidget {
  final LicencePlateCar licencePlateResultCar;
  final bool selected;
  final Function() onTap;

  const LicencePlateCarWidget({
    super.key,
    required this.licencePlateResultCar,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        child: ListTile(
          title: Text(
            '${licencePlateResultCar.make} ${licencePlateResultCar.model}',
          ),
          trailing: SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.calculate),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ResistanceScreen(
                          inputWeight: licencePlateResultCar.maxTotalWeight,
                        ),
                  ),
                );
              },
            ),
          ),
          selected: selected,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (licencePlateResultCar.initialRegistrationDate != null)
                Text(
                  DateFormat(
                    'dd.MM.yyyy',
                  ).format(licencePlateResultCar.initialRegistrationDate!),
                ),
              Text(
                licencePlateResultCar.powertrain.toLocalizedString(context) ??
                    '',
              ),
              Text('${licencePlateResultCar.maxTotalWeight} kg'),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
