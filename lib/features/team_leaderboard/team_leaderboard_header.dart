import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/leaderboard/team_leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class TeamLeaderboardHeader extends StatelessWidget {
  const TeamLeaderboardHeader({
    super.key,
    required this.topThreeLeaderboardModel,
    required this.onItemClick,
  });

  final TopThreeLeaderboardModel<TeamLeaderboardModel> topThreeLeaderboardModel;
  final Function(String, String) onItemClick;

  @override
  Widget build(BuildContext context) {
    final first = topThreeLeaderboardModel.first;
    final second = topThreeLeaderboardModel.second;
    final third = topThreeLeaderboardModel.third;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          TeamLeaderboardItem(
            leaderboardModel: second,
            imageSize: 84,
            onItemClick: onItemClick,
          ),
        if (second != null) const SizedBox(width: 24),
        TeamLeaderboardItem(
          leaderboardModel: first,
          verticalOffset: -20,
          imageSize: 100,
          onItemClick: onItemClick,
        ),
        if (third != null) const SizedBox(width: 24),
        if (third != null)
          TeamLeaderboardItem(
            leaderboardModel: third,
            imageSize: 84,
            onItemClick: onItemClick,
          ),
      ],
    );
  }
}

class TeamLeaderboardItem extends StatelessWidget {
  const TeamLeaderboardItem({
    super.key,
    required this.leaderboardModel,
    required this.imageSize,
    this.verticalOffset = 0,
    required this.onItemClick,
  });

  final TeamLeaderboardModel leaderboardModel;
  final double verticalOffset;
  final double imageSize;
  final Function(String, String) onItemClick;

  @override
  Widget build(BuildContext context) {
    final initial =
        leaderboardModel.teamName.isNotEmpty
            ? leaderboardModel.teamName[0]
            : '?';
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => onItemClick(
                  leaderboardModel.teamId,
                  leaderboardModel.teamName,
                ),
            child: AvatarWithBadge(
              badgePosition: BadgePosition.bottomCenter,
              badgeSize: BadgeSize.large,
              badgeValue: leaderboardModel.rank,
              child: InitialsAvatar(initial: initial, size: imageSize),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 80,
            height: 32,
            child: Center(
              child: Text(
                leaderboardModel.teamName,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${leaderboardModel.totalDistance} ${AppLocalizations.of(context)!.km}",
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
