enum CameraOcrType {
  licensePlate(r'[A-Z]{1,3}[\s\-]?\d{1,5}[\s\-]?[A-Z]{1,3}'),
  substance(r'^\d{4}$');

  final String regex;
  const CameraOcrType(this.regex);
}
