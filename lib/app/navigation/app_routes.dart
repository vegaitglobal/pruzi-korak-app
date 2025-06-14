enum AppRoutes {
  splash,
  login,
  home,
  userLeaderboard,
  profile,
  aboutCompany,
  about,
}

extension AppRoutesExtension on AppRoutes {
  String path() => switch (this) {
        AppRoutes.splash => '/',
        AppRoutes.login => '/login',
        AppRoutes.home => '/home',
        AppRoutes.userLeaderboard => '/user_leaderboard',
        AppRoutes.profile => '/profile',
        AppRoutes.aboutCompany => '/about-company',
        AppRoutes.about => '/about',
      };
}
