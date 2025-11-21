import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/models/user_model.dart';
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
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    // Repository'yi context'ten okuyup kullanıcı verisini yüklüyoruz.
    _userFuture =
        context.read<AuthRepository>().getUserByEmail(email: widget.userEmail);
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
            FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      height: 24, child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Kullanıcı verisi yüklenemedi.',
                      style: TextStyle(color: Colors.red));
                }
                final user = snapshot.data;
                if (user == null) {
                  return const Text('Kullanıcı bulunamadı.');
                }
                return Column(
                  children: [
                    Text(
                      'Toplam Puan: ${user.score}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rütbe: ${user.rank}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
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
