import 'package:flutter/material.dart';

import 'colors.dart';

class AppGradients {
  static final primaryLabelGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.secondary],
  );

  static final backgroundLinearGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      AppColors.primary,
      AppColors.primary,
      AppColors.primaryVariant,
    ],
    stops: const [0.0, 0.3, 1.0],
  );
}
