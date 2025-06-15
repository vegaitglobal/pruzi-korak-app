import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';


class UserLeaderboardHeader extends StatelessWidget {
  const UserLeaderboardHeader({
    super.key,
    required this.topThreeLeaderboardModel,
  });

  final TopThreeLeaderboardModel topThreeLeaderboardModel;

  @override
  Widget build(BuildContext context) {
    final first = topThreeLeaderboardModel.first;
    final second = topThreeLeaderboardModel.second;
    final third = topThreeLeaderboardModel.third;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LeaderboardItem(leaderboardModel: second, imageSize: 84),
        const SizedBox(width: 24),
        LeaderboardItem(
          leaderboardModel: first,
          verticalOffset: -20,
          imageSize: 100,
        ),
        const SizedBox(width: 24),
        LeaderboardItem(leaderboardModel: third, imageSize: 84),
      ],
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({
    super.key,
    required this.leaderboardModel,
    required this.imageSize,
    this.verticalOffset = 0,
  });

  final LeaderboardModel leaderboardModel;
  final double verticalOffset;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final initial =
    leaderboardModel.firstName.isNotEmpty ? leaderboardModel.firstName[0] : '?';

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        children: [
          AvatarWithBadge(
            badgePosition: BadgePosition.bottomCenter,
            badgeSize: BadgeSize.large,
            badgeValue: leaderboardModel.rank,
            child: InitialsAvatar(initial: initial, size: imageSize),

          ),
          const SizedBox(height: 16),
          Text(
            '${leaderboardModel.firstName}\n${leaderboardModel.lastName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${leaderboardModel.distance} ${AppLocalizations.of(context)!.km}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
