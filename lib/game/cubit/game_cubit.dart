import 'dart:math';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/translation_repository.dart';
import '../../repository/auth_repository.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final TranslationRepository _translationRepository;
  final AuthRepository _authRepository;
  final String? _currentUserEmail;
  int _score = 0;
  int _questionCount = 0;
  static const int _totalQuestions = 20;
  static const int _questionDuration = 15; // Soru başına süre (saniye)
  List<String> _wordsForCurrentGame = [];
  String _correctAnswer = '';
  final Random _random = Random();
  Timer? _timer;

  GameCubit(
      this._translationRepository, this._authRepository, this._currentUserEmail)
      : super(GameInitial());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> startGame() async {
    _score = 0;
    _questionCount = 0;
    _timer?.cancel();
    emit(GameLoading());
    try {
      // Oyun için kelimeleri harici API'den çekiyoruz.
      _wordsForCurrentGame = await _translationRepository
          .getWordsForNewGame(_totalQuestions);
    } catch (e) {
      emit(GameError(message: 'Oyun başlatılamadı: Kelimeler alınamadı.\n$e'));
      return;
    }
    await nextQuestion();
  }

  Future<void> nextQuestion() async {
    _timer?.cancel();
    if (_questionCount >= _wordsForCurrentGame.length) {
      if (_currentUserEmail != null) {
        await _authRepository.updateUserScore(
            email: _currentUserEmail, score: _score);
      }
      emit(GameOver(finalScore: _score));
      return;
    }
    emit(GameLoading());
    try {
      // 1. Mevcut oyun için hazırlanan listeden sıradaki kelimeyi al.
      final wordToTranslate = _wordsForCurrentGame[_questionCount];
      
      // 2. Yanlış seçenekler için 3 tane daha rastgele kelime al.
      final distractorWords = await _translationRepository.getWordsForNewGame(3);

      // 3. Çevrilecek kelimeleri bir araya getir.
      final wordsToTranslate = [wordToTranslate, ...distractorWords];

      // 4. Tüm kelimeleri tek seferde çevir.
      final translatedWords = await _translationRepository.translateWords(wordsToTranslate);

      // 5. Doğru çeviriyi ve seçenekleri ayarla.
      // `wordToTranslate` kelimesinin çevirisi, `translatedWords` listesindeki
      // ilk elemandır çünkü API, istekteki sırayla cevap döner.
      final correctTranslation = translatedWords.first;
      _correctAnswer = correctTranslation;

      // 6. Seçenekleri karıştır.
      final options = List<String>.from(translatedWords)..shuffle(_random);

      _questionCount++;

      emit(GameLoaded(
        wordToTranslate: wordToTranslate,
        // Bu alanı artık UI'da kullanmıyoruz ama state'te tutmakta fayda var.
        correctTranslation: correctTranslation,
        options: options,
        score: _score,
        remainingTime: _questionDuration,
      ));
      _startTimer();
    } catch (e) {
      // API hatası veya başka bir sorun oluşursa GameError durumu emit et.
      emit(GameError(message: 'Kelime yüklenirken bir hata oluştu: $e'));
    }
  }

  void checkAnswer(String selectedAnswer) {
    _timer?.cancel();
    final bool isCorrect = selectedAnswer == _correctAnswer;
    if (isCorrect) {
      _score += 10;
    }
    emit(GameAnswerChecked(
        wasCorrect: isCorrect,
        score: _score,
        correctAnswer: _correctAnswer,
        selectedAnswer: selectedAnswer));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentState = state;
      if (currentState is GameLoaded) {
        if (currentState.remainingTime > 1) {
          emit(GameLoaded(
            wordToTranslate: currentState.wordToTranslate,
            correctTranslation: currentState.correctTranslation,
            options: currentState.options,
            score: currentState.score,
            remainingTime: currentState.remainingTime - 1,
          ));
        } else {
          _timeUp();
        }
      }
    });
  }

  void _timeUp() {
    _timer?.cancel();
    emit(GameAnswerChecked(
        wasCorrect: false,
        score: _score,
        timeUp: true,
        correctAnswer: _correctAnswer));
  }
}
