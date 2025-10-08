
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/translation_repository.dart';


part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final TranslationRepository _translationRepository;
  int _score = 0;
  int _questionCount = 0;
  static const int _totalQuestions = 20;
  String _correctAnswer = '';

  GameCubit(this._translationRepository) : super(GameInitial());

  Future<void> startGame() async {
    _score = 0;
    _questionCount = 0;
    await nextQuestion();
  }

  Future<void> nextQuestion() async {
    if (_questionCount >= _totalQuestions) {
      emit(GameOver(finalScore: _score));
      return;
    }
    emit(GameLoading());
    try {
      final wordData = await _translationRepository.getRandomWord();
      final wordToTranslate = wordData['en']!;
      final correctTranslation = wordData['tr']!;
      _correctAnswer = correctTranslation;

      _questionCount++;
      final options = _translationRepository.getFakeOptions(correctTranslation, 'tr');

      emit(GameLoaded(
        wordToTranslate: wordToTranslate,
        correctTranslation: correctTranslation,
        options: options,
        score: _score,
      ));
    } catch (e) {
      // Hata yönetimi eklenebilir
    }
  }

  void checkAnswer(String selectedAnswer) {
    final bool isCorrect = selectedAnswer == _correctAnswer;
    if (isCorrect) {
      _score += 10;
    }
    emit(GameAnswerChecked(wasCorrect: isCorrect, score: _score));
  }
}
