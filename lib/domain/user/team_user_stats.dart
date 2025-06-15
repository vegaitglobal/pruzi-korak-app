class TeamUserStats {
  final String userToday;
  final String userTotal;
  final String teamToday;
  final String teamTotal;

  const TeamUserStats({
    required this.userToday,
    required this.userTotal,
    required this.teamToday,
    required this.teamTotal,
  });

  factory TeamUserStats.fromJson(Map<String, dynamic> json) {
    return TeamUserStats(
      userToday: (json['user_today'] ?? 0).toString(),
      userTotal: (json['user_total'] ?? 0).toString(),
      teamToday: (json['team_today'] ?? 0).toString(),
      teamTotal: (json['team_total'] ?? 0).toString(),
    );
  }
}
