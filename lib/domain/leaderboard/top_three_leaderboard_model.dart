import 'package:equatable/equatable.dart';

class TopThreeLeaderboardModel<T> extends Equatable {
  final T first;
  final T? second;
  final T? third;

  const TopThreeLeaderboardModel({
    required this.first,
    this.second,
    this.third,
  });

  @override
  List<Object?> get props => [first, second, third];

  factory TopThreeLeaderboardModel.fromList(List<T> list) {
    if (list.isEmpty) {
      throw Exception('Leaderboard list must contain at least 1 entry');
    }

    return TopThreeLeaderboardModel(
      first: list[0],
      second: list.length > 1 ? list[1] : null,
      third: list.length > 2 ? list[2] : null,
    );
  }
}
