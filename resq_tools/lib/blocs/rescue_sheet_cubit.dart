import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';
import 'package:resq_tools/repositories/rescue_sheet_repository.dart';

class RescueSheetState {
  final bool isInitialState;
  final bool isLoading;
  final LicencePlateResult? licencePlateResult;

  const RescueSheetState({
    this.isInitialState = false,
    this.isLoading = false,
    this.licencePlateResult,
  });

  RescueSheetState copyWith({
    bool? isLoading,
    LicencePlateResult? licencePlateResult,
    EuroRescueResult? euroRescueResult,
  }) {
    return RescueSheetState(
      isInitialState: isInitialState,
      isLoading: isLoading ?? this.isLoading,
      licencePlateResult: licencePlateResult ?? this.licencePlateResult,
    );
  }
}

class RescueSheetCubit extends Cubit<RescueSheetState> {
  final RescueSheetRepository rescueSheetRepository;

  RescueSheetCubit(this.rescueSheetRepository)
    : super(const RescueSheetState(isInitialState: true));

  void fetchRescueSheet(String licencePlate) async {
    emit(RescueSheetState(isLoading: true));

    var licencePlateResult = await rescueSheetRepository.fetchLicencePlate(
      licencePlate,
    );

    if (licencePlateResult == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    licencePlateResult = await rescueSheetRepository.fetchEuroRescue(
      licencePlateResult,
    );
    emit(
      state.copyWith(licencePlateResult: licencePlateResult, isLoading: false),
    );
  }
}
