import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
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

  final TopThreeLeaderboardModel topThreeLeaderboardModel;
  final List<LeaderboardModel> leaderboardList;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundPrimary,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppHeader(),
          const SizedBox(height: 16.0),
          TeamLeaderboardHeader(
            topThreeLeaderboardModel: topThreeLeaderboardModel,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: InfiniteScrollView(
              itemBuilder: (context, index) {
                final item = TeamLeaderboardListItem(
                  leaderboardModel: leaderboardList[index],
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
                context.read<TeamLeaderboardBloc>().add(LoadTeamLeaderboard());
              },
            ),
          ),
        ],
      ),
    );
  }
}
