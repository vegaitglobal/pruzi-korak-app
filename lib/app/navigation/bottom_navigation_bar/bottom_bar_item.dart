import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarIcon extends StatelessWidget {
  const BottomBarIcon({super.key, required this.iconPath, required this.color});

  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(iconPath,
        width: 24.0,
        height: 24.0,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        fit: BoxFit.scaleDown);
  }
}
