import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/shared_ui/util/num_extension.dart';

class LeaderboardModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String distance;
  final String teamName;
  final String rank;
  final String? imageUrl;

  const LeaderboardModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.teamName,
    required this.distance,
    required this.rank,
    this.imageUrl,
  });

  factory LeaderboardModel.fromJson(
    Map<String, dynamic> json, {
    required String rank,
  }) {
    final firstName = json['first_name'] ?? '';
    final lastName = json['last_name'] ?? '';
    final teamName = json['team_name'] ?? '';

    return LeaderboardModel(
      id: (json['id'] ?? json['user_id']) as String,
      firstName: firstName,
      lastName: lastName,
      teamName: teamName,
      distance: ((json['total_distance'] ?? 0) as num).toTwoDecimalString(),
      rank: rank,
      imageUrl: json['image_url'],
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, distance, rank, imageUrl];
}
