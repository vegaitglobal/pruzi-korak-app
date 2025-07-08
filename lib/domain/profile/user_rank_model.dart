import 'package:equatable/equatable.dart';

class UserRankModel extends Equatable {
  final String teamName;
  final int userRankGlobal;
  final int teamRankGlobal;
  final int userRankTeam;

  const UserRankModel({
    required this.teamName,
    required this.userRankGlobal,
    required this.teamRankGlobal,
    required this.userRankTeam,
  });

  factory UserRankModel.fromJson(Map<String, dynamic> json) {
    return UserRankModel(
      teamName: json['team_name'] ?? '',
      userRankGlobal: json['user_rank_global'] ?? 0,
      teamRankGlobal: json['team_rank_global'] ?? 0,
      userRankTeam: json['user_rank_team'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [teamName, userRankGlobal, teamRankGlobal, userRankTeam];
}

