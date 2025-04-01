import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/rescue_sheet_repository.dart';

class RescueSheetState {
  final String? dummyString;

  final bool isLoading;

  const RescueSheetState({this.dummyString, this.isLoading = false});
}

class RescueSheetCubit extends Cubit<RescueSheetState> {
  final RescueSheetRepository rescueSheetRepository;

  RescueSheetCubit(this.rescueSheetRepository)
    : super(const RescueSheetState(isLoading: true)) {
    fetch();
  }

  void fetch() {
    emit(RescueSheetState(dummyString: rescueSheetRepository.getDummyString()));
  }
}
