import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/game/cubit/game_cubit.dart';
import 'package:translation_project/repository/auth_repository.dart';
import 'package:translation_project/auth/cubit/auth_cubit.dart';
import 'package:translation_project/repository/settings_repository.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/view/game_over_view.dart';
import 'package:translation_project/repository/translation_repository.dart';



class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if (authState is! Authenticated) {
      // This should not happen, but it's a safeguard.
      return const Scaffold(body: Center(child: Text('User not authenticated!')));
    }
    return BlocProvider(
      create: (context) => GameCubit(
        context.read<TranslationRepository>(),
        context.read<AuthRepository>(),
        authState.user.email,
      )..startGame(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translateAndWin),
      ),
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state is GameAnswerChecked) {
            // Kısa bir bekleme sonrası yeni soruya geç
            Future.delayed(const Duration(seconds: 2), () {
              context.read<GameCubit>().nextQuestion();
            });
          } else if (state is GameOver) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => GameOverPage(
                  score: state.finalScore,
                  userEmail: (context.read<AuthCubit>().state as Authenticated).user.email,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GameLoading || state is GameInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GameLoaded) {
            return _buildGameUI(context, state);
          }
          if (state is GameAnswerChecked) {
            return AnswerFeedbackView(
              wasCorrect: state.wasCorrect,
              timeUp: state.timeUp,
              correctAnswer: state.correctAnswer,
              selectedAnswer: state.selectedAnswer,
            );
          }
          if (state is GameError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }
          return Center(child: Text(l10n.errorOccurred));
        },
      ),
    );
  }

  Widget _buildGameUI(BuildContext context, GameLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.score(state.score),
                  style: Theme.of(context).textTheme.headlineSmall),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: state.remainingTime / 15.0, // 15 saniye
                      strokeWidth: 5,
                    ),
                  ),
                  Text('${state.remainingTime}', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(AppLocalizations.of(context)!.whatIsTheTurkishMeaning),
              const SizedBox(height: 16),
              Text(
                state.wordToTranslate,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: state.options.length,
            itemBuilder: (context, index) {
              final option = state.options[index];
              return ElevatedButton(
                onPressed: () {
                  context.read<GameCubit>().checkAnswer(option);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(option),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnswerFeedbackView extends StatelessWidget {
  final bool wasCorrect;
  final bool timeUp;
  final String correctAnswer;
  final String? selectedAnswer;

  const AnswerFeedbackView({
    super.key,
    required this.wasCorrect,
    this.timeUp = false,
    required this.correctAnswer,
    this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color color = wasCorrect ? Colors.green : Colors.red;
    final IconData icon = wasCorrect ? Icons.check : Icons.close;
    String message;
    if (timeUp) {
      message = l10n.timeIsUp; // Needs to be added to l10n
    } else {
      message = wasCorrect ? l10n.correct : l10n.incorrect; // Needs to be added to l10n
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 100),
          const SizedBox(height: 20),
          Text(message, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color)),
          if (!wasCorrect) ...[
            const SizedBox(height: 20),
            Text('${l10n.correctAnswerIs}: $correctAnswer'), // Needs to be added to l10n
          ],
        ],
      ),
    );
  }
}
