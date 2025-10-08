import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/game/cubit/game_cubit.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/view/game_over_view.dart';
import 'package:translation_project/repository/translation_repository.dart';



class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GameCubit(context.read<TranslationRepository>())..startGame(),
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
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content:
                      Text(state.wasCorrect ? l10n.correctAnswer : l10n.wrongAnswer),
                  backgroundColor: state.wasCorrect ? Colors.green : Colors.red,
                ),
              );
            // Kısa bir bekleme sonrası yeni soruya geç
            Future.delayed(const Duration(seconds: 1), () {
              context.read<GameCubit>().nextQuestion();
            });
          } else if (state is GameOver) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => GameOverPage(score: state.finalScore),
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
          // GameAnswerChecked durumunda UI donar, listener yeni soruyu tetikler
          if (state is GameAnswerChecked) {
            // Bir önceki GameLoaded state'ini bulup göstermeye devam edebiliriz
            // ama şimdilik basit tutalım ve sadece yükleniyor gösterelim.
            return const Center(child: CircularProgressIndicator());
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
          Text(AppLocalizations.of(context)!.score(state.score),
              style: Theme.of(context).textTheme.headlineSmall),
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
