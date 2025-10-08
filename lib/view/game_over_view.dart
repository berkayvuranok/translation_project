import 'package:flutter/material.dart';
import 'package:translation_project/l10n/app_localizations.dart';

class GameOverPage extends StatelessWidget {
  final int score;
  const GameOverPage({super.key, required this.score});

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
              '$score',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Bu sayfa GamePage'in yerini aldığı için, pop() yapmak ana sayfaya döner.
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              child: Text(l10n.returnToHome),
            ),
          ],
        ),
      ),
    );
  }
}
