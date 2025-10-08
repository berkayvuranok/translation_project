// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAnAccount => 'Already have an account? ';

  @override
  String welcome(Object username) {
    return 'Welcome, $username';
  }

  @override
  String get readyForTranslationGame =>
      'Are you ready for the Translation Game?';

  @override
  String get startGame => 'Start Game';

  @override
  String get logout => 'Logout';

  @override
  String get translateAndWin => 'Translate & Win';

  @override
  String score(Object score) {
    return 'Score: $score';
  }

  @override
  String get whatIsTheTurkishMeaning =>
      'What is the Turkish meaning of this word?';

  @override
  String get correctAnswer => 'Correct! +10 Points';

  @override
  String get wrongAnswer => 'Wrong Answer!';

  @override
  String get errorOccurred => 'An error occurred.';

  @override
  String get lightTheme => 'Light Theme';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get language => 'Language';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match!';

  @override
  String get signUpSuccess => 'Signup successful! Welcome.';

  @override
  String get gameOver => 'Game Over';

  @override
  String get finalScore => 'Final Score';

  @override
  String get returnToHome => 'Return to Home';
}
