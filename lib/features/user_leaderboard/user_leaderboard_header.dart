import 'package:flutter/material.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';

import '../../app/theme/colors.dart' show AppColors;

class UserLeaderboardHeader extends StatelessWidget {
   UserLeaderboardHeader({super.key});

  final UserModel user1 = UserModel(
    id: "1",
    fullName: "John Doe",
    imageUrl: AppConstants.TEST_IMAGE,

  );

  final UserModel user2 = UserModel(
    id: "2",
    fullName: "Jane Smith",
    imageUrl: AppConstants.TEST_IMAGE,
  );

  final UserModel user3 = UserModel(
    id: "3",
    fullName: "Alice Johnson",
    imageUrl: AppConstants.TEST_IMAGE,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LeaderboardItem(
          userModel: user1,
          badgeValue: "2",
          distanceNum: "27",
          imageSize: 84 ,
        ),
        const SizedBox(width: 24),
        LeaderboardItem(
          userModel: user2,
          badgeValue: "1",
          distanceNum: "29",
          verticalOffset: -20,
          imageSize: 100 ,

        ),
        const SizedBox(width: 24),
        LeaderboardItem(
          userModel: user3,
          badgeValue: "3",
          distanceNum: "25",
          imageSize: 84 ,

        ),
      ],
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  const LeaderboardItem({
    super.key,
    required this.userModel,
    required this.badgeValue,
    required this.distanceNum,
    this.verticalOffset = 0, required this.imageSize,
  });

  final UserModel userModel;
  final String badgeValue;
  final String distanceNum;
  final double verticalOffset;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        children: [
          AvatarWithBadge(
            badgePosition: BadgePosition.bottomCenter,
            badgeSize: BadgeSize.large,
            badgeValue: badgeValue,
            child: UserAvatarImage(imageUrl: userModel.imageUrl, size: imageSize),
          ),
          const SizedBox(width: 16),
          Text(
            userModel.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$distanceNum km",
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

