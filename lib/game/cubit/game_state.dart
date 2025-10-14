part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final String wordToTranslate;
  final String correctTranslation;
  final List<String> options;
  final int score;
  final int remainingTime;

  const GameLoaded({
    required this.wordToTranslate,
    required this.correctTranslation,
    required this.options,
    required this.score,
    required this.remainingTime,
  });

  @override
  List<Object?> get props =>
      [wordToTranslate, correctTranslation, options, score, remainingTime];
}

class GameAnswerChecked extends GameState {
  final bool wasCorrect;
  final int score;
  final bool timeUp;
  final String correctAnswer;
  final String? selectedAnswer;

  const GameAnswerChecked({
    required this.wasCorrect,
    required this.score,
    required this.correctAnswer,
    this.selectedAnswer,
    this.timeUp = false,
  });

  @override
  List<Object?> get props =>
      [wasCorrect, score, timeUp, correctAnswer, selectedAnswer];
}

class GameOver extends GameState {
  final int finalScore;

  const GameOver({required this.finalScore});

  @override
  List<Object?> get props => [finalScore];
}

class GameError extends GameState {
  final String message;

  const GameError({required this.message});

  @override
  List<Object?> get props => [message];
}
