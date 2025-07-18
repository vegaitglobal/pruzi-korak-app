import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/core/constants/icons.dart';

import 'bottom_bar_item.dart';

class AppBottomNavigationPage extends StatefulWidget {
  const AppBottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<AppBottomNavigationPage> createState() =>
      _AppBottomNavigationPageState();
}

class _AppBottomNavigationPageState extends State<AppBottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    final activeIconColor = AppColors.primary;
    final iconColor = AppColors.textSecondary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.backgroundPrimary,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 4,
              decoration: getStatusBarBackgroundForIndex(
                widget.child.currentIndex,
              ),
            ),
            SafeArea(child: widget.child),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: AppGradients.primaryLinearGradient,
              ),
            ),
            BottomNavigationBar(
              selectedItemColor: activeIconColor,
              unselectedItemColor: iconColor,
              backgroundColor: AppColors.backgroundPrimary,
              type: BottomNavigationBarType.fixed,
              currentIndex: widget.child.currentIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                widget.child.goBranch(
                  index,
                  initialLocation: index == widget.child.currentIndex,
                );
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                  icon: Semantics(
                    identifier: "bottom_bar_item_home_inactive",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icHome,
                      color: iconColor,
                    ),
                  ),
                  activeIcon: Semantics(
                    identifier: "bottom_bar_item_home_active",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icHome,
                      color: activeIconColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    identifier: "bottom_bar_item_statistics_inactive",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icStatistic,
                      color: iconColor,
                    ),
                  ),
                  activeIcon: Semantics(
                    identifier: "bottom_bar_item_statistics_active",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icStatistic,
                      color: activeIconColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: BottomBarIcon(
                    iconPath: AppIcons.icTeamLeaderboard,
                    color: iconColor,
                  ),
                  activeIcon: BottomBarIcon(
                    iconPath: AppIcons.icTeamLeaderboard,
                    color: activeIconColor,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    identifier: "bottom_bar_item_profile_inactive",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icProfile,
                      color: iconColor,
                    ),
                  ),
                  activeIcon: Semantics(
                    identifier: "bottom_bar_item_profile_active",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icProfile,
                      color: activeIconColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    identifier: "bottom_bar_item_about_inactive",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icAbout,
                      color: iconColor,
                    ),
                  ),
                  activeIcon: Semantics(
                    identifier: "bottom_bar_item_about_active",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icAbout,
                      color: activeIconColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    identifier: "bottom_bar_item_logo_inactive",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icLogo,
                      color: iconColor,
                    ),
                  ),
                  activeIcon: Semantics(
                    identifier: "bottom_bar_item_logo_active",
                    child: BottomBarIcon(
                      iconPath: AppIcons.icLogo,
                      color: activeIconColor,
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration getStatusBarBackgroundForIndex(int index) {
    switch (index) {
      case 3:
      case 5:
        return BoxDecoration(gradient: AppGradients.primaryLinearGradient);
      default:
        return const BoxDecoration(color: AppColors.backgroundPrimary);
    }
  }
}
