import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/shared_ui/util/num_extension.dart';

class TeamLeaderboardModel extends Equatable {
  final String teamId;
  final String teamName;
  final String totalDistance;
  final String rank;
  final String? imageUrl;

  const TeamLeaderboardModel({
    required this.teamId,
    required this.teamName,
    required this.totalDistance,
    required this.rank,
    this.imageUrl,
  });

  factory TeamLeaderboardModel.fromJson(
    Map<String, dynamic> json, {
    required String rank,
  }) {
    final teamName = json['team_name'] ?? '';

    return TeamLeaderboardModel(
      teamId: json['team_id'] as String,
      teamName: teamName,
      totalDistance: ((json['total_distance'] ?? 0) as num).toTwoDecimalString(),
      rank: rank,
      imageUrl: json['image_url'],
    );
  }

  @override
  List<Object?> get props => [teamId, teamName, totalDistance, rank, imageUrl];
}
