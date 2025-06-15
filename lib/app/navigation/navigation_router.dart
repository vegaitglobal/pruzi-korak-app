import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/features/about_organization/about_organization_screen.dart';
import 'package:pruzi_korak/features/about_organization/bloc/about_organization_bloc.dart';
import 'package:pruzi_korak/features/about_pruzi_korak/about_pruzi_korak_screen.dart';
import 'package:pruzi_korak/features/campaign_message/campaign_message_screen.dart';
import 'package:pruzi_korak/features/home/home_screen.dart';
import 'package:pruzi_korak/features/login/login_screen.dart';
import 'package:pruzi_korak/features/profile/profile_screen.dart';
import 'package:pruzi_korak/features/splash/splash_screen.dart';
import 'package:pruzi_korak/features/splash_organization/splash_organization_screen.dart';
import 'package:pruzi_korak/features/team_leaderboard/details/team_details_screen.dart';
import 'package:pruzi_korak/features/team_leaderboard/team_leaderboard_screen.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_screen.dart';

import 'app_routes.dart';
import 'bottom_navigation_bar/app_bottom_navigation_page.dart';

final GlobalKey<NavigatorState> parentNavigatorKey =
    GlobalKey<NavigatorState>();

GoRouter get router => _router;

final _router = GoRouter(
  navigatorKey: parentNavigatorKey,
  initialLocation: AppRoutes.splash.path(),
  routes: [
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutes.splash.path(),
      name: AppRoutes.splash.name,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutes.splashOrganization.path(),
      name: AppRoutes.splashOrganization.name,
      builder: (context, state) {
        return const SplashOrganizationScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutes.login.path(),
      name: AppRoutes.login.name,
      builder: (context, state) {
        return LoginScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutes.organizationMessage.path(),
      name: AppRoutes.organizationMessage.name,
      builder: (context, state) {
        return const CampaignMessageScreen();
      },
    ),

    StatefulShellRoute.indexedStack(
      parentNavigatorKey: parentNavigatorKey,
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home.path(),
              name: AppRoutes.home.name,
              pageBuilder: (context, state) {
                return getPage(child: const HomeScreen(), state: state);
              },
              // Default route for the home tab
              routes: [],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.userLeaderboard.path(),
              name: AppRoutes.userLeaderboard.name,
              pageBuilder: (context, state) {
                return getPage(child: UserLeaderboardScreen(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teamLeaderboard.path(),
              name: AppRoutes.teamLeaderboard.name,
              pageBuilder: (context, state) {
                return getPage(child: TeamLeaderboardScreen(), state: state);
              },
              routes: [
                GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: AppRoutes.teamLeaderboardDetails.path(),
                    name: AppRoutes.teamLeaderboardDetails.name,
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return getPage(
                        child: TeamDetailsScreen(id: id),
                        state: state,
                      );
                    }),
              ]
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile.path(),
              name: AppRoutes.profile.name,
              pageBuilder: (context, state) {
                return getPage(child: ProfileScreen(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.aboutCompany.path(),
              name: AppRoutes.aboutCompany.name,
              pageBuilder: (context, state) {
                return getPage(child: Center(child: const AboutOrganizationScreen()), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.about.path(),
              name: AppRoutes.about.name,
              pageBuilder: (context, state) {
                return getPage(child: Center(child: const AboutPruziKorakScreen()), state: state);
              },
            ),
          ],
        ),
      ],
      pageBuilder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return getPage(
          child: AppBottomNavigationPage(child: navigationShell),
          state: state,
        );
      },
    ),
  ],
);

Page getPage({required Widget child, required GoRouterState state}) {
  return MaterialPage(key: state.pageKey, child: child);
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
  );
}
