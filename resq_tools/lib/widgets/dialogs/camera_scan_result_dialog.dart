import 'package:flutter/material.dart';
import 'package:resq_tools/models/camera/camera_result.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/utils/extensions.dart';

class CameraScanResultDialog extends StatelessWidget {
  final CameraOcrType ocrType;
  final CameraResult cameraResult;

  const CameraScanResultDialog({
    required this.ocrType,
    required this.cameraResult,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final title =
        ocrType == CameraOcrType.licensePlate
            ? context.l10n?.camera_title_license_plate ?? ''
            : context.l10n?.camera_title_un_number ?? '';

    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (cameraResult.foundNothing)
                Text(
                  context.l10n?.camera_result_nothing_found ?? '',
                  style: TextStyle(fontSize: 16),
                )
              else
                ...?cameraResult.results?.map(
                  (number) => OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(number);
                    },
                    child: Text(number),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(context.l10n?.camera_dialog_close ?? ''),
        ),
      ],
    );
  }
}
