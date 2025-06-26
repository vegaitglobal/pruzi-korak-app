import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

/// A widget that wraps content and configures status bar appearance
///
/// This wrapper allows different screens to have their own status bar style
/// without changing the global app configuration.
class StatusBarWrapper extends StatelessWidget {
  const StatusBarWrapper({
    super.key,
    required this.child,
    this.statusBarColor = Colors.transparent,
    this.statusBarIconBrightness = Brightness.dark,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The color of the status bar.
  final Color statusBarColor;

  /// The brightness of status bar icons.
  final Brightness statusBarIconBrightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
      child: child,
    );
  }

  /// Factory method to create a StatusBarWrapper with primary color
  factory StatusBarWrapper.primary({required Widget child}) {
    return StatusBarWrapper(
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light, // Light icons for contrast on dark background
      child: child,
    );
  }

  /// Factory method to create a StatusBarWrapper with background color
  factory StatusBarWrapper.background({required Widget child}) {
    return StatusBarWrapper(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Dark icons for contrast on light background
      child: child,
    );
  }
}
