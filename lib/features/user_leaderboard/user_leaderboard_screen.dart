import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_header.dart';
import 'package:pruzi_korak/features/user_leaderboard/user_leaderboard_list_item.dart' show UserLeaderboardListItem;
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
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
        switch (state) {
          case UserLeaderboardLoading():
            return AppLoader();
          case UserLeaderboardLoaded(stepsList: final stepsList):
            return UserLeaderboardSection();
          case UserLeaderboardError(errorMessage: final errorMessage):
            return Center(child: Text('Error: $errorMessage'));
          default:
            return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class UserLeaderboardSection extends StatelessWidget {
  const UserLeaderboardSection({super.key});

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
          UserLeaderboardHeader(),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Replace with actual count
              itemBuilder: (context, index) {
                // Replace with actual user data
                return UserLeaderboardListItem(
                  userModel: UserModel(
                    id: 'user_$index',
                    fullName: 'User $index',
                    imageUrl: AppConstants.TEST_IMAGE,
                  ),
                  badgeValue: '${index + 1}',
                  distanceNum: '${(30 - index).toString()} km',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
