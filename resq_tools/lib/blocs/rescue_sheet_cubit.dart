import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_document.dart';
import 'package:resq_tools/models/rescue_sheet/euro_rescue/euro_rescue_result.dart';
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';
import 'package:resq_tools/repositories/rescue_sheet/euro_rescue_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/licence_plate_repository.dart';
import 'package:resq_tools/repositories/storage_repository.dart';

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
  }) => RescueSheetState(
    isInitialState: isInitialState,
    isLoading: isLoading ?? this.isLoading,
    licencePlateResult: licencePlateResult ?? this.licencePlateResult,
  );
}

class RescueSheetCubit extends Cubit<RescueSheetState> {
  final LicencePlateRepository licencePlateRepository;
  final EuroRescueRepository euroRescueRepository;
  final StorageRepository storageRepository;

  RescueSheetCubit(
    this.licencePlateRepository,
    this.euroRescueRepository,
    this.storageRepository,
  ) : super(const RescueSheetState(isInitialState: true));

  void fetchRescueSheet(
    String licencePlateAuthority,
    String licencePlateNumber,
  ) async {
    emit(RescueSheetState(isLoading: true));

    final appToken = await storageRepository.getAppToken() ?? '';
    final isDemoSystem = await storageRepository.getDemoSystem();

    var licencePlateResult = await licencePlateRepository.fetchLicencePlate(
      licencePlateAuthority,
      licencePlateNumber,
      appToken,
      isDemoSystem,
    );

    await euroRescueRepository.fetchEuroRescue(licencePlateResult);
    emit(
      state.copyWith(licencePlateResult: licencePlateResult, isLoading: false),
    );
  }

  Uri? getLocalizedDocumentUri(
    String deviceLanguageCode,
    List<EuroRescueResultDocument> documents,
  ) {
    if (documents.isEmpty) return null;

    final languagePriority = [deviceLanguageCode.toLowerCase(), 'de', 'en'];
    for (final language in languagePriority) {
      final localizedDocument = documents.firstWhereOrNull(
        (doc) => doc.language.toLowerCase() == language,
      );

      if (localizedDocument != null) {
        return Uri.tryParse(localizedDocument.url);
      }
    }
    // No localized document found, fall back to the first document
    return Uri.tryParse(documents.first.url);
  }
}
