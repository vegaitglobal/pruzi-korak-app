import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.color = AppColors.primary});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.transparent,
      child: Center(child: CircularProgressIndicator(color: color)),
    );
  }
}
