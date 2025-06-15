import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/core/session/session_listener.dart';
import 'package:pruzi_korak/data/health_data/health_repository';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';
import 'package:pruzi_korak/features/home/bloc/home_bloc.dart';
import 'package:pruzi_korak/features/login/bloc/login_bloc.dart';
import 'package:pruzi_korak/features/profile/bloc/profile_bloc.dart';
import 'package:pruzi_korak/features/splash/bloc/splash_bloc.dart';
import 'package:pruzi_korak/features/team_leaderboard/bloc/team_leaderboard_bloc.dart';
import 'package:pruzi_korak/features/user_leaderboard/bloc/user_leaderboard_bloc.dart';

import 'navigation/navigation_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (context) => SplashBloc(getIt<AuthRepository>()),
        ),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(healthRepository: HealthRepository())),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<UserLeaderboardBloc>(create: (context) => UserLeaderboardBloc()),
        BlocProvider<TeamLeaderboardBloc>(create: (context) => TeamLeaderboardBloc()),

      ],

      // SessionListener will handle session expiration and logout, if not needed, we should remove it.
      child: SessionListener(
        router: router,
        child: MaterialApp.router(
          title: 'Pruži Korak',
          supportedLocales: const [Locale('sr', 'Latn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );
  }
}
