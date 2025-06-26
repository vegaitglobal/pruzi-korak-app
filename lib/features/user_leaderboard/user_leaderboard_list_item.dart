import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class UserLeaderboardListItem extends StatelessWidget {
  const UserLeaderboardListItem({super.key, required this.leaderboardModel});

  final LeaderboardModel leaderboardModel;

  @override
  Widget build(BuildContext context) {
    final initial =
    leaderboardModel.firstName.isNotEmpty ? leaderboardModel.firstName[0] : '?';

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
              '${leaderboardModel.firstName} ${leaderboardModel.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              leaderboardModel.teamName, // Replace with actual steps count
              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        Text(
          leaderboardModel.distance,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
