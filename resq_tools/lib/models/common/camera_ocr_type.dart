enum CameraOcrType {
  licensePlate(
    r'^(AM|BA|BD|BH|BL|BM|BN|BP|BR|BZ|B|DL|DO|EF|EU|E|FE|FK|FR|FV|FW|GB|GD|GF|GM|GR|GS|GU|G|HA|HE|HF|HL|HO|IL|IM|I|JE|JO|JW|KB|KG|KI|KL|KO|KR|KS|KU|K|LA|LB|LE|LF|LI|LL|LN|LZ|L|MA|MD|ME|MI|MT|MU|ND|NK|OP|OW|PE|PL|PT|P|RE|RI|RO|SB|SD|SE|SL|SO|SP|SR|SV|SW|SZ|S|TA|TU|UU|VB|VI|VK|VL|VO|WB|WE|WL|WN|WO|WT|WY|WZ|W|ZE|ZT)\s?((?:[0-9]{1,5}\s?[A-Z]{1,3})|(?:[A-Z]{1,5}\s?[0-9]{1,5}))$', // ignore: lines_longer_than_80_chars
  ),
  substance(r'^([0-9]{4})$');

  final String regex;

  const CameraOcrType(this.regex);

  String? format(RegExpMatch match) {
    var result = match.group(1);
    for (var i = 2; i <= match.groupCount; i++) {
      result = '$result-${match.group(i)}';
    }
    return result?.replaceAll(' ', '');
  }
}
