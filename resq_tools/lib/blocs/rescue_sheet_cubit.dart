import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';
import 'package:resq_tools/repositories/rescue_sheet/euro_rescue_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/licence_plate_repository.dart';

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
  final LicencePlateRepository licencePlateRepository;
  final EuroRescueRepository euroRescueRepository;

  RescueSheetCubit(this.licencePlateRepository, this.euroRescueRepository)
    : super(const RescueSheetState(isInitialState: true));

  void fetchRescueSheet(
    String licencePlateAuthority,
    String licencePlateNumber,
  ) async {
    emit(RescueSheetState(isLoading: true));

    var licencePlateResult = await licencePlateRepository.fetchLicencePlate(
      licencePlateAuthority,
      licencePlateNumber,
    );

    await euroRescueRepository.fetchEuroRescue(licencePlateResult);
    emit(
      state.copyWith(licencePlateResult: licencePlateResult, isLoading: false),
    );
  }
}
