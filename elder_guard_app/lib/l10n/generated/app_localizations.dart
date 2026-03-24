import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// The application title.
  ///
  /// In en, this message translates to:
  /// **'Elder Guard'**
  String get appTitle;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginAction;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerAction;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @hasAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccountPrompt;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign up now'**
  String get signUpNow;

  /// No description provided for @signInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign in now'**
  String get signInNow;

  /// No description provided for @loginIntro.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get loginIntro;

  /// No description provided for @registerIntro.
  ///
  /// In en, this message translates to:
  /// **'Please enter your details to create an account'**
  String get registerIntro;

  /// No description provided for @switchLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get switchLanguageLabel;

  /// No description provided for @requiredFieldError.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredFieldError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmailError;

  /// No description provided for @passwordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShortError;

  /// No description provided for @usernameTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters.'**
  String get usernameTooShortError;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. Please sign in.'**
  String get registerSuccessMessage;

  /// No description provided for @forgotPasswordUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Password recovery is not available yet.'**
  String get forgotPasswordUnavailable;

  /// No description provided for @emailAlreadyExistsError.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyExistsError;

  /// No description provided for @userNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'No account was found for this email.'**
  String get userNotFoundError;

  /// No description provided for @incorrectPasswordError.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect.'**
  String get incorrectPasswordError;

  /// No description provided for @validationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check the information you entered.'**
  String get validationErrorMessage;

  /// No description provided for @networkErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your localhost API.'**
  String get networkErrorMessage;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The server returned an unexpected response.'**
  String get serverErrorMessage;

  /// No description provided for @unknownErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownErrorMessage;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You are signed in and ready to call protected APIs.'**
  String get homeSubtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get navMonitoring;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get navMenu;

  /// No description provided for @dashboardHeartRateSummary.
  ///
  /// In en, this message translates to:
  /// **'Average Heart Rate: {value} bpm'**
  String dashboardHeartRateSummary(int value);

  /// No description provided for @dashboardStepSummary.
  ///
  /// In en, this message translates to:
  /// **'Step Count: {value}'**
  String dashboardStepSummary(int value);

  /// No description provided for @monitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera monitoring'**
  String get monitoringTitle;

  /// No description provided for @monitoringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep track of the most important areas in the home.'**
  String get monitoringSubtitle;

  /// No description provided for @monitoringLivingRoomCamera.
  ///
  /// In en, this message translates to:
  /// **'Living room camera'**
  String get monitoringLivingRoomCamera;

  /// No description provided for @monitoringEntryCamera.
  ///
  /// In en, this message translates to:
  /// **'Entrance camera'**
  String get monitoringEntryCamera;

  /// No description provided for @monitoringLiveStatus.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get monitoringLiveStatus;

  /// No description provided for @monitoringRecentMovement.
  ///
  /// In en, this message translates to:
  /// **'Recent movement detected 2 min ago.'**
  String get monitoringRecentMovement;

  /// No description provided for @monitoringNoMovement.
  ///
  /// In en, this message translates to:
  /// **'Quiet for the last 20 min.'**
  String get monitoringNoMovement;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Care alerts'**
  String get alertsTitle;

  /// No description provided for @alertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent reminders and activity updates.'**
  String get alertsSubtitle;

  /// No description provided for @alertsMedicationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication reminder'**
  String get alertsMedicationReminderTitle;

  /// No description provided for @alertsMedicationReminderBody.
  ///
  /// In en, this message translates to:
  /// **'08:00 - Morning medication confirmed.'**
  String get alertsMedicationReminderBody;

  /// No description provided for @alertsMovementUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Movement update'**
  String get alertsMovementUpdateTitle;

  /// No description provided for @alertsMovementUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'21:10 - Night walk detected.'**
  String get alertsMovementUpdateBody;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings and account'**
  String get menuTitle;

  /// No description provided for @menuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage session details and app preferences.'**
  String get menuSubtitle;

  /// No description provided for @notificationCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationCenterTitle;

  /// No description provided for @notificationCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest events fetched from the monitoring API.'**
  String get notificationCenterSubtitle;

  /// No description provided for @notificationEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get notificationEmptyMessage;

  /// No description provided for @notificationLoadingList.
  ///
  /// In en, this message translates to:
  /// **'Loading notifications...'**
  String get notificationLoadingList;

  /// No description provided for @notificationLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading notification details...'**
  String get notificationLoadingDetails;

  /// No description provided for @notificationRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get notificationRetryAction;

  /// No description provided for @notificationNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This notification could not be found.'**
  String get notificationNotFoundMessage;

  /// No description provided for @notificationItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera {cameraId} alert'**
  String notificationItemTitle(int cameraId);

  /// No description provided for @notificationItemBody.
  ///
  /// In en, this message translates to:
  /// **'{eventType} detected at {timestamp}'**
  String notificationItemBody(String eventType, String timestamp);

  /// No description provided for @notificationDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification #{eventId}'**
  String notificationDetailTitle(int eventId);

  /// No description provided for @notificationFieldEventId.
  ///
  /// In en, this message translates to:
  /// **'Event ID'**
  String get notificationFieldEventId;

  /// No description provided for @notificationFieldCameraId.
  ///
  /// In en, this message translates to:
  /// **'Camera ID'**
  String get notificationFieldCameraId;

  /// No description provided for @notificationFieldEventType.
  ///
  /// In en, this message translates to:
  /// **'Event type'**
  String get notificationFieldEventType;

  /// No description provided for @notificationFieldConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get notificationFieldConfidence;

  /// No description provided for @notificationFieldTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get notificationFieldTimestamp;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String signedInAs(String email);

  /// No description provided for @connectedToApi.
  ///
  /// In en, this message translates to:
  /// **'Connected to {baseUrl}'**
  String connectedToApi(String baseUrl);

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutAction;

  /// No description provided for @loadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Preparing ElderGuard...'**
  String get loadingMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
