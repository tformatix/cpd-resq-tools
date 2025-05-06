import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/screens/camera_screen.dart';
import 'package:resq_tools/utils/extensions.dart';

class TextFieldCameraSearch extends StatefulWidget {
  final String? initialText;
  final String? labelText;
  final String? errorText;
  final Function(String) onSearchClicked;
  final CameraOcrType ocrType;
  final TextInputType? keyboardType;
  final bool isLoading;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldCameraSearch({
    super.key,
    this.initialText,
    required this.labelText,
    this.errorText,
    required this.onSearchClicked,
    required this.ocrType,
    required this.isLoading,
    this.inputFormatters,
    this.keyboardType
  });

  @override
  State<TextFieldCameraSearch> createState() => _TextFieldCameraSearchState();
}

class _TextFieldCameraSearchState extends State<TextFieldCameraSearch> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.initialText != null) {
      _textEditingController.text = widget.initialText!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.labelText,
                  errorText: widget.errorText,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      final result = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CameraScreen(ocrType: widget.ocrType);
                          },
                        ),
                      );

                      if (result != null) {
                        _textEditingController.text = result;
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: FilledButton(
            style: FilledButton.styleFrom(
              disabledBackgroundColor: Colors.grey,
              disabledForegroundColor: Colors.grey,
            ),
            onPressed:
                widget.isLoading
                    ? null
                    : () {
                      if (_textEditingController.text.isEmpty) return;

                      widget.onSearchClicked(_textEditingController.text);
                    },
            child: Padding(
              padding: EdgeInsets.all(16),
              child:
                  widget.isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : Text(
                        '${context.l10n?.text_field_camera_search_button}',
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
