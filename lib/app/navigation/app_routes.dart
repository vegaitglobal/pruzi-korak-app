enum AppRoutes {
  splashScreen,
  login,
  home,
  statistic,
  profile,
  aboutCompany,
  about,
}

extension AppRoutesExtension on AppRoutes {
  String path() => switch (this) {
        AppRoutes.splashScreen => '/',
        AppRoutes.login => '/login',
        AppRoutes.home => '/home',
        AppRoutes.statistic => '/statistic',
        AppRoutes.profile => '/profile',
        AppRoutes.aboutCompany => '/about-company',
        AppRoutes.about => '/about',
      };
}
