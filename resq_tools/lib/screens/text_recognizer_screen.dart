import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/widgets/text_detector/camera_widget.dart';
import 'package:resq_tools/widgets/text_detector/text_recognizer_painter.dart';

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
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CameraWidget(
            customPaint: _customPaint,
            onImage: _processImage,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged:
                (value) => _cameraLensDirection = value,
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;

    final recognizedText = await _textRecognizer.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        recognizedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
