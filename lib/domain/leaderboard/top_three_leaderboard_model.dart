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

  factory TopThreeLeaderboardModel.fromList(List<LeaderboardModel> list) {
    if (list.length < 3) {
      throw Exception('Leaderboard list must contain at least 3 entries');
    }

    return TopThreeLeaderboardModel(
      first: list[0],
      second: list[1],
      third: list[2],
    );
  }
}
