import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';

class ResistanceState {
  final String? dummyString;

  final bool isLoading;

  const ResistanceState({this.dummyString, this.isLoading = false});
}

class ResistanceCubit extends Cubit<ResistanceState> {
  final ResistanceRepository resistanceRepository;

  ResistanceCubit(this.resistanceRepository)
    : super(const ResistanceState(isLoading: true)) {
    fetch();
  }

  void fetch() {
    emit(ResistanceState(dummyString: resistanceRepository.getDummyString()));
  }
}
