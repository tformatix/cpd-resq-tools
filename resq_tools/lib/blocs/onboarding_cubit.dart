import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/repositories/storage_repository.dart';

class OnboardingState {
  final String? appToken;
  final bool isDemoSystem;

  const OnboardingState({this.appToken, this.isDemoSystem = true});
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final StorageRepository storageRepository;

  OnboardingCubit(this.storageRepository) : super(OnboardingState());

  void fetchOnboardingDetails() async {
    final appToken = await storageRepository.getAppToken();
    final isDemoSystem = await storageRepository.getDemoSystem();

    emit(OnboardingState(appToken: appToken, isDemoSystem: isDemoSystem));
  }

  void setOnboardingDetails(String appToken, bool isDemoSystem) async {
    await storageRepository.setAppToken(appToken);
    await storageRepository.setDemoSystem(isDemoSystem);
    emit(OnboardingState(appToken: appToken, isDemoSystem: isDemoSystem));
  }
}
