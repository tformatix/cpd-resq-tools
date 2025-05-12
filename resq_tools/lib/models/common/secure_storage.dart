import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _instance = FlutterSecureStorage();
  static get instance => _instance;
}
