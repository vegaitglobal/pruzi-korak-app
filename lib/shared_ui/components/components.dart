import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleImage extends StatelessWidget {
  const CircleImage({
    super.key,
    required this.imagePath,
    required this.iconColor,
    required this.backgroundColor,
    this.size = 24,
  });

  final String imagePath;
  final double size;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: backgroundColor,
        width: size,
        height: size,
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class CircleText extends StatelessWidget {
  const CircleText(
      {super.key,
      required this.text,
      required this.textStyle,
      required this.backgroundColor,
      this.size = 24});

  final String text;
  final TextStyle textStyle;
  final double size;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: backgroundColor,
        width: size,
        height: size,
        child: Center(
            child: Text(text, style: textStyle, textAlign: TextAlign.center)),
      ),
    );
  }
}
