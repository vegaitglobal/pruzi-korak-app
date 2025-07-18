import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/core/events/login_notification_event.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/core/session/session_listener.dart';
import 'package:pruzi_korak/data/health_data/health_repository.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/data/notification/local_notification_handler.dart';
import 'package:pruzi_korak/data/permissions/permissions_service.dart';
import 'package:pruzi_korak/domain/auth/auth_repository.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/features/campaign_message/bloc/campaign_message_bloc.dart';
import 'package:pruzi_korak/features/home/bloc/home_bloc.dart';
import 'package:pruzi_korak/features/about_organization/bloc/about_organization_bloc.dart';
import 'package:pruzi_korak/features/about_pruzi_korak/bloc/about_pruzi_korak_bloc.dart';
import 'package:pruzi_korak/features/login/bloc/login_bloc.dart'
    hide LoginEvent;
import 'package:pruzi_korak/features/profile/bloc/profile_bloc.dart';
import 'package:pruzi_korak/features/splash/bloc/splash_bloc.dart';
import 'package:pruzi_korak/features/team_leaderboard/bloc/team_leaderboard_bloc.dart';
import 'package:pruzi_korak/features/team_leaderboard/details/bloc/team_details_bloc.dart';
import 'package:pruzi_korak/features/user_leaderboard/bloc/user_leaderboard_bloc.dart';
import 'package:pruzi_korak/features/motivational_message/motivational_message_bloc.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/data/profile/profile_repository.dart';

import 'navigation/navigation_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isNotificationScheduled = false;
  late StreamSubscription _loginSubscription;
  late LoginNotificationEvent _loginNotificationEvent;

  @override
  void initState() {
    super.initState();

    _loginNotificationEvent = getIt<LoginNotificationEvent>();

    // Listen for login events to schedule notifications
    _loginSubscription = _loginNotificationEvent.stream.listen(
      _handleLoginEvent,
    );

    // Check for already logged in user to schedule notifications
    _scheduleNotificationsIfLoggedIn();
  }

  @override
  void dispose() {
    _loginSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) => SplashBloc(
            getIt<AuthRepository>(),
            getIt<PermissionsService>(),
          ),
        ),
        BlocProvider<LoginBloc>(
          create:
              (context) => LoginBloc(
                getIt<AuthRepository>(),
                getIt<LoginNotificationEvent>(),
              ),
        ),
        BlocProvider<HomeBloc>(
          create:
              (context) => HomeBloc(
                getIt<HomeRepository>(),
                healthRepository: HealthRepository(),
              ),
        ),
        BlocProvider<ProfileBloc>(
          create:
              (context) => ProfileBloc(
                getIt<ProfileRepository>(),
                getIt<AppLocalStorage>(),
                getIt<AuthRepository>(),
              ),
        ),
        BlocProvider<UserLeaderboardBloc>(
          create:
              (context) => UserLeaderboardBloc(getIt<LeaderboardRepository>()),
        ),
        BlocProvider<TeamLeaderboardBloc>(
          create:
              (context) => TeamLeaderboardBloc(getIt<LeaderboardRepository>()),
        ),
        BlocProvider<TeamDetailsBloc>(create: (context) => TeamDetailsBloc(
          leaderboardRepository: getIt<LeaderboardRepository>()
        )),
        BlocProvider<AboutPruziKorakBloc>(
          create:
              (context) => AboutPruziKorakBloc(getIt<OrganizationRepository>()),
        ),
        BlocProvider<AboutOrganizationBloc>(
          create:
              (context) =>
                  AboutOrganizationBloc(getIt<OrganizationRepository>()),
        ),
        BlocProvider<MotivationalMessageBloc>(
          create: (context) => getIt<MotivationalMessageBloc>(),
        ),
        BlocProvider<CampaignMessageBloc>(
          create:
              (context) =>
                  CampaignMessageBloc(getIt<OrganizationRepository>()),
        ),
      ],

      // SessionListener will handle session expiration and logout, if not needed, we should remove it.
      child: SessionListener(
        router: router,
        child: MaterialApp.router(
          title: 'Pruži korak',
          supportedLocales: const [Locale('sr', 'Latn')],

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundPrimary,
          ),
          routerConfig: router,
        ),
      ),
    );
  }

  // MARK: Notification handling

  void _handleLoginEvent(LoginEvent event) {
    if (event == LoginEvent.loginSuccess) {
      AppLogger.logDebug('Login successful, scheduling notifications');
      _scheduleNotificationsIfLoggedIn();
    } else if (event == LoginEvent.logout) {
      AppLogger.logDebug('User logged out, resetting notification state');
      setState(() {
        _isNotificationScheduled = false;
      });
      getIt<LocalNotificationHandler>().cancelAllNotifications();
    }
  }

  void _scheduleNotificationsIfLoggedIn() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isNotificationScheduled) {
        getIt<AuthRepository>().isLoggedIn().then((isLoggedIn) {
          if (isLoggedIn) {
            _scheduleNotificationsIfNeeded();
          }
        });
      }
    });
  }

  void _scheduleNotificationsIfNeeded() {
    if (_isNotificationScheduled) return;

    _isNotificationScheduled = true;
    final context = navigatorKey.currentContext;
    if (context != null) {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        getIt<LocalNotificationHandler>().scheduleMotivationalNotification(
          title: localizations.motivation_notification_title,
          body: localizations.motivation_notification_body,
        );
      }
    }
  }
}

