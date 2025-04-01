import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/blattler_repository.dart';

class BlattlerState {
  final String? dummyString;

  final bool isLoading;

  const BlattlerState({this.dummyString, this.isLoading = false});
}

class BlattlerCubit extends Cubit<BlattlerState> {
  final BlattlerRepository blattlerRepository;

  BlattlerCubit(this.blattlerRepository)
    : super(const BlattlerState(isLoading: true)) {
    fetch();
  }

  void fetch() {
    emit(BlattlerState(dummyString: blattlerRepository.getDummyString()));
  }
}
