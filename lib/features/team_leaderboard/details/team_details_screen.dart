import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_list_item.dart';
import 'package:pruzi_korak/shared_ui/components/app_header_gradient.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

import 'bloc/team_details_bloc.dart';

class TeamDetailsScreen extends StatefulWidget {
  const TeamDetailsScreen({super.key, required this.id});

  final String id;

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamDetailsBloc>().add(
      FetchTeamDetailsEvent(teamId: widget.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeamDetailsBloc, TeamDetailsState>(
        builder: (context, state) {
          return switch (state) {
            TeamDetailsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TeamDetailsLoaded() => TeamDetailsLoadedSection(
              totalDistance: state.totalDistance,
              leaderboardList: state.leaderboardList,
            ),
            TeamDetailsError() => ErrorComponent(
              errorMessage: 'Failed to load team details',
              onRetry: () {
                context.read<TeamDetailsBloc>().add(
                  FetchTeamDetailsEvent(teamId: widget.id),
                );
              },
            ),
            TeamDetailsEmpty() => const Center(
              child: Text('No team details available'),
            ),
          };
        },
      ),
    );
  }
}

class TeamDetailsLoadedSection extends StatelessWidget {
  const TeamDetailsLoadedSection({
    super.key,
    required this.totalDistance,
    required this.leaderboardList,
  });

  final String totalDistance;
  final List<LeaderboardModel> leaderboardList;

  @override
  Widget build(BuildContext context) {
    double headerHeight = MediaQuery.of(context).size.height / 2.5;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CurvedHeaderBackground(height: headerHeight),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: StepsCircleComponentDetails(
                    text: totalDistance,
                    iconPath: AppIcons.icStepLarge,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardList.length,
              itemBuilder:
                  (context, index) =>
                      _buildLeaderboardItem(context, leaderboardList, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    List<LeaderboardModel> leaderboardList,
    int index,
  ) {
    final item = UserLeaderboardListItem(
      leaderboardModel: leaderboardList[index],
    );
    final hasDivider = index < leaderboardList.length - 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: item,
        ),
        if (hasDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 16,
              thickness: 1,
              color: AppColors.grayLight,
            ),
          ),
      ],
    );
  }
}

class StepsCircleComponentDetails extends StatelessWidget {
  const StepsCircleComponentDetails({
    super.key,
    required this.text,
    required this.iconPath,
    required this.color,
  });

  final String text;
  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 204,
      height: 204,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: color, width: 5),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(iconPath: iconPath, color: color, size: 38),
            const SizedBox(height: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.km,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
