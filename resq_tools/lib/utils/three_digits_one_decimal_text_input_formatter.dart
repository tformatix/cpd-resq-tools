import 'package:flutter/services.dart';

// needed since regular TextInputFormatter deletes the text field value
class ThreeDigitOneDecimalFormatter extends TextInputFormatter {
  final _regex = RegExp(r'^\d{0,3}(\.\d{0,1})?$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (_regex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}