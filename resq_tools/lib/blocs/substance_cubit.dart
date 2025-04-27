import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:resq_tools/repositories/substance_repository.dart';

class SubstanceState {
  final List<SubstanceResult>? substancesList;
  final bool isLoading;
  final bool isInitialState;
  final bool isError;
  final bool isEmptyResult;

  const SubstanceState({
    this.substancesList,
    this.isLoading = false,
    this.isInitialState = false,
    this.isError = false,
    this.isEmptyResult = false,
  });

  SubstanceState copyWith({
    List<SubstanceResult>? substancesList,
    bool? isLoading,
    bool? isInitialState,
    bool? isError,
    bool? isEmptyResult,
  }) {
    return SubstanceState(
      substancesList: substancesList ?? this.substancesList,
      isLoading: isLoading ?? this.isLoading,
      isInitialState: isInitialState ?? this.isInitialState,
      isError: isError ?? this.isError,
      isEmptyResult: isEmptyResult ?? this.isEmptyResult,
    );
  }
}

class SubstanceCubit extends Cubit<SubstanceState> {
  final SubstanceRepository substanceRepository;

  SubstanceCubit(this.substanceRepository)
    : super(const SubstanceState(isInitialState: true));

  Future<void> fetchSubstances(String unNumber, String languageCode) async {
    emit(state.copyWith(isLoading: true, isError: false));

    final substancesList = await substanceRepository.fetchSubstances(
      languageCode,
      int.parse(unNumber),
    );

    if (substancesList == null) {
      emit(const SubstanceState(isError: true));
      return;
    }
    if (substancesList.isEmpty) {
      emit(const SubstanceState(isEmptyResult: true));
      return;
    }

    emit(SubstanceState(substancesList: substancesList));
  }
}
