import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translation_project/l10n/app_localizations.dart';
import 'package:translation_project/repository/settings_repository.dart';

class LanguageCubit extends Cubit<Locale> {
  final SettingsRepository _settingsRepository;

  LanguageCubit(this._settingsRepository) : super(const Locale('tr')) {
    _loadLanguage();
  }

  void _loadLanguage() async {
    final savedLocale = await _settingsRepository.loadLanguage();
    if (savedLocale != null) {
      emit(savedLocale);
    } else {
      // Kayıtlı dil yoksa, sistem dilini algıla.
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

      // Sistem dili desteklenen diller arasında mı kontrol et.
      final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
        (l) => l.languageCode == systemLocale.languageCode,
        orElse: () => const Locale('en'), // Desteklenmiyorsa İngilizce'ye düş.
      );
      emit(supportedLocale);
    }
  }

  void changeLanguage(Locale locale) {
    _settingsRepository.saveLanguage(locale);
    emit(locale);
  }
}
