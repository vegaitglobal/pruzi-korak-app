import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
        padding: const EdgeInsets.all(15.0),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textButton.withOpacity(
            onPressed == null ? 0.5 : 1.0,
          ),
        ),
      ),
    );
  }
}

class AppButtonVariant extends StatelessWidget {
  const AppButtonVariant({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryVariant,
        disabledBackgroundColor: AppColors.primaryVariant.withOpacity(0.5),
        padding: const EdgeInsets.all(15.0),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textPrimary.withOpacity(
            onPressed == null ? 0.5 : 1.0,
          ),
        ),
      ),
    );
  }
}

class AppButtonOutline extends StatelessWidget {
  const AppButtonOutline({super.key, required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2.0, color: AppColors.primary),
          padding: const EdgeInsets.all(10.0),
        ),
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
