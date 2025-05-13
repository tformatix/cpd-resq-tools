import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageRepository {
  static const _keyAppToken = 'KEY_APP_TOKEN';
  static const _keyDemoSystem = 'KEY_DEMO_SYSTEM';

  final FlutterSecureStorage secureStorage;

  StorageRepository()
    : this.withDependencies(secureStorage: const FlutterSecureStorage());

  StorageRepository.withDependencies({required this.secureStorage});

  Future<String?> getAppToken() async =>
      await secureStorage.read(key: _keyAppToken);

  Future<void> setAppToken(String appToken) async =>
      await secureStorage.write(key: _keyAppToken, value: appToken);

  Future<bool> getDemoSystem() async =>
      await secureStorage.read(key: _keyDemoSystem) == 'true';

  Future<void> setDemoSystem(bool isDemoSystem) async {
    await secureStorage.write(
      key: _keyDemoSystem,
      value: isDemoSystem.toString(),
    );
  }
}
