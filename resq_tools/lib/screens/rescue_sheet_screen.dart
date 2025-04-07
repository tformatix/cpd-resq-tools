import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/rescue_sheet_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/rescue_sheet/euro_rescue_car_widget.dart';
import 'package:resq_tools/widgets/rescue_sheet/licence_plate_car_widget.dart';
import 'package:resq_tools/widgets/text_field_camera_search.dart';

class RescueSheetScreen extends StatefulWidget {
  const RescueSheetScreen({super.key});

  @override
  State<RescueSheetScreen> createState() => _RescueSheetScreenState();
}

class _RescueSheetScreenState extends State<RescueSheetScreen> {
  int selectedLicencePlateCarIdx = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n?.rescue_sheet_title ?? '')),
    body: BlocBuilder<RescueSheetCubit, RescueSheetState>(
      builder: (context, state) {
        return _getRescueSheetWidget(context, state);
      },
    ),
  );

  Widget _getRescueSheetWidget(BuildContext context, RescueSheetState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: ListView(
        children: [
          TextFieldCameraSearch(
            labelText: context.l10n?.rescue_sheet_textfield_label,
            isLoading: state.isLoading,
            onSearchClicked:
                (String text) =>
                    context.read<RescueSheetCubit>().fetchRescueSheet(text),
          ),
          if (!state.isInitialState && !state.isLoading)
            _showResults(context, state),
        ],
      ),
    );
  }

  Widget _showResults(BuildContext context, RescueSheetState state) {
    if (state.licencePlateResult == null) {
      return Text(
        context.l10n?.rescue_sheet_empty_licence_plate_result ?? '',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Divider(),
        ),
        Text(
          context.l10n?.rescue_sheet_licence_plate_result ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        _showLicencePlateResult(context, state),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Divider(),
        ),
        Text(
          context.l10n?.rescue_sheet_euro_rescue_result ?? '',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        _showEuroRescueResult(context, state),
      ],
    );
  }

  Widget _showLicencePlateResult(BuildContext context, RescueSheetState state) {
    final result = state.licencePlateResult;

    return Column(
      children: List.generate(result?.cars.length ?? 0, (idx) {
        final car = result?.cars.elementAtOrNull(idx);
        return car != null
            ? LicencePlateCarWidget(
              licencePlateResultCar: car,
              selected: idx == selectedLicencePlateCarIdx,
              onTap:
                  () => setState(() {
                    selectedLicencePlateCarIdx = idx;
                  }),
            )
            : SizedBox.shrink();
      }),
    );
  }

  Widget _showEuroRescueResult(BuildContext context, RescueSheetState state) {
    final licencePlateResult = state.licencePlateResult?.cars.elementAtOrNull(
      selectedLicencePlateCarIdx,
    );

    if (licencePlateResult?.euroRescueResult == null) {
      return Text(
        context.l10n?.rescue_sheet_empty_euro_rescue_result ?? '',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      );
    }

    final result = licencePlateResult!.euroRescueResult!;
    return Column(
      children:
          result.cars.map((car) {
            return EuroRescueCarWidget(
              euroRescueCar: car,
              onTap: () {}, // TODO: Implement onTap action
            );
          }).toList(),
    );
  }
}
