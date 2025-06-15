import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';

class TopThreeLeaderboardModel extends Equatable {
  final LeaderboardModel first;
  final LeaderboardModel second;
  final LeaderboardModel third;

  const TopThreeLeaderboardModel({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  List<Object> get props => [first, second, third];
}
