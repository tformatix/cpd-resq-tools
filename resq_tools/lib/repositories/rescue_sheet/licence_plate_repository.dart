import 'package:http/http.dart' as http;
import 'package:resq_tools/models/rescue_sheet/licence_plate/licence_plate_result.dart';
import 'package:resq_tools/utils/token.dart';

class LicencePlateRepository {
  static const _baseUrl = 'https://www.feuerwehrapp.at/int';
  static const _loginUrl =
      '$_baseUrl/index.php?token=${Token.licencePlateToken}';
  static const _searchUrl = '$_baseUrl/kennzeichenuebung/index.php';
  static const _authorityKey = 'plate_pref';
  static const _numberKey = 'plate_number';

  Future<LicencePlateResult?> fetchLicencePlate(
    String authority,
    String number,
  ) async {
    final client = http.Client();

    try {
      final loginRequest = http.Request('GET', Uri.parse(_loginUrl))
        ..followRedirects = false;
      final loginResponse = await client.send(loginRequest);

      final cookie =
          loginResponse.headers['set-cookie']?.split(';').firstOrNull;

      if (cookie == null) {
        throw Exception('Login failed: No session cookie received.');
      }

      final searchResponse = await client.post(
        Uri.parse(_searchUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': cookie,
        },
        body: {_authorityKey: authority, _numberKey: number},
      );

      return LicencePlateResult.fromHtml(searchResponse.body);
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }
}
