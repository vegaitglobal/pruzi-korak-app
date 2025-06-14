import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
    required this.imageUrl,
    required this.fullName,
    required this.badgeValue,
  });

  final String imageUrl;
  final String fullName;
  final String badgeValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarWithBadge(
          badgeValue: badgeValue,
          badgeSize: BadgeSize.large,
          badgePosition: BadgePosition.topLeft,
          child: UserAvatarImage(imageUrl: imageUrl, size: 66),
        ),
        const SizedBox(width: 16),
        Text(
          fullName,
          textAlign: TextAlign.left,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
