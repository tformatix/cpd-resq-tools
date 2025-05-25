import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/rescue_sheet_cubit.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/screens/settings_screen.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/rescue_sheet/euro_rescue_car_widget.dart';
import 'package:resq_tools/widgets/rescue_sheet/licence_plate_car_widget.dart';
import 'package:resq_tools/widgets/text_field_camera_search.dart';
import 'package:url_launcher/url_launcher.dart';

class RescueSheetScreen extends StatefulWidget {
  const RescueSheetScreen({super.key});

  @override
  State<RescueSheetScreen> createState() => _RescueSheetScreenState();
}

class _RescueSheetScreenState extends State<RescueSheetScreen> {
  static const licencePlateDelimiter = '-';
  int selectedLicencePlateCarIdx = 0;
  String? licencePlateErrorText;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n?.rescue_sheet_title ?? ''),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    ),
    body: BlocBuilder<RescueSheetCubit, RescueSheetState>(
      builder: (context, state) {
        return _getRescueSheetWidget(context, state);
      },
    ),
  );

  Widget _getRescueSheetWidget(BuildContext context, RescueSheetState state) {
    final licencePlateCar = state.licencePlateResult?.cars.firstOrNull;

    if (licencePlateCar != null && licencePlateCar.maxTotalWeight != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ResistanceCubit>().setWeightFromCar(
          licencePlateCar.maxTotalWeight!,
        );
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: ListView(
        children: [
          TextFieldCameraSearch(
            labelText: context.l10n?.rescue_sheet_textfield_label,
            errorText: licencePlateErrorText,
            isLoading: state.isLoading,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                var text = newValue.text.toUpperCase();

                if (oldValue.text.length < 2 &&
                    text.length == 2 &&
                    RegExp(r'^[A-Z]{2}$').hasMatch(text)) {
                  text += licencePlateDelimiter;
                }

                return TextEditingValue(text: text);
              }),
            ],
            onSearchClicked: (String licencePlate) {
              final match = RegExp(
                CameraOcrType.licensePlate.regex,
              ).firstMatch(licencePlate);
              final authority = match?.group(1);
              final number = match?.group(2);

              if (authority == null || number == null) {
                setState(() {
                  licencePlateErrorText =
                      context.l10n?.rescue_sheet_textfield_error_invalid;
                });
                return;
              }

              setState(() {
                licencePlateErrorText = null;
              });

              context.read<RescueSheetCubit>().fetchRescueSheet(
                authority,
                number,
              );
            },
            ocrType: CameraOcrType.licensePlate,
          ),
          if (!state.isInitialState && !state.isLoading)
            _showResults(context, state),
        ],
      ),
    );
  }

  Widget _showResults(BuildContext context, RescueSheetState state) =>
      state.licencePlateResult == null
          ? Text(
            context.l10n?.rescue_sheet_empty_licence_plate_result ?? '',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          )
          : Column(
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
              onTap: () {
                var deviceLanguageCode =
                    Localizations.localeOf(context).languageCode;

                var localizedUrl = context
                    .read<RescueSheetCubit>()
                    .getLocalizedDocumentUri(deviceLanguageCode, car.documents);

                if (localizedUrl != null) {
                  launchUrl(
                    localizedUrl,
                    mode: LaunchMode.externalNonBrowserApplication,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('''
${context.l10n?.rescue_sheet_no_rescue_card_found_for_car}'''),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            );
          }).toList(),
    );
  }
}
