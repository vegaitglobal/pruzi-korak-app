enum AppRoutes {
  splash,
  login,
  home,
  userLeaderboard,
  teamLeaderboard,
  teamLeaderboardDetails,
  profile,
  aboutCompany,
  about,
  organizationMessage,
  splashOrganization, 
  motivationalMessage,
  congratsMessage
}

extension AppRoutesExtension on AppRoutes {
  String path() => switch (this) {
        AppRoutes.splash => '/',
        AppRoutes.login => '/login',
        AppRoutes.home => '/home',
        AppRoutes.userLeaderboard => '/user_leaderboard',
        AppRoutes.teamLeaderboard => '/team_leaderboard',
        AppRoutes.teamLeaderboardDetails => 'team_leaderboard_details/:id',
        AppRoutes.profile => '/profile',
        AppRoutes.aboutCompany => '/about-company',
        AppRoutes.about => '/about',
        AppRoutes.organizationMessage => '/organization-message',
        AppRoutes.splashOrganization => '/splash-organization',
        AppRoutes.motivationalMessage => '/motivational-message',
        AppRoutes.congratsMessage => '/congrats-message'
      };
}
