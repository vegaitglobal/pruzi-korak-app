enum AppRoutes {
  splash,
  login,
  home,
  statistic,
  profile,
  aboutCompany,
  about,
  organizationMessage,
  splashOrganization
}

extension AppRoutesExtension on AppRoutes {
  String path() => switch (this) {
        AppRoutes.splash => '/',
        AppRoutes.login => '/login',
        AppRoutes.home => '/home',
        AppRoutes.statistic => '/statistic',
        AppRoutes.profile => '/profile',
        AppRoutes.aboutCompany => '/about-company',
        AppRoutes.about => '/about',
        AppRoutes.organizationMessage => '/organization-message',
        AppRoutes.splashOrganization => '/splash-organization'
      };
}
