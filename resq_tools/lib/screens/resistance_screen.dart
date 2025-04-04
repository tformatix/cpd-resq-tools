import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';
import 'package:resq_tools/models/resistance/underground_type.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';
import 'package:resq_tools/utils/extensions.dart';

class ResistanceScreen extends StatefulWidget {
  const ResistanceScreen({super.key});

  @override
  State<ResistanceScreen> createState() => _ResistanceScreenState();
}

class _ResistanceScreenState extends State<ResistanceScreen> {
  MeasurementConfig _measurementConfig = MeasurementConfig.empty();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    _weightController.text = _measurementConfig.weight.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n?.resistance_title ?? '')),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownMenu<VehicleType>(
            width: double.infinity,
            initialSelection: _measurementConfig.vehicleType,
            onSelected: (value) {
              setState(() {
                _measurementConfig = _measurementConfig.copyWith(
                  vehicleType: value,
                );
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
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: context.l10n?.resistance_weight,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: context.l10n?.resistance_weight,
            ),
            onChanged: (value) {
              setState(() {
                _measurementConfig = _measurementConfig.copyWith(
                  weight: int.tryParse(value),
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
          FilledButton(
            onPressed: () {
              context.read<ResistanceCubit>().resistanceCalculation();
            },
            child: Text(context.l10n?.resistance_start_calculation ?? ''),
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
    children: [
      Text('${context.l10n?.resistance_angle}: ${resistanceResult?.angle}'),
      Text(
        '${context.l10n?.resistance_rolling_resistance}: '
        '${resistanceResult?.rollingResistance}',
      ),
      Text(
        '${context.l10n?.resistance_gradient_resistance}: '
        '${resistanceResult?.gradientResistance}',
      ),
      Text(
        '${context.l10n?.resistance_overall_resistance}: '
        '${resistanceResult?.overallResistance}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );

  void _updateMeasurementConfig(BuildContext context) {
    context.read<ResistanceCubit>().updateMeasurementConfig(_measurementConfig);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final config = context.read<ResistanceCubit>().state.measurementConfig;
    if (config != null) {
      _measurementConfig = config;
      _weightController.text = config.weight.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}
