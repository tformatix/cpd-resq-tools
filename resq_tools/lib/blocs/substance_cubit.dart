import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/substance_repository.dart';

class SubstanceState {
  final String? dummyString;

  final bool isLoading;

  const SubstanceState({this.dummyString, this.isLoading = false});
}

class SubstanceCubit extends Cubit<SubstanceState> {
  final SubstanceRepository substanceRepository;

  SubstanceCubit(this.substanceRepository)
    : super(const SubstanceState(isLoading: true)) {
    fetch();
  }

  void fetch() {
    emit(SubstanceState(dummyString: substanceRepository.getDummyString()));
  }
}
