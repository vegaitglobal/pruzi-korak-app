import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Pruži korak'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Pokušaj ponovo'**
  String get retry;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'Unesite vasu email adresu'**
  String get email_hint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Lozinka'**
  String get password;

  /// No description provided for @password_hint.
  ///
  /// In en, this message translates to:
  /// **'Unesite vasu lozinku'**
  String get password_hint;

  /// No description provided for @login_message.
  ///
  /// In en, this message translates to:
  /// **'Unesi svoju email adresu da se uloguješ u aplikaciju'**
  String get login_message;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Uloguj se'**
  String get log_in;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Uneta adresa nije pronađena. Pokušaj ponovo.'**
  String get login_error;

  /// No description provided for @continue_to_app.
  ///
  /// In en, this message translates to:
  /// **'Nastavi u aplikaciju'**
  String get continue_to_app;

  /// No description provided for @distance_today.
  ///
  /// In en, this message translates to:
  /// **'Prepešačeno danas'**
  String get distance_today;

  /// No description provided for @distance_total.
  ///
  /// In en, this message translates to:
  /// **'Ukupno prepešačeno'**
  String get distance_total;

  /// No description provided for @participant_ranking.
  ///
  /// In en, this message translates to:
  /// **'Rangiranje učesnika'**
  String get participant_ranking;

  /// No description provided for @team_ranking.
  ///
  /// In en, this message translates to:
  /// **'Rangiranje timova'**
  String get team_ranking;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Odjavi se'**
  String get log_out;

  /// No description provided for @delete_profile.
  ///
  /// In en, this message translates to:
  /// **'Obriši profil'**
  String get delete_profile;

  /// No description provided for @leaving_us_title.
  ///
  /// In en, this message translates to:
  /// **'Napuštaš nas?'**
  String get leaving_us_title;

  /// No description provided for @leaving_us_message.
  ///
  /// In en, this message translates to:
  /// **'Da li sigurno želiš da obrišeš svoj profil? Sve informacije i tvoj učinak će biti obrisani.'**
  String get leaving_us_message;

  /// No description provided for @quit.
  ///
  /// In en, this message translates to:
  /// **'Odustani'**
  String get quit;

  /// No description provided for @permanently_delete_profile.
  ///
  /// In en, this message translates to:
  /// **'Trajno obrišite profil?'**
  String get permanently_delete_profile;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'ČESTITAMO!'**
  String get congrats;

  /// No description provided for @congrats_message.
  ///
  /// In en, this message translates to:
  /// **'Upravo ste prešli'**
  String get congrats_message;

  /// No description provided for @stepsToday.
  ///
  /// In en, this message translates to:
  /// **'Prepešačeno danas'**
  String get stepsToday;

  /// No description provided for @stepsTotal.
  ///
  /// In en, this message translates to:
  /// **'Ukupno\nprepešačeno'**
  String get stepsTotal;

  /// No description provided for @password_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Neispravan format šifre'**
  String get password_validation_error;

  /// No description provided for @email_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Neispravan format email adrese'**
  String get email_validation_error;

  /// No description provided for @unexpected_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Došlo je do neočekivane greške!'**
  String get unexpected_error_occurred;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
