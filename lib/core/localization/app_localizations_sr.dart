// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appName => 'Pruži korak';

  @override
  String get retry => 'Pokušaj ponovo';

  @override
  String get email => 'Email';

  @override
  String get email_hint => 'Unesite vasu email adresu';

  @override
  String get password => 'Lozinka';

  @override
  String get password_hint => 'Unesite vasu lozinku';

  @override
  String get login_message =>
      'Unesi svoju email adresu da se uloguješ u aplikaciju';

  @override
  String get log_in => 'Uloguj se';

  @override
  String get login_error => 'Uneta adresa nije pronađena. Pokušaj ponovo.';

  @override
  String get continue_to_app => 'Nastavi u aplikaciju';

  @override
  String get distance_today => 'Prepešačeno danas';

  @override
  String get distance_total => 'Ukupno prepešačeno';

  @override
  String get participant_ranking => 'Rangiranje učesnika';

  @override
  String get team_ranking => 'Rangiranje timova';

  @override
  String get log_out => 'Odjavi se';

  @override
  String get delete_profile => 'Obriši profil';

  @override
  String get leaving_us_title => 'Napuštaš nas?';

  @override
  String get leaving_us_message =>
      'Da li sigurno želiš da obrišeš svoj profil? Svi podaci i tvoj učinak će biti obrisani.';

  @override
  String get logout_dialog_title => 'Da li sigurno želiš da se odjaviš?';

  @override
  String get logout_dialog_message =>
      'Tvoji podaci i učinak biće sačuvani i moći ćeš opet da pristupiš svom profilu.';

  @override
  String get quit => 'Odustani';

  @override
  String get permanently_delete_profile => 'Trajno obrišite profil?';

  @override
  String get km => 'km';

  @override
  String get congrats => 'ČESTITAMO!';

  @override
  String get congrats_message => 'Upravo ste prešli';

  @override
  String get stepsToday => 'Prepešačeno danas';

  @override
  String get stepsTotal => 'Ukupno\nprepešačeno';

  @override
  String get password_validation_error => 'Neispravan format šifre';

  @override
  String get email_validation_error => 'Neispravan format email adrese';

  @override
  String get unexpected_error_occurred => 'Došlo je do neočekivane greške!';

  @override
  String get motivation_notification_title => 'Počni dan sa motivacijom';

  @override
  String get motivation_notification_body =>
      'Tvoja dnevna doza inspiracije je stigla. Klikni da pročitaš.';

  @override
  String get logo_placeholder => 'Logo kompanije';

  @override
  String get team_label => 'Tim:';

  @override
  String get team_rank_label => 'Rang tima:';

  @override
  String get user_team_rank_label => 'Tvoj rang u timu:';

  @override
  String get user_global_rank_label => 'Tvoj globalni rang:';

  @override
  String get errorEmailOrPassword =>
      'Uneli ste neispravno korisničko ime ili lozinku';

  @override
  String get errorUnsupportedDevice =>
      'Već ste prijavljeni na drugom uređaju. Odjavite se sa tog uređaja i pokušajte ponovo.';
}
