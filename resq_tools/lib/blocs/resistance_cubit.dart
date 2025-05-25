import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/resistance/measurement_config.dart';
import 'package:resq_tools/models/resistance/resistance_result.dart';
import 'package:resq_tools/models/resistance/vehicle_type.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';

class ResistanceState {
  final MeasurementConfig? measurementConfig;
  final bool isLoading;
  final ResistanceResult? resistanceResult;

  const ResistanceState({
    this.measurementConfig,
    this.isLoading = false,
    this.resistanceResult,
  });

  ResistanceState copyWith({
    MeasurementConfig? measurementConfig,
    bool? isLoading,
    ResistanceResult? resistanceResult,
  }) => ResistanceState(
    measurementConfig: measurementConfig ?? this.measurementConfig,
    isLoading: isLoading ?? this.isLoading,
    resistanceResult: resistanceResult ?? this.resistanceResult,
  );
}

class ResistanceCubit extends Cubit<ResistanceState> {
  final ResistanceRepository resistanceRepository;

  ResistanceCubit(this.resistanceRepository)
    : super(
        ResistanceState(
          isLoading: true,
          measurementConfig: MeasurementConfig.empty(),
        ),
      ) {
    fetch();
  }

  void fetch() {
    emit(ResistanceState(measurementConfig: MeasurementConfig.empty()));
  }

  void updateMeasurementConfig(MeasurementConfig measurementConfig) {
    emit(state.copyWith(measurementConfig: measurementConfig));
  }

  void resistanceCalculation() {
    final resistanceResult = resistanceRepository.calculateResistance(
      state.measurementConfig,
    );
    emit(state.copyWith(resistanceResult: resistanceResult));
  }

  void setWeightFromCar(int weight) {
    if (state.measurementConfig?.weight == null ||
        state.measurementConfig?.weight == 0) {
      final updatedWeight =
          state.measurementConfig?.copyWith(
            weight: weight,
            vehicleType: VehicleType.custom,
          ) ??
          MeasurementConfig.empty().copyWith(
            weight: weight,
            vehicleType: VehicleType.custom,
          );

      updateMeasurementConfig(updatedWeight);
      resistanceCalculation();
    }
  }
}
