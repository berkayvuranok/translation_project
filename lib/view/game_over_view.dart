import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/repository/auth_repository.dart';
import 'package:translation_project/view/game_view.dart';

class GameOverPage extends StatefulWidget {
  final int score;
  final String userEmail;
  const GameOverPage(
      {super.key, required this.score, required this.userEmail});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  late Future<int> _highScoreFuture;

  @override
  void initState() {
    super.initState();
    // Repository'yi context'ten okuyup yüksek skoru yüklüyoruz.
    _highScoreFuture =
        context.read<AuthRepository>().getUserHighScore(email: widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gameOver),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.finalScore,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.score}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<int>(
              future: _highScoreFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      height: 24, child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  // TODO: Bu metni l10n dosyasına ekleyin. (Örn: "highScoreCouldNotBeLoaded": "Yüksek skor yüklenemedi.")
                  return Text('Yüksek skor yüklenemedi.',
                      style: TextStyle(color: Colors.red));
                }
                final highScore = snapshot.data ?? 0;
                // TODO: Bu metni l10n dosyasına ekleyin. (Örn: "highScore": "En Yüksek Skor: {score}")
                return Text(
                  'En Yüksek Skor: $highScore',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              // TODO: Bu metni l10n dosyasına ekleyin. (Örn: "playAgain": "Tekrar Oyna")
              child: const Text('Tekrar Oyna'),
            ),
          ],
        ),
      ),
    );
  }
}
