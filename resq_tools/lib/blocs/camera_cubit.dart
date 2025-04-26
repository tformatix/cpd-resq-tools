import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_tools/models/camera/camera_result.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/repositories/camera_repository.dart';

class CameraState {
  final CameraResult? cameraResult;
  final bool showPickerDialog;
  final bool isLoading;

  const CameraState({
    this.cameraResult,
    this.showPickerDialog = false,
    this.isLoading = false,
  });

  CameraState copyWith({
    CameraResult? cameraResult,
    bool? showPickerDialog,
    bool? isLoading,
  }) {
    return CameraState(
      cameraResult: cameraResult ?? this.cameraResult,
      showPickerDialog: showPickerDialog ?? this.showPickerDialog,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository cameraRepository;

  CameraCubit(this.cameraRepository) : super(const CameraState());

  void showDialog() {
    emit(state.copyWith(showPickerDialog: true));
  }

  Future<void> matchOcr(CameraOcrType ocrType, XFile image) async {
    emit(state.copyWith(isLoading: true, showPickerDialog: false));

    final cameraResult = await cameraRepository.matchOcr(ocrType, image);

    emit(CameraState(cameraResult: cameraResult));
  }

  void closeDialog() {
    emit(state.copyWith(showPickerDialog: false));
  }

  void reset() {
    emit(const CameraState());
  }
}
