import 'package:equatable/equatable.dart';

class LeaderboardModel extends Equatable {
  final String id;
  final String name;
  final String steps;
  final String rank;
  final String? imageUrl;

  const LeaderboardModel({
    required this.id,
    required this.name,
    required this.steps,
    required this.rank,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, steps, rank, imageUrl];
}
