import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/shared_ui/components/avatar_with_badge.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
    required this.fullName,
    required this.badgeValue,
  });

  final String fullName;
  final String? badgeValue;

  @override
  Widget build(BuildContext context) {
    final initial =
        fullName.isNotEmpty ? fullName[0] : '?';

    return Row(
      children: [
        _buildAvatar(initial),
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

  Widget _buildAvatar(String initial) {
    if (badgeValue == null) {
      return InitialsAvatar(initial: initial, size: 66);
    }
    return AvatarWithBadge(
      badgeValue: badgeValue!,
      badgeSize: BadgeSize.large,
      badgePosition: BadgePosition.topLeft,
      child: InitialsAvatar(initial: initial, size: 66),
    );
  }
}