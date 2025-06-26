import 'package:equatable/equatable.dart';

class TopThreeLeaderboardModel<T> extends Equatable {
  final T first;
  final T second;
  final T third;

  const TopThreeLeaderboardModel({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  List<Object> get props => [first, second, third] as List<Object>;

  factory TopThreeLeaderboardModel.fromList(List<T> list) {
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
