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
  /// **'Unable to connect to the server. Please check your API configuration.'**
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

  /// No description provided for @monitoringAddCameraAction.
  ///
  /// In en, this message translates to:
  /// **'Add camera'**
  String get monitoringAddCameraAction;

  /// No description provided for @monitoringAddCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Add demo camera'**
  String get monitoringAddCameraTitle;

  /// No description provided for @monitoringEditCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename camera'**
  String get monitoringEditCameraTitle;

  /// No description provided for @monitoringCameraNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera name'**
  String get monitoringCameraNameLabel;

  /// No description provided for @monitoringCameraNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a camera name'**
  String get monitoringCameraNameHint;

  /// No description provided for @monitoringCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get monitoringCancelAction;

  /// No description provided for @monitoringSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get monitoringSaveAction;

  /// No description provided for @monitoringRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get monitoringRenameAction;

  /// No description provided for @monitoringDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete camera'**
  String get monitoringDeleteAction;

  /// No description provided for @monitoringDemoBadge.
  ///
  /// In en, this message translates to:
  /// **'DEMO'**
  String get monitoringDemoBadge;

  /// No description provided for @monitoringTapToView.
  ///
  /// In en, this message translates to:
  /// **'Demo camera widget, no live video.'**
  String get monitoringTapToView;

  /// No description provided for @monitoringDemoTapMessage.
  ///
  /// In en, this message translates to:
  /// **'{cameraName} is currently only a demo widget.'**
  String monitoringDemoTapMessage(String cameraName);

  /// No description provided for @monitoringEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No demo cameras yet'**
  String get monitoringEmptyTitle;

  /// No description provided for @monitoringEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a camera to try the demo monitoring layout.'**
  String get monitoringEmptyDescription;

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
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuPersonalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get menuPersonalInfoTitle;

  /// No description provided for @menuHealthProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Health profile'**
  String get menuHealthProfileTitle;

  /// No description provided for @menuSettingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings and privacy'**
  String get menuSettingsPrivacyTitle;

  /// No description provided for @menuAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAboutTitle;

  /// No description provided for @menuComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'{section} will be available soon.'**
  String menuComingSoonMessage(String section);

  /// No description provided for @healthProfileDemoDescription.
  ///
  /// In en, this message translates to:
  /// **'The data below is a simulated health profile used to demo the elderly care monitoring interface.'**
  String get healthProfileDemoDescription;

  /// No description provided for @healthProfileDemoBadge.
  ///
  /// In en, this message translates to:
  /// **'DEMO DATA'**
  String get healthProfileDemoBadge;

  /// No description provided for @healthProfileDemoName.
  ///
  /// In en, this message translates to:
  /// **'Nguyen Thi Lan'**
  String get healthProfileDemoName;

  /// No description provided for @healthProfileAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get healthProfileAgeLabel;

  /// No description provided for @healthProfileAgeValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {age}'**
  String healthProfileAgeValue(String label, int age);

  /// No description provided for @healthProfileFieldValue.
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String healthProfileFieldValue(String label, String value);

  /// No description provided for @healthProfileBloodTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood type'**
  String get healthProfileBloodTypeLabel;

  /// No description provided for @healthProfileCareLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Care level'**
  String get healthProfileCareLevelLabel;

  /// No description provided for @healthProfileCareLevelValue.
  ///
  /// In en, this message translates to:
  /// **'Daily monitoring'**
  String get healthProfileCareLevelValue;

  /// No description provided for @healthProfileVitalsSection.
  ///
  /// In en, this message translates to:
  /// **'Vital signs'**
  String get healthProfileVitalsSection;

  /// No description provided for @healthProfileHeartRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Resting heart rate'**
  String get healthProfileHeartRateLabel;

  /// No description provided for @healthProfileHeartRateValue.
  ///
  /// In en, this message translates to:
  /// **'{value} bpm'**
  String healthProfileHeartRateValue(int value);

  /// No description provided for @healthProfileBloodPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get healthProfileBloodPressureLabel;

  /// No description provided for @healthProfileSpo2Label.
  ///
  /// In en, this message translates to:
  /// **'SpO2'**
  String get healthProfileSpo2Label;

  /// No description provided for @healthProfileSpo2Value.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String healthProfileSpo2Value(int value);

  /// No description provided for @healthProfileWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get healthProfileWeightLabel;

  /// No description provided for @healthProfileWeightValue.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String healthProfileWeightValue(int value);

  /// No description provided for @healthProfileConditionsSection.
  ///
  /// In en, this message translates to:
  /// **'Conditions and notes'**
  String get healthProfileConditionsSection;

  /// No description provided for @healthProfileConditionHypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get healthProfileConditionHypertension;

  /// No description provided for @healthProfileConditionArthritis.
  ///
  /// In en, this message translates to:
  /// **'Osteoarthritis'**
  String get healthProfileConditionArthritis;

  /// No description provided for @healthProfileConditionMemory.
  ///
  /// In en, this message translates to:
  /// **'Mild memory decline'**
  String get healthProfileConditionMemory;

  /// No description provided for @healthProfileAllergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get healthProfileAllergyLabel;

  /// No description provided for @healthProfileAllergyValue.
  ///
  /// In en, this message translates to:
  /// **'No known medication allergies'**
  String get healthProfileAllergyValue;

  /// No description provided for @healthProfileLastCheckupLabel.
  ///
  /// In en, this message translates to:
  /// **'Last checkup'**
  String get healthProfileLastCheckupLabel;

  /// No description provided for @healthProfileLastCheckupValue.
  ///
  /// In en, this message translates to:
  /// **'March 26, 2026'**
  String get healthProfileLastCheckupValue;

  /// No description provided for @healthProfileMedicationSection.
  ///
  /// In en, this message translates to:
  /// **'Medication schedule'**
  String get healthProfileMedicationSection;

  /// No description provided for @healthProfileMedicationMorningLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get healthProfileMedicationMorningLabel;

  /// No description provided for @healthProfileMedicationMorningValue.
  ///
  /// In en, this message translates to:
  /// **'Amlodipine 5mg after breakfast'**
  String get healthProfileMedicationMorningValue;

  /// No description provided for @healthProfileMedicationEveningLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get healthProfileMedicationEveningLabel;

  /// No description provided for @healthProfileMedicationEveningValue.
  ///
  /// In en, this message translates to:
  /// **'Calcium D3 before sleep'**
  String get healthProfileMedicationEveningValue;

  /// No description provided for @healthProfileEmergencySection.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get healthProfileEmergencySection;

  /// No description provided for @healthProfileEmergencyContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact person'**
  String get healthProfileEmergencyContactLabel;

  /// No description provided for @healthProfileEmergencyContactValue.
  ///
  /// In en, this message translates to:
  /// **'Nguyen Minh Tuan (son)'**
  String get healthProfileEmergencyContactValue;

  /// No description provided for @healthProfileEmergencyPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get healthProfileEmergencyPhoneLabel;

  /// No description provided for @healthProfileEmergencyPhoneValue.
  ///
  /// In en, this message translates to:
  /// **'0903 456 789'**
  String get healthProfileEmergencyPhoneValue;

  /// No description provided for @healthProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get healthProfileAddressLabel;

  /// No description provided for @healthProfileAddressValue.
  ///
  /// In en, this message translates to:
  /// **'145 Le Loi, District 1, Ho Chi Minh City'**
  String get healthProfileAddressValue;

  /// No description provided for @notificationCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationCenterTitle;

  /// No description provided for @notificationCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push alerts received on this device.'**
  String get notificationCenterSubtitle;

  /// No description provided for @notificationEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get notificationEmptyMessage;

  /// No description provided for @notificationStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Push status'**
  String get notificationStatusTitle;

  /// No description provided for @notificationRegistrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Backend registration'**
  String get notificationRegistrationLabel;

  /// No description provided for @notificationSubscriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Subscription ID'**
  String get notificationSubscriptionLabel;

  /// No description provided for @notificationUserLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get notificationUserLabel;

  /// No description provided for @notificationStatusWaitingForLogin.
  ///
  /// In en, this message translates to:
  /// **'Waiting for login'**
  String get notificationStatusWaitingForLogin;

  /// No description provided for @notificationStatusWaitingForSubscription.
  ///
  /// In en, this message translates to:
  /// **'Waiting for subscription ID'**
  String get notificationStatusWaitingForSubscription;

  /// No description provided for @notificationStatusRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get notificationStatusRegistered;

  /// No description provided for @notificationStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get notificationStatusFailed;

  /// No description provided for @notificationPopupOpenAction.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get notificationPopupOpenAction;

  /// No description provided for @notificationSourceForeground.
  ///
  /// In en, this message translates to:
  /// **'Foreground'**
  String get notificationSourceForeground;

  /// No description provided for @notificationSourceOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get notificationSourceOpened;

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
