import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:resq_tools/repositories/substance_repository.dart';

class SubstanceState {
  final SubstanceResult? substance;
  final bool isLoading;
  final bool isError;

  const SubstanceState({
    this.substance,
    this.isLoading = false,
    this.isError = false,
  });

  SubstanceState copyWith({
    SubstanceResult? substance,
    bool? isLoading,
    bool? isError,
  }) {
    return SubstanceState(
      substance: substance ?? this.substance,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}

class SubstanceCubit extends Cubit<SubstanceState> {
  final SubstanceRepository substanceRepository;

  SubstanceCubit(this.substanceRepository) : super(const SubstanceState());

  Future<void> fetchSubstance(String substanceNumber) async {
    emit(state.copyWith(isLoading: true, isError: false));

    try {
      final substance = await substanceRepository.fetchSubstance();
      emit(SubstanceState(substance: substance));
    } catch (error) {
      emit(const SubstanceState(isError: true));
    }
  }
}
