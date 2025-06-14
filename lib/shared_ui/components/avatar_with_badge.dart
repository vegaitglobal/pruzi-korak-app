import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';

class AvatarWithBadge extends StatelessWidget {
  const AvatarWithBadge({
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
    final isLarge = badgeSize == BadgeSize.large;

    final double badgePadding = badgeSize == BadgeSize.large ? 10 : 6;
    final double fontSize = badgeSize == BadgeSize.large ? 14 : 12;

    const double offsetLarge = -4;
    const double offsetSmall = 0;

    final double? top = badgePosition == BadgePosition.topLeft
        ? (isLarge ? offsetLarge : offsetLarge)
        : null;

    final double? bottom = badgePosition == BadgePosition.bottomCenter
        ? (isLarge ? offsetLarge : offsetLarge)
        : null;

    final double? left = badgePosition == BadgePosition.topLeft
        ? (isLarge ? offsetLarge : offsetLarge)
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
