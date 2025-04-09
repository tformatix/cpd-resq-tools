import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';

class TextFieldCameraSearch extends StatefulWidget {
  final String? labelText;
  final Function(String) onSearchClicked;
  final bool isLoading;

  const TextFieldCameraSearch({
    super.key,
    required this.labelText,
    required this.onSearchClicked,
    required this.isLoading,
  });

  @override
  State<TextFieldCameraSearch> createState() => _TextFieldCameraSearchState();
}

class _TextFieldCameraSearchState extends State<TextFieldCameraSearch> {
  final TextEditingController _textEditingController = TextEditingController();

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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.labelText,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // TODO: implement camera
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
