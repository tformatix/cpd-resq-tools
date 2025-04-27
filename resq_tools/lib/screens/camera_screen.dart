import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_tools/blocs/camera_cubit.dart';
import 'package:resq_tools/models/camera/camera_result.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/dialogs/camera_scan_result_dialog.dart';

class CameraScreen extends StatefulWidget {
  final CameraOcrType ocrType;

  const CameraScreen({super.key, required this.ocrType});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraCubit>().showDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle =
        widget.ocrType == CameraOcrType.licensePlate
            ? context.l10n?.camera_title_license_plate ?? ''
            : context.l10n?.camera_title_un_number ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: BlocListener<CameraCubit, CameraState>(
        listenWhen: (prev, curr) => curr.showPickerDialog,
        listener: (context, state) async {
          final cameraCubit = context.read<CameraCubit>();
          final imageSource = await _showImageSourceDialog();

          if (imageSource != null) {
            final image = await picker.pickImage(source: imageSource);

            if (image != null) {
              cameraCubit.matchOcr(widget.ocrType, image);
            }
          }
        },
        child: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            return state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _getCameraWidget(context, state);
          },
        ),
      ),
    );
  }

  Widget _getCameraWidget(BuildContext context, CameraState state) {
    final cameraResults = state.cameraResult;

    if (cameraResults == null) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<CameraCubit>().showDialog();
          },
          child: Text(context.l10n?.camera_take_or_choose_photo ?? ''),
        ),
      );
    } else {
      return _getProcessedWidget(context, cameraResults);
    }
  }

  Widget _getProcessedWidget(
    BuildContext cubitContext,
    CameraResult cameraResult,
  ) {
    final navigator = Navigator.of(context);
    final cubit = context.read<CameraCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final result = await showDialog<String>(
        context: context,
        builder: (context) {
          return CameraScanResultDialog(
            ocrType: widget.ocrType,
            cameraResult: cameraResult,
          );
        },
      );

      if (!mounted) return;

      cubit.reset();

      if (result?.isNotEmpty == true) {
        navigator.pop(result);
      }
    });

    return Container(color: Theme.of(context).colorScheme.surface);
  }

  Future<ImageSource?> _showImageSourceDialog() => showDialog<ImageSource>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.l10n?.camera_choose_image_source ?? ''),
        content: Text(
          context.l10n?.camera_choose_image_source_description ?? '',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: Text(context.l10n?.camera_image_source_gallery ?? ''),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: Text(context.l10n?.camera_image_source_camera ?? ''),
          ),
        ],
      );
    },
  );
}
