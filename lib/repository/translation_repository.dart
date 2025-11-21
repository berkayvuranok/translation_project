import 'package:translation_project/services/translation_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Kelime çevirilerini yöneten repository.
///
/// Bu sınıf, uygulamanın geri kalanı (BLoC'lar, Cubit'ler) ile veri kaynakları
/// (bu durumda `TranslationService`) arasında bir aracı katman görevi görür.
/// Gelecekte buraya önbellekleme (caching) veya farklı çeviri servisleri arasında
/// geçiş yapma gibi ek özellikler eklenebilir.
class TranslationRepository {
  final TranslationService _translationService;

  /// Bir [TranslationRepository] örneği oluşturur.
  ///
  /// Test kolaylığı için harici bir [translationService] sağlanabilir.
  /// Eğer sağlanmazsa, kendi `TranslationService` örneğini oluşturur.
  TranslationRepository({TranslationService? translationService})
      : _translationService = translationService ?? TranslationService();

  /// Verilen bir kelimeyi API üzerinden çevirir.
  ///
  /// [word] çevrilecek kelimedir.
  /// [targetLanguage] çevirinin yapılacağı hedef dildir (varsayılan: 'tr').
  Future<String> translateWord(String word, {String targetLanguage = 'tr'}) async {
    try {
      final translatedWords = await _translationService.translate(
        texts: [word],
        targetLanguage: targetLanguage,
      );
      return translatedWords.first;
    } catch (e) {
      // Hata yönetimi: Hatanın loglanması veya daha üst katmanlara
      // anlaşılır bir şekilde fırlatılması burada yapılabilir.
      // Şimdilik hatayı olduğu gibi tekrar fırlatıyoruz.
      rethrow;
    }
  }

  /// Verilen kelime listesini API üzerinden çevirir.
  Future<List<String>> translateWords(List<String> words,
      {String targetLanguage = 'tr'}) async {
    try {
      return await _translationService.translate(
        texts: words,
        targetLanguage: targetLanguage,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Oyun oturumu için harici bir API'den rastgele kelimeler çeker.
  Future<List<String>> getWordsForNewGame(int count) async {
    final uri = Uri.parse('https://random-word-api.herokuapp.com/word?number=$count');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> wordsJson = jsonDecode(response.body);
        return wordsJson.cast<String>();
      } else {
        throw Exception('Rastgele kelime API\'sinden kelimeler alınamadı. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Rastgele kelime API\'sine bağlanırken hata oluştu: $e');
    }
  }
}