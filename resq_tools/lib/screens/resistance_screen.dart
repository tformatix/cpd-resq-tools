import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';
import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';
import 'package:resq_tools/screens/angle_measurement_screen.dart';
import 'package:resq_tools/screens/settings_screen.dart';
import 'package:resq_tools/utils/extensions.dart';

class ResistanceScreen extends StatefulWidget {
  final int? inputWeight;

  const ResistanceScreen({super.key, this.inputWeight});

  @override
  State<ResistanceScreen> createState() => _ResistanceScreenState();
}

class _ResistanceScreenState extends State<ResistanceScreen> {
  MeasurementConfig _measurementConfig = MeasurementConfig.empty();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _angleController = TextEditingController();
  final fontSizeResistance = 16.0;
  final fontSizeOverallResistance = 20.0;

  @override
  void initState() {
    super.initState();

    if (widget.inputWeight != null) {
      _measurementConfig = _measurementConfig.copyWith(
        weight: widget.inputWeight,
        vehicleType: VehicleType.custom,
      );
      _weightController.text = widget.inputWeight.toString();
      _updateMeasurementConfig(context);
      context.read<ResistanceCubit>().resistanceCalculation();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.l10n?.resistance_title ?? ''),
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
    body: BlocBuilder<ResistanceCubit, ResistanceState>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _getResistanceWidget(context, state);
      },
    ),
  );

  Widget _getResistanceWidget(
    BuildContext context,
    ResistanceState state,
  ) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      child: Column(
        children: [
          DropdownMenu<VehicleType>(
            width: double.infinity,
            initialSelection: _measurementConfig.vehicleType,
            onSelected: (value) {
              setState(() {
                _measurementConfig = _measurementConfig.copyWith(
                  vehicleType: value,
                );
                if (value?.weight != null) {
                  _weightController.text = value!.weight.toString();
                  _measurementConfig = _measurementConfig.copyWith(
                    weight: value.weight,
                  );
                }
              });
              _updateMeasurementConfig(context);
            },
            dropdownMenuEntries:
                VehicleType.values
                    .map(
                      (vehicleType) => DropdownMenuEntry(
                        value: vehicleType,
                        label: vehicleType.getTranslation(context.l10n) ?? '',
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: context.l10n?.resistance_weight,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: context.l10n?.resistance_weight,
              suffixIcon: IconButton(
                onPressed: () {
                  _weightController.clear();
                  _measurementConfig = _measurementConfig.copyWith(weight: 0);
                  _updateMeasurementConfig(context);
                },
                icon: Icon(Icons.clear),
              ),
            ),
            onChanged: (value) {
              _updateWeight(context, value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _angleController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText:
                  context.l10n?.resistance_angle_label ?? 'Neigungswinkel (°)',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                icon: const Icon(Icons.straighten),
                onPressed: () async {
                  final navigator = Navigator.of(context);

                  final result = await navigator.push<double>(
                    MaterialPageRoute(
                      builder: (_) => const AngleMeasurementScreen(),
                    ),
                  );

                  if (result != null && mounted) {
                    setState(() {
                      _angleController.text = result.toStringAsFixed(1);
                      _measurementConfig = _measurementConfig.copyWith(
                        angle: result,
                      );
                      _updateMeasurementConfig(context);
                    });

                    // remove focus from text field to not show keyboard after
                    // completed angle measurement
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                _angleController.text = value;
                _measurementConfig = _measurementConfig.copyWith(
                  angle: double.tryParse(value),
                );
              });
              _updateMeasurementConfig(context);
            },
          ),
          const SizedBox(height: 12),
          DropdownMenu<UndergroundType>(
            width: double.infinity,
            initialSelection: _measurementConfig.undergroundType,
            onSelected: (value) {
              setState(() {
                _measurementConfig = _measurementConfig.copyWith(
                  undergroundType: value,
                );
              });
              _updateMeasurementConfig(context);
            },
            dropdownMenuEntries:
                UndergroundType.values
                    .map(
                      (undergroundType) => DropdownMenuEntry(
                        value: undergroundType,
                        label:
                            undergroundType.getTranslation(context.l10n) ?? '',
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),

          if (state.resistanceResult != null)
            _showResistanceResult(context, state.resistanceResult),
        ],
      ),
    ),
  );

  Widget _showResistanceResult(
    BuildContext context,
    ResistanceResult? resistanceResult,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildResultRow(
        context.l10n?.resistance_rolling_resistance ?? 'Rolling Resistance',
        '${resistanceResult?.rollingResistance.toStringAsFixed(2)} kN',
        fontSizeResistance,
      ),
      _buildResultRow(
        context.l10n?.resistance_gradient_resistance ?? 'Gradient Resistance',
        '${resistanceResult?.gradientResistance.toStringAsFixed(2)} kN',
        fontSizeResistance,
      ),
      const Divider(),
      _buildResultRow(
        context.l10n?.resistance_overall_resistance ?? 'Overall Resistance',
        '${resistanceResult?.overallResistance.toStringAsFixed(2)} kN',
        fontSizeOverallResistance,
        isBold: true,
      ),
    ],
  );

  Widget _buildResultRow(
    String label,
    String value,
    double fontSize, {
    bool isBold = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  void _updateWeight(BuildContext context, String weight) {
    setState(() {
      _measurementConfig = _measurementConfig.copyWith(
        weight: int.tryParse(weight),
      );
    });
    _updateMeasurementConfig(context);
  }

  void _updateMeasurementConfig(BuildContext context) {
    context.read<ResistanceCubit>().updateMeasurementConfig(_measurementConfig);
    context.read<ResistanceCubit>().resistanceCalculation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<ResistanceCubit>();
    final config = cubit.state.measurementConfig;

    if (config != null) {
      _measurementConfig = config;

      final weightToUse = config.weight;
      _weightController.text = weightToUse.toString();

      _angleController.text = config.angle?.toStringAsFixed(1) ?? '';

      if (cubit.state.resistanceResult == null) {
        _measurementConfig = _measurementConfig.copyWith(
          weight: weightToUse,
          angle: config.angle,
        );
        _updateMeasurementConfig(context);
        cubit.resistanceCalculation();
      }
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _angleController.dispose();
    super.dispose();
  }
}
