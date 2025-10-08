part of 'game_cubit.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final String wordToTranslate;
  final String correctTranslation;
  final List<String> options;
  final int score;

  const GameLoaded({
    required this.wordToTranslate,
    required this.correctTranslation,
    required this.options,
    required this.score,
  });

  @override
  List<Object> get props => [wordToTranslate, correctTranslation, options, score];
}

class GameAnswerChecked extends GameState {
  final bool wasCorrect;
  final int score;

  const GameAnswerChecked({required this.wasCorrect, required this.score});

  @override
  List<Object> get props => [wasCorrect, score];
}

class GameOver extends GameState {
  final int finalScore;

  const GameOver({required this.finalScore});

  @override
  List<Object> get props => [finalScore];
}