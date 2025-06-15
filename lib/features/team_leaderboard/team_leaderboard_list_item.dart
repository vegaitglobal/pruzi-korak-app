import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class TeamLeaderboardListItem extends StatelessWidget {
  const TeamLeaderboardListItem({super.key, required this.leaderboardModel});

  final LeaderboardModel leaderboardModel;

  @override
  Widget build(BuildContext context) {
    final initial =
        leaderboardModel.name.isNotEmpty ? leaderboardModel.name[0] : '?';

    const String teamName = 'Roadrunners';

    return Row(
      children: [
        AvatarWithBadge(
          badgePosition: BadgePosition.topLeft,
          badgeSize: BadgeSize.small,
          badgeValue: leaderboardModel.rank,

          child: InitialsAvatar(initial: initial, size: 42),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              leaderboardModel.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              teamName,
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        Text(
          leaderboardModel.steps,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
