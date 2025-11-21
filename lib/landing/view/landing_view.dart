import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/auth/view/login_view.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/language/cubit/language_cubit.dart';
import 'package:translation_project/theme/cubit/theme_cubit.dart';
import 'package:translation_project/view/game_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.translationGame,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.loginSignUp),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const GamePage()),
                );
              },
              child: Text(AppLocalizations.of(context)!.playAsGuest),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dil seçimi
            BlocBuilder<LanguageCubit, Locale>(
              builder: (context, state) {
                return DropdownButton<Locale>(
                  value: state,
                  icon: const Icon(Icons.language),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      context.read<LanguageCubit>().changeLanguage(newLocale);
                    }
                  },
                  items: AppLocalizations.supportedLocales
                      .map<DropdownMenuItem<Locale>>((Locale locale) {
                    return DropdownMenuItem<Locale>(
                      value: locale,
                      child: Text(locale.languageCode.toUpperCase()),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(width: 20),
            // Tema seçimi
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(state == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode),
                  onPressed: () {
                    final newTheme = state == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                    context.read<ThemeCubit>().setTheme(newTheme);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
