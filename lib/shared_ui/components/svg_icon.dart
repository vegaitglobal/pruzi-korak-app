import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
      {super.key, required this.iconPath, this.color, this.size = 20.0});

  final String iconPath;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.primary,
        BlendMode.srcIn,
      ),
      fit: BoxFit.scaleDown,
    );
  }
}
