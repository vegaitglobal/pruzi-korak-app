import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';

class AvatarWithBadge extends StatelessWidget {
  const AvatarWithBadge({
    super.key,
    required this.badgeValue,
    this.badgeSize = BadgeSize.small,
    this.badgePosition = BadgePosition.bottomCenter,
    this.imageUrl,
    this.initial,
    required this.size,
  });

  final String badgeValue;
  final BadgeSize badgeSize;
  final BadgePosition badgePosition;
  final String? imageUrl;
  final String? initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AvatarWithBadgeContainer(
      badgePosition: badgePosition,
      badgeSize: badgeSize,
      badgeValue: badgeValue,
      child: imageUrl != null
          ? UserAvatarImage(
              imageUrl: imageUrl!,
              size: size,
            )
          : InitialsAvatar(initial: initial ?? '?', size: size),
    );
  }
}

class AvatarWithBadgeContainer extends StatelessWidget {
  const AvatarWithBadgeContainer({
    super.key,
    required this.child,
    required this.badgeValue,
    this.badgeSize = BadgeSize.small,
    this.badgePosition = BadgePosition.bottomCenter,
  });

  final Widget child;
  final String badgeValue;
  final BadgeSize badgeSize;
  final BadgePosition badgePosition;

  @override
  Widget build(BuildContext context) {

    final double badgePadding = badgeSize == BadgeSize.large ? 10 : 6;
    final double fontSize = badgeSize == BadgeSize.large ? 14 : 12;

    const double offsetLeft = -4;
    const double offsetBottom = -12;

    final double? top = badgePosition == BadgePosition.topLeft
        ? offsetLeft
        : null;

    final double? bottom = badgePosition == BadgePosition.bottomCenter
        ? offsetBottom
        : null;

    final double? left = badgePosition == BadgePosition.topLeft
        ? offsetLeft
        : null;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top,
          bottom: bottom,
          left: left,
          child: Container(
            padding: EdgeInsets.all(badgePadding),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primaryLinearGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              badgeValue,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum BadgePosition { topLeft, bottomCenter }

enum BadgeSize { small, large }
