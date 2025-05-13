import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/text_detector/camera_widget.dart';

class TextRecognizerScreen extends StatefulWidget {
  final CameraOcrType ocrType;

  const TextRecognizerScreen({super.key, required this.ocrType});

  @override
  State<TextRecognizerScreen> createState() => _TextRecognizerScreenState();
}

class _TextRecognizerScreenState extends State<TextRecognizerScreen> {
  final _textRecognizer = TextRecognizer();

  bool _canProcess = true;
  bool _isBusy = false;
  CameraLensDirection _cameraLensDirection = CameraLensDirection.back;

  Map<String, int> matchCount = {};
  int maxMatchCount = 0;
  String? maxMatchText;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenTitle =
        widget.ocrType == CameraOcrType.licensePlate
            ? context.l10n?.camera_title_license_plate ?? ''
            : context.l10n?.camera_title_un_number ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: Column(
        children: [
          LinearProgressIndicator(),
          CameraWidget(
            onImage: (_canProcess && !_isBusy) ? _processImage : null,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged:
                (value) => _cameraLensDirection = value,
            submitButton: ElevatedButton(
              onPressed:
                  maxMatchText != null
                      ? () => Navigator.of(context).pop(maxMatchText)
                      : null,
              child: Text(
                maxMatchText ?? context.l10n?.camera_result_empty ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (mounted) setState(() => _isBusy = true);

    final recognizedText = await _textRecognizer.processImage(inputImage);

    final regex = RegExp(widget.ocrType.regex);

    for (var block in recognizedText.blocks) {
      for (final match in regex.allMatches(block.text)) {
        final matchText = widget.ocrType.format(match);

        if (matchText == null) {
          continue;
        }

        final currentMatchCount = (matchCount[matchText] ?? 0) + 1;
        matchCount[matchText] = currentMatchCount;

        if (currentMatchCount > maxMatchCount) {
          maxMatchCount = currentMatchCount;
          maxMatchText = matchText;
        }
      }
    }

    if (mounted) setState(() => _isBusy = false);
  }
}
