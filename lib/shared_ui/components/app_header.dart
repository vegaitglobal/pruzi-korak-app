import 'package:flutter/material.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppSvgIcon(iconPath: AppIcons.appLogo, size: 40),
        CachedImage(
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMQJIvdAWXjzmThRBeIyvFbxP4Bs6ekmuRog&s",
          height: 40.0,
        ),
      ],
    );
  }
}
