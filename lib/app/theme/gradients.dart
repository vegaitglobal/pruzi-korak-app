import 'package:flutter/material.dart';

import 'colors.dart';

class AppGradients {
  static final primaryLabelGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.secondary],
  );
}
