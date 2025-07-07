import 'package:pruzi_korak/shared_ui/util/num_extension.dart';

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
      userToday: ((json['user_today'] ?? 0) as num).toTwoDecimalString(),
      userTotal: ((json['user_total'] ?? 0) as num).toTwoDecimalString(),
      teamToday: ((json['team_today'] ?? 0) as num).toTwoDecimalString(),
      teamTotal: ((json['team_total'] ?? 0) as num).toTwoDecimalString(),
    );
  }
}
