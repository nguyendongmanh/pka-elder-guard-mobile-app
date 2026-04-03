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
  String get navHome => 'Home';

  @override
  String get navMonitoring => 'Monitoring';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navMenu => 'Menu';

  @override
  String dashboardHeartRateSummary(int value) {
    return 'Average Heart Rate: $value bpm';
  }

  @override
  String dashboardStepSummary(int value) {
    return 'Step Count: $value';
  }

  @override
  String get monitoringTitle => 'Camera monitoring';

  @override
  String get monitoringSubtitle => 'Keep track of the most important areas in the home.';

  @override
  String get monitoringLivingRoomCamera => 'Living room camera';

  @override
  String get monitoringEntryCamera => 'Entrance camera';

  @override
  String get monitoringLiveStatus => 'LIVE';

  @override
  String get monitoringRecentMovement => 'Recent movement detected 2 min ago.';

  @override
  String get monitoringNoMovement => 'Quiet for the last 20 min.';

  @override
  String get alertsTitle => 'Care alerts';

  @override
  String get alertsSubtitle => 'Recent reminders and activity updates.';

  @override
  String get alertsMedicationReminderTitle => 'Medication reminder';

  @override
  String get alertsMedicationReminderBody => '08:00 - Morning medication confirmed.';

  @override
  String get alertsMovementUpdateTitle => 'Movement update';

  @override
  String get alertsMovementUpdateBody => '21:10 - Night walk detected.';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuPersonalInfoTitle => 'Personal information';

  @override
  String get menuHealthProfileTitle => 'Health profile';

  @override
  String get menuSettingsPrivacyTitle => 'Settings and privacy';

  @override
  String get menuAboutTitle => 'About';

  @override
  String menuComingSoonMessage(String section) {
    return '$section will be available soon.';
  }

  @override
  String get notificationCenterTitle => 'Notifications';

  @override
  String get notificationCenterSubtitle => 'Push alerts received on this device.';

  @override
  String get notificationEmptyMessage => 'No notifications yet.';

  @override
  String get notificationStatusTitle => 'Push status';

  @override
  String get notificationRegistrationLabel => 'Backend registration';

  @override
  String get notificationSubscriptionLabel => 'Subscription ID';

  @override
  String get notificationUserLabel => 'User ID';

  @override
  String get notificationStatusWaitingForLogin => 'Waiting for login';

  @override
  String get notificationStatusWaitingForSubscription => 'Waiting for subscription ID';

  @override
  String get notificationStatusRegistered => 'Registered';

  @override
  String get notificationStatusFailed => 'Registration failed';

  @override
  String get notificationPopupOpenAction => 'Open';

  @override
  String get notificationSourceForeground => 'Foreground';

  @override
  String get notificationSourceOpened => 'Opened';

  @override
  String get notificationLoadingList => 'Loading notifications...';

  @override
  String get notificationLoadingDetails => 'Loading notification details...';

  @override
  String get notificationRetryAction => 'Retry';

  @override
  String get notificationNotFoundMessage => 'This notification could not be found.';

  @override
  String notificationItemTitle(int cameraId) {
    return 'Camera $cameraId alert';
  }

  @override
  String notificationItemBody(String eventType, String timestamp) {
    return '$eventType detected at $timestamp';
  }

  @override
  String notificationDetailTitle(int eventId) {
    return 'Notification #$eventId';
  }

  @override
  String get notificationFieldEventId => 'Event ID';

  @override
  String get notificationFieldCameraId => 'Camera ID';

  @override
  String get notificationFieldEventType => 'Event type';

  @override
  String get notificationFieldConfidence => 'Confidence';

  @override
  String get notificationFieldTimestamp => 'Timestamp';

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
