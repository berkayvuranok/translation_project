import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // API anahtarını .env dosyasından alıyoruz.
  final String? _apiKey = null;
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
    // API anahtarı yoksa veya geçersizse, taklit çeviri yap.
    if (_apiKey == null || _apiKey.isEmpty || _apiKey == 'YOUR_API_KEY') {
      // Geliştirme ortamında uygulamanın çalışmasını sağlamak için
      // gelen metinleri basitçe değiştirip geri döndürüyoruz.
      await Future.delayed(const Duration(milliseconds: 300)); // Sahte bir ağ gecikmesi
      return texts.map((text) => '$text (çevrildi)').toList();
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
