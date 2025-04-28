import 'package:flutter/material.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_car.dart';
import 'package:resq_tools/utils/extensions.dart';

class EuroRescueCarWidget extends StatelessWidget {
  final EuroRescueCar euroRescueCar;
  final Function() onTap;

  const EuroRescueCarWidget({
    super.key,
    required this.euroRescueCar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        child: ListTile(
          title: Text('${euroRescueCar.makeName} ${euroRescueCar.modelName}'),
          trailing: Icon(Icons.arrow_forward_ios),
          leading: SizedBox(
            width: 100,
            height: 50,
            child:
                euroRescueCar.pictureUrl != null
                    ? Image.network(
                      euroRescueCar.pictureUrl!,
                      fit: BoxFit.cover,
                    )
                    : const Icon(Icons.image_not_supported, size: 50),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${euroRescueCar.buildYearFrom} - '
                '${euroRescueCar.buildYearUntil ?? ''}',
              ),
              Text(
                '${euroRescueCar.bodyType.toLocalizedString(context)} - '
                '${euroRescueCar.doors} '
                '${context.l10n?.rescue_sheet_doors ?? ''}',
              ),
              Text(euroRescueCar.powertrain),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
