import 'package:flutter/material.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class ClickableIcon extends StatelessWidget {
  const ClickableIcon(
      {super.key, required this.appSvgIcon, required this.onPressed});

  final AppSvgIcon appSvgIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(onTap: onPressed, child: appSvgIcon),
    );
  }
}
