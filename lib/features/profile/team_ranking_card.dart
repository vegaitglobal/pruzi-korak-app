import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

import '../../app/theme/app_text_styles.dart';
import '../../core/localization/app_localizations.dart';

class TeamRankingCard extends StatelessWidget {
  const TeamRankingCard({
    super.key,
    required this.teamName,
    required this.teamRank,
    required this.userTeamRank,
    required this.userGlobalRank,
  });

  final String teamName;
  final int teamRank;
  final int userTeamRank;
  final int userGlobalRank;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          _RankingItem(
            icon: Icons.group,
            label: localizations.team_label,
            value: teamName,
          ),
          const Divider(),
          _RankingItem(
            icon: Icons.emoji_events,
            label: localizations.team_rank_label,
            value: '#$teamRank',
          ),
          const Divider(),
          _RankingItem(
            icon: Icons.person,
            label: localizations.user_team_rank_label,
            value: '#$userTeamRank',
          ),
          const Divider(),
          _RankingItem(
            icon: Icons.public,
            label: localizations.user_global_rank_label,
            value: '#$userGlobalRank',
          ),
        ],
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  const _RankingItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.labelLarge,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
