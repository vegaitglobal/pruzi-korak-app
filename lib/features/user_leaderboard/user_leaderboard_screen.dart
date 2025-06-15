import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/domain/leaderboard/leaderboard_model.dart';
import 'package:pruzi_korak/domain/leaderboard/top_three_leaderboard_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_header.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_list_item.dart'
    show UserLeaderboardListItem;
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/infinite_scroll_view.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';

import 'bloc/user_leaderboard_bloc.dart';

class UserLeaderboardScreen extends StatefulWidget {
  const UserLeaderboardScreen({super.key});

  @override
  State<UserLeaderboardScreen> createState() => _UserLeaderboardScreenState();
}

class _UserLeaderboardScreenState extends State<UserLeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLeaderboardBloc, UserLeaderboardState>(
      builder: (context, state) {
        return switch (state) {
          UserLeaderboardLoading() => AppLoader(),
          UserLeaderboardLoaded() => UserLeaderboardSection(
            topThreeLeaderboardModel: state.topThreeLeaderboardModel,
            leaderboardList: state.leaderboardList,
          ),
          UserLeaderboardEmpty() => Center(child: Text("No data available")),
          UserLeaderboardError() => ErrorComponent(
            errorMessage: "Error loading leaderboard",
            onRetry: () {
              context.read<UserLeaderboardBloc>().add(LoadUserLeaderboard());
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
          UserLeaderboardHeader(
            topThreeLeaderboardModel: topThreeLeaderboardModel,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: InfiniteScrollView(
              itemBuilder: (context, index) {
                final item = UserLeaderboardListItem(
                  leaderboardModel: leaderboardList[index],
                );
                final hasDivider = index < leaderboardList.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: item,
                    ),
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
                context.read<UserLeaderboardBloc>().add(LoadUserLeaderboard());
              },
            ),
          ),
        ],
      ),
    );
  }
}
