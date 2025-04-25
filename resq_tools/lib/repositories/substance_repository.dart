import 'dart:convert';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:http/http.dart' as http;

class SubstanceRepository {
  static const _baseUrl = 'https://gestis-api.dguv.de/api';
  static const _supportedLanguages = ['de', 'en'];

  //https://gestis-api.dguv.de/api/search/de?stoffname=&nummern=1203&summenformel=&volltextsuche=&branche=&risikogruppe=&kategorie=&anmerkung=&erweitert=false&exact=true
  static const _searchUrl = '$_baseUrl/search';

  //https://gestis.dguv.de/data?name=150866&lang=en
  static const _dataUrl = 'https://gestis.dguv.de/data';

  Future<List<SubstanceResult>?> fetchSubstances(
    String languageCode,
    int unNumber,
  ) async {
    final queryParameters = {
      'nummern': unNumber.toString(),
      'erweitert': 'false',
      //TODO: maybe make toggleable
      'exact': 'true',
    };

    final safeLanguageCode =
        _supportedLanguages.contains(languageCode) ? languageCode : 'de';
    final localizedUrl = '$_searchUrl/$safeLanguageCode';

    final uri = Uri.tryParse(
      localizedUrl,
    )?.replace(queryParameters: queryParameters);
    if (uri == null) {
      throw Exception('Invalid URL: $localizedUrl');
    }

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final substanceList = List<SubstanceResult>.from(
          data.map((item) {
            final substance = SubstanceResult.fromJson(item);
            final url = _buildSubstanceUrl(languageCode, substance.zvgNumber);
            substance.detailUrl = url;
            return substance;
          }),
        );

        return substanceList;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on Exception catch (_) {
      //TODO: avoid catching all exceptions
      return null;
    }
  }

  Uri _buildSubstanceUrl(String languageCode, String zvgNumber) {
    final safeLanguageCode =
        _supportedLanguages.contains(languageCode) ? languageCode : 'de';

    final queryParameters = {'name': zvgNumber, 'lang': safeLanguageCode};
    final uri = Uri.tryParse(
      _dataUrl,
    )?.replace(queryParameters: queryParameters);
    if (uri == null) {
      throw Exception('Invalid URL: $uri');
    }

    return uri;
  }
}
