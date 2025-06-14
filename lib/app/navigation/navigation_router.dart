import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/features/home/home_screen.dart';
import 'package:pruzi_korak/features/login/login_screen.dart';
import 'package:pruzi_korak/features/campaign_message/campaign_message_screen.dart';
import 'package:pruzi_korak/features/organization_message/organization_message_screen.dart';
import 'package:pruzi_korak/features/profile/profile_screen.dart';
import 'package:pruzi_korak/features/splash/splash_screen.dart';

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
              path: AppRoutes.statistic.path(),
              name: AppRoutes.statistic.name,
              pageBuilder: (context, state) {
                return getPage(child: Center(child: const Text("Statistic")), state: state);
              },
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
                return getPage(child: Center(child: const AboutCompanyScreen()), state: state);
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
                return getPage(child: Center(child: const Text("About")), state: state);
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
