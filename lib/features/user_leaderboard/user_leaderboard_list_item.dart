import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';

class UserLeaderboardListItem extends StatelessWidget {
  const UserLeaderboardListItem({
    super.key,
    required this.userModel,
    required this.badgeValue,
    required this.distanceNum,
  });

  final UserModel userModel;
  final String badgeValue;
  final String distanceNum;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarWithBadge(
          badgePosition: BadgePosition.topLeft,
          badgeSize: BadgeSize.small,
          badgeValue: badgeValue,
          child: UserAvatarImage(imageUrl: userModel.imageUrl, size: 42),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userModel.fullName,
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
          distanceNum,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
