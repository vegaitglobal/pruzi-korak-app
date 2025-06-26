import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/domain/leaderboard/team_leaderboard_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class TeamLeaderboardListItem extends StatelessWidget {
  const TeamLeaderboardListItem({super.key, required this.teamLeaderboardModel, required this.onItemClick});

  final TeamLeaderboardModel teamLeaderboardModel;
  final Function(String) onItemClick;

  @override
  Widget build(BuildContext context) {
    final initial =
        teamLeaderboardModel.teamName.isNotEmpty ? teamLeaderboardModel.teamName[0] : '?';

    return InkWell(
      onTap: () => onItemClick(teamLeaderboardModel.teamId),
      child: Row(
        children: [
          AvatarWithBadge(
            badgePosition: BadgePosition.topLeft,
            badgeSize: BadgeSize.small,
            badgeValue: teamLeaderboardModel.rank,

            child: InitialsAvatar(initial: initial, size: 42),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teamLeaderboardModel.teamName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Roadrunners', // Replace with actual steps count
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          Text(
            teamLeaderboardModel.totalDistance,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
