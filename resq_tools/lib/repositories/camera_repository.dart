import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_tools/models/camera/camera_result.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';

class CameraRepository {
  Future<CameraResult> matchOcr(CameraOcrType ocrType, XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await TextRecognizer().processImage(
      inputImage,
    );

    final regex = RegExp(ocrType.regex, caseSensitive: false);
    final matches = <String>{};

    for (var block in recognizedText.blocks) {
      for (final match in regex.allMatches(block.text)) {
        matches.add(
          _postProcessResult(
            ocrType,
            match.group(0)!.replaceAll(RegExp(r'\s+'), ''),
          ),
        );
      }
    }

    final results = matches.toList();

    return CameraResult(foundNothing: results.isEmpty, results: results);
  }

  String _postProcessResult(CameraOcrType ocrType, String result) {
    if (ocrType == CameraOcrType.licensePlate) {
      return _formatLicensePlate(result);
    } else if (ocrType == CameraOcrType.substance) {
      return result.trim();
    }
    return result;
  }

  String _formatLicensePlate(String result) {
    final regex = RegExp(r'([A-Z]{1,3})(\d{1,5})([A-Z]{1,3})');
    final match = regex.firstMatch(result.trim());

    if (match != null) {
      final districtCode = match.group(1);
      final number = match.group(2);
      final suffix = match.group(3);

      return '$districtCode-$number$suffix';
    }

    return result;
  }
}
