import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  const ClickableText(
      {super.key,
      required this.text,
      required this.textColor,
      required this.fontSize,
      required this.onPressed});

  final String text;
  final Color textColor;
  final double fontSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
          onTap: onPressed,
          child: Text(text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize, // Optional: to indicate it's clickable
              ))),
    );
  }
}
