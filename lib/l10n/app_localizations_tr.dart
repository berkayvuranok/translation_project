// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get login => 'Giriş Yap';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get password => 'Şifre';

  @override
  String get dontHaveAnAccount => 'Hesabın yok mu? ';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get alreadyHaveAnAccount => 'Zaten bir hesabın var mı? ';

  @override
  String welcome(Object username) {
    return 'Hoş Geldin, $username';
  }

  @override
  String get readyForTranslationGame => 'Çeviri Oyununa Hazır Mısın?';

  @override
  String get startGame => 'Oyuna Başla';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get translateAndWin => 'Çevir & Kazan';

  @override
  String score(Object score) {
    return 'Puan: $score';
  }

  @override
  String get whatIsTheTurkishMeaning => 'Bu kelimenin Türkçe karşılığı nedir?';

  @override
  String get correctAnswer => 'Doğru! +10 Puan';

  @override
  String get wrongAnswer => 'Yanlış Cevap!';

  @override
  String get errorOccurred => 'Bir hata oluştu.';

  @override
  String get lightTheme => 'Açık Tema';

  @override
  String get darkTheme => 'Karanlık Tema';

  @override
  String get language => 'Dil';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get passwordsDoNotMatch => 'Şifreler uyuşmuyor!';

  @override
  String get signUpSuccess => 'Kayıt başarılı! Hoş geldiniz.';

  @override
  String get gameOver => 'Oyun Bitti';

  @override
  String get finalScore => 'Nihai Puan';

  @override
  String get returnToHome => 'Ana Sayfaya Dön';

  @override
  String get email => 'E-posta';

  @override
  String get pleaseEnterYourEmail => 'Lütfen e-posta adresinizi girin.';

  @override
  String get pleaseEnterYourPassword => 'Lütfen şifrenizi girin.';

  @override
  String get dontHaveAnAccountSignUp => 'Hesabın yok mu? Kayıt Ol';

  @override
  String get pleaseEnterAValidEmail =>
      'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String get alreadyHaveAnAccountLogin => 'Zaten bir hesabın var mı? Giriş Yap';
}
