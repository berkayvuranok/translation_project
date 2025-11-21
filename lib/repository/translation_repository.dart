import 'dart:math';

/// Kelime ve oyun repository'si.
class TranslationRepository {
  final _random = Random();

  // Oyun için kullanılacak sabit kelime listesi (İngilizce-Türkçe)
  final Map<String, String> _wordPairs = {
    'apple': 'elma',
    'pear': 'armut',
    'cherry': 'kiraz',
    'strawberry': 'çilek',
    'banana': 'muz',
    'orange': 'portakal',
    'mandarin': 'mandalina',
    'lemon': 'limon',
    'watermelon': 'karpuz',
    'melon': 'kavun',
    'dog': 'köpek',
    'cat': 'kedi',
    'bird': 'kuş',
    'horse': 'at',
    'fish': 'balık',
    'house': 'ev',
    'car': 'araba',
    'school': 'okul',
    'book': 'kitap',
    'notebook': 'defter',
    'pen': 'kalem',
    'sun': 'güneş',
    'moon': 'ay',
    'star': 'yıldız',
    'sea': 'deniz',
    'weather': 'hava',
    'earth': 'toprak',
    'water': 'su',
    'fire': 'ateş',
    'tree': 'ağaç'
  };

  TranslationRepository();

  /// Oyun için rastgele İngilizce kelimeler döndürür.
  Future<List<String>> getWordsForNewGame(
    int count, {
    String sourceLanguage = 'en',
  }) async {
    if (sourceLanguage != 'en') {
      // Bu basit implementasyon sadece İngilizce kaynak dilini destekler.
      return [];
    }
    final allWords = _wordPairs.keys.toList();
    if (count > allWords.length) {
      allWords.shuffle(_random);
      return allWords;
    }

    allWords.shuffle(_random);
    return allWords.sublist(0, count);
  }

  /// Verilen bir İngilizce kelimeyi Türkçe'ye çevirir.
  Future<String> translateWord(String word) async {
    await Future.delayed(const Duration(milliseconds: 50)); // Sahte gecikme
    return _wordPairs[word] ?? 'çeviri_bulunamadı';
  }

  /// Verilen İngilizce kelime listesini Türkçe'ye çevirir.
  Future<List<String>> translateWords(List<String> words) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Sahte gecikme
    return words.map((word) => _wordPairs[word] ?? 'çeviri_bulunamadı').toList();
  }
}
