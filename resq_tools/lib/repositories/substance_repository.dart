import 'dart:convert';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:http/http.dart' as http;

class SubstanceRepository {
  static const _baseUrl = 'https://gestis-api.dguv.de/api';
  static const _supportedLanguages = ['de', 'en'];

  //https://gestis-api.dguv.de/api/search/de?stoffname=&nummern=1203&summenformel=&volltextsuche=&branche=&risikogruppe=&kategorie=&anmerkung=&erweitert=false&exact=true
  static const _searchUrl = '$_baseUrl/search';
  //https://gestis-api.dguv.de/api/article/de/150866
  static const _articleUrl = '$_baseUrl/article';

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

    final localizedUri = _buildLocalizedUri(_searchUrl, languageCode);
    final uri = localizedUri.replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final substanceList = List<SubstanceResult>.from(
          data.map((item) => SubstanceResult.fromJson(item)),
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

  Uri _buildLocalizedUri(String baseUri, String languageCode) {
    final safeLanguageCode =
        _supportedLanguages.contains(languageCode) ? languageCode : 'de';

    return Uri.parse('$_searchUrl/$safeLanguageCode');
  }
}