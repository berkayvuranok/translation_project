import 'dart:math';

class TranslationRepository {
  // Kelime listesi (Genişletilebilir)
  final List<Map<String, String>> _wordList = [
    {'en': 'apple', 'tr': 'elma'},
    {'en': 'book', 'tr': 'kitap'},
    {'en': 'car', 'tr': 'araba'},
    {'en': 'house', 'tr': 'ev'},
    {'en': 'tree', 'tr': 'ağaç'},
    {'en': 'water', 'tr': 'su'},
    {'en': 'computer', 'tr': 'bilgisayar'},
  ];

  // API'yi taklit eden sahte çeviri fonksiyonu
  // Gerçek bir projede burası http.post ile API'ye bağlanır.
  Future<String> translate(String word, String targetLanguage) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Sahte bir gecikme
    final foundWord = _wordList.firstWhere(
      (element) => element['en'] == word.toLowerCase(),
      orElse: () => {'tr': 'çeviri bulunamadı'},
    );
    return foundWord[targetLanguage] ?? 'hata';
  }

  // Oyunda sorulacak rastgele bir kelime getirir.
  Future<Map<String, String>> getRandomWord() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _wordList[Random().nextInt(_wordList.length)];
  }

  // Yanlış seçenekler oluşturmak için rastgele kelimeler getirir.
  List<String> getFakeOptions(String correctTranslation, String lang) {
    final options = <String>{correctTranslation};
    final otherWords = _wordList.where((w) => w[lang] != correctTranslation).toList();
    otherWords.shuffle();
    for (var i = 0; i < 3 && i < otherWords.length; i++) {
      options.add(otherWords[i][lang]!);
    }
    final optionList = options.toList();
    optionList.shuffle();
    return optionList;
  }
}
