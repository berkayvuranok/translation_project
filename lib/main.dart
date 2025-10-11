import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:translation_project/auth/cubit/auth_cubit.dart';

import 'package:translation_project/auth/view/login_view.dart';
import 'package:translation_project/repository/auth_repository.dart';

import 'package:translation_project/home/view/home_view.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/language/cubit/language_cubit.dart';
import 'package:translation_project/repository/settings_repository.dart';
import 'package:translation_project/repository/translation_repository.dart';
import 'package:translation_project/theme/cubit/theme_cubit.dart';

void main() async {
  // Uygulama başlamadan önce Flutter binding'lerinin hazır olduğundan emin ol.
  WidgetsFlutterBinding.ensureInitialized();

  // .env dosyasını yükle
  await dotenv.load(fileName: ".env");

  // Repository'leri burada oluşturuyoruz.
  final translationRepository = TranslationRepository();
  final settingsRepository = SettingsRepository();
  final authRepository = AuthRepository();

  runApp(MyApp(
    translationRepository: translationRepository,
    settingsRepository: settingsRepository,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.translationRepository,
      required this.settingsRepository,
      required this.authRepository});

  final TranslationRepository translationRepository;
  final SettingsRepository settingsRepository;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    // RepositoryProvider ile repository'leri widget ağacının altındaki
    // widget'ların erişimine sunuyoruz.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: translationRepository),
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit(context.read<AuthRepository>())),
          BlocProvider(create: (_) => ThemeCubit(settingsRepository)),
          BlocProvider(create: (_) => LanguageCubit(settingsRepository)),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              title: 'Translation Game',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal, brightness: Brightness.light),
                useMaterial3: true,
                textTheme:
                    GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.teal, brightness: Brightness.dark),
                useMaterial3: true,
                textTheme: GoogleFonts.montserratTextTheme(
                    Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)),
              ),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                return state is Authenticated ? const HomePage() : const LoginPage();
              }),
            ); // Closing parenthesis for MaterialApp
          },
        ); // Closing parenthesis for BlocBuilder<LanguageCubit, Locale>
      }, // Closing parenthesis for BlocBuilder<ThemeCubit, ThemeMode>
    );
  }
}
