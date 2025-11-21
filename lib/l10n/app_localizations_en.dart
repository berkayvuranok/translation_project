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

  @override
  String get email => 'Email';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email.';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password.';

  @override
  String get dontHaveAnAccountSignUp => 'Don\'t have an account? Sign Up';

  @override
  String get pleaseEnterAValidEmail => 'Please enter a valid email address.';

  @override
  String get passwordTooShort =>
      'Password must be at least 10 characters long.';

  @override
  String get passwordRequiresUppercase =>
      'Password must contain at least one uppercase letter.';

  @override
  String get passwordRequiresSpecialCharacter =>
      'Password must contain at least one special character.';

  @override
  String get alreadyHaveAnAccountLogin => 'Already have an account? Login';

  @override
  String get timeIsUp => 'Time\'s Up!';

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect!';

  @override
  String get correctAnswerIs => 'The correct answer is';

  @override
  String get translationGame => 'Translation Game';

  @override
  String get loginSignUp => 'Login / Sign Up';

  @override
  String get playAsGuest => 'Play as Guest';
}
