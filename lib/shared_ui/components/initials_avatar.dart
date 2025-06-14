import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initial,
    required this.size,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
  });

  final String initial;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      alignment: Alignment.center,
      child: Text(
        initial.toUpperCase(),
        style: TextStyle(
          fontSize: size * 0.5,
          color: textColor,
        ),
      ),
    );
  }
}