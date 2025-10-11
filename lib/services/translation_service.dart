import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TranslationService {
  // API anahtarını .env dosyasından alıyoruz.
  final String? _apiKey = dotenv.env['TRANSLATION_API_KEY'];
  final String _apiUrl =
      'https://translation.googleapis.com/language/translate/v2';

  /// Verilen metin listesini belirtilen dile çevirir.
  ///
  /// [texts] çevrilecek metinlerin listesidir.
  /// [targetLanguage] çevirinin yapılacağı hedef dildir (varsayılan: 'tr').
  /// [sourceLanguage] kaynak metnin dilidir (opsiyonel).
  Future<List<String>> translate({
    required List<String> texts,
    String targetLanguage = 'tr',
    String? sourceLanguage,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty || _apiKey == 'YOUR_API_KEY') {
      throw Exception(
          'TRANSLATION_API_KEY bulunamadı veya .env dosyasında ayarlanmamış.');
    }
    if (texts.isEmpty) {
      return [];
    }

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: jsonEncode({
          'q': texts,
          'target': targetLanguage,
          if (sourceLanguage != null) 'source': sourceLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        final translations = body['data']['translations'] as List;
        return translations.map((t) => t['translatedText'] as String).toList();
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? response.body;
        throw Exception('Çeviri API hatası: $errorMessage');
      }
    } catch (e) {
      throw Exception('Çeviri servisine bağlanırken hata oluştu: $e');
    }
  }
}
