import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/auth/cubit/auth_cubit.dart';

import 'package:translation_project/common/widgets/settings_app_bar_actions.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/view/game_View.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final username = authState is Authenticated ? authState.user.email : '';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcome(username)),
        actions: [
          const SettingsAppBarActions(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.readyForTranslationGame,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GamePage()),
                );
              },
              child: Text(l10n.startGame),
            ),
          ],
        ),
      ),
    );
  }
}
