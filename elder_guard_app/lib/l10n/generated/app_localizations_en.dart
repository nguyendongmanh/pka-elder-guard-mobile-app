// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Elder Guard';

  @override
  String get loginAction => 'Sign In';

  @override
  String get registerAction => 'Sign Up';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password';

  @override
  String get usernameHint => 'Username';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get hasAccountPrompt => 'Already have an account?';

  @override
  String get signUpNow => 'Sign up now';

  @override
  String get signInNow => 'Sign in now';

  @override
  String get loginIntro => 'Please sign in to continue';

  @override
  String get registerIntro => 'Please enter your details to create an account';

  @override
  String get switchLanguageLabel => 'Switch language';

  @override
  String get requiredFieldError => 'This field is required.';

  @override
  String get invalidEmailError => 'Please enter a valid email address.';

  @override
  String get passwordTooShortError => 'Password must be at least 6 characters.';

  @override
  String get usernameTooShortError => 'Username must be at least 3 characters.';

  @override
  String get registerSuccessMessage => 'Account created successfully. Please sign in.';

  @override
  String get forgotPasswordUnavailable => 'Password recovery is not available yet.';

  @override
  String get emailAlreadyExistsError => 'This email is already registered.';

  @override
  String get userNotFoundError => 'No account was found for this email.';

  @override
  String get incorrectPasswordError => 'The password is incorrect.';

  @override
  String get validationErrorMessage => 'Please check the information you entered.';

  @override
  String get networkErrorMessage => 'Unable to connect to the server. Please check your localhost API.';

  @override
  String get serverErrorMessage => 'The server returned an unexpected response.';

  @override
  String get unknownErrorMessage => 'Something went wrong. Please try again.';

  @override
  String get homeTitle => 'Welcome back';

  @override
  String get homeSubtitle => 'You are signed in and ready to call protected APIs.';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String connectedToApi(String baseUrl) {
    return 'Connected to $baseUrl';
  }

  @override
  String get logoutAction => 'Sign out';

  @override
  String get loadingMessage => 'Preparing ElderGuard...';
}
