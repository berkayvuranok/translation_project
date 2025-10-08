import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/language/cubit/language_cubit.dart';
import 'package:translation_project/theme/cubit/theme_cubit.dart';
import 'package:translation_project/l10n/app_localizations.dart';

class SettingsAppBarActions extends StatelessWidget {
  const SettingsAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, state) {
            final isDarkMode =
                state == ThemeMode.dark ||
                (state == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark);
            return IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: isDarkMode ? l10n.lightTheme : l10n.darkTheme,
              onPressed: () {
                final newTheme = isDarkMode ? ThemeMode.light : ThemeMode.dark;
                context.read<ThemeCubit>().setTheme(newTheme);
              },
            );
          },
        ),
        PopupMenuButton<Locale>(
          icon: const Icon(Icons.language),
          tooltip: l10n.language,
          onSelected: (locale) {
            context.read<LanguageCubit>().changeLanguage(locale);
          },
          itemBuilder: (BuildContext context) {
            return AppLocalizations.supportedLocales.map((locale) {
              final languageName = locale.languageCode == 'en'
                  ? 'English'
                  : 'Türkçe';
              return PopupMenuItem<Locale>(
                value: locale,
                child: Text(languageName),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
