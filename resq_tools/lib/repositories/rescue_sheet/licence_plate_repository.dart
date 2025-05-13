import 'package:http/http.dart' as http;
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';

class LicencePlateRepository {
  static const _baseUrl = 'https://www.feuerwehrapp.at/int';
  static const _loginUrl = '$_baseUrl/index.php?token=';
  static const _searchUrlDemo = '$_baseUrl/kennzeichenuebung/index.php';
  static const _searchUrlProd = '$_baseUrl/kennzeichen/index.php';
  static const _authorityKey = 'plate_pref';
  static const _numberKey = 'plate_number';

  Future<LicencePlateResult> fetchLicencePlate(
    String authority,
    String number,
    String appToken,
    bool isDemoSystem,
  ) async {
    final client = http.Client();

    try {
      final loginRequest = http.Request('GET', Uri.parse('$_loginUrl$appToken'))
        ..followRedirects = false;
      final loginResponse = await client.send(loginRequest);

      final cookie =
          loginResponse.headers['set-cookie']?.split(';').firstOrNull;

      if (cookie == null) {
        throw Exception('Login failed: No session cookie received.');
      }

      final searchUrl = isDemoSystem ? _searchUrlDemo : _searchUrlProd;

      final searchResponse = await client.post(
        Uri.parse(searchUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': cookie,
        },
        body: {_authorityKey: authority, _numberKey: number},
      );

      return LicencePlateResult.fromHtml(searchResponse.body);
    } on Exception catch (_) {
      return LicencePlateResult(cars: []);
    } finally {
      client.close();
    }
  }
}
