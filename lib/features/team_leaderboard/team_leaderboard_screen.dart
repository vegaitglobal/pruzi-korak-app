import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/domain/leaderboard/team_leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/features/team_leaderboard/bloc/team_leaderboard_bloc.dart';
import 'package:pruzi_korak/features/team_leaderboard/team_leaderboard_header.dart';
import 'package:pruzi_korak/features/team_leaderboard/team_leaderboard_list_item.dart';
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/infinite_scroll_view.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';

class TeamLeaderboardScreen extends StatefulWidget {
  const TeamLeaderboardScreen({super.key});

  @override
  State<TeamLeaderboardScreen> createState() => _TeamLeaderboardScreenState();
}

class _TeamLeaderboardScreenState extends State<TeamLeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamLeaderboardBloc, TeamLeaderboardState>(
      builder: (context, state) {
        return switch (state) {
          TeamLeaderboardLoading() => AppLoader(),
          TeamLeaderboardLoaded() => UserLeaderboardSection(
            topThreeLeaderboardModel: state.topThreeLeaderboardModel,
            leaderboardList: state.leaderboardList,
          ),
          TeamLeaderboardEmpty() => Center(child: Text("No data available")),
          TeamLeaderboardError() => ErrorComponent(
            errorMessage: "Error loading leaderboard",
            onRetry: () {
              context.read<TeamLeaderboardBloc>().add(LoadTeamLeaderboard());
            },
          ),
        };
      },
    );
  }
}

class UserLeaderboardSection extends StatelessWidget {
  const UserLeaderboardSection({
    super.key,
    required this.leaderboardList,
    required this.topThreeLeaderboardModel,
  });

  final TopThreeLeaderboardModel<TeamLeaderboardModel> topThreeLeaderboardModel;
  final List<TeamLeaderboardModel> leaderboardList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headerComponent(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InfiniteScrollView(
                itemBuilder: (context, index) {
                  final item = TeamLeaderboardListItem(
                    teamLeaderboardModel: leaderboardList[index],
                    onItemClick: (teamId) {
                      context.pushNamed(
                        AppRoutes.teamLeaderboardDetails.name,
                        pathParameters: {'id': teamId},
                        queryParameters: {
                          'teamName': leaderboardList[index].teamName,
                        },
                      );
                    },
                  );
                  final hasDivider = index < leaderboardList.length - 1;
                  return Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(8.0), child: item),
                      if (hasDivider)
                        Divider(
                          height: 16,
                          thickness: 1,
                          color: AppColors.grayLight,
                        ),
                    ],
                  );
                },
                itemCount: leaderboardList.length,
                isLastPage: true,
                loadingEnabled: false,
                fetchMore: () async {
                  //_fetchMoreData();
                },
                onRefresh: () async {
                  context.read<TeamLeaderboardBloc>().add(
                    LoadTeamLeaderboard(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerComponent(BuildContext context) {
    return Container(
      height: Dimension.LEADERBOARD_HEADER_HEIGHT,
      decoration: const BoxDecoration(
        color: AppColors.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppHeader(),
            const SizedBox(height: 16.0),
            TeamLeaderboardHeader(
              topThreeLeaderboardModel: topThreeLeaderboardModel,
              onItemClick: (teamId, teamName) {
                AppLogger.logWarning(
                  "Navigating to team details for ID: $teamId",
                );
                context.pushNamed(
                  AppRoutes.teamLeaderboardDetails.name,
                  pathParameters: {'id': teamId},
                  queryParameters: {'teamName': teamName},
                );
              },
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
