import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/shared_ui/components/card_component.dart';

class HomeUserSection extends StatelessWidget {
  const HomeUserSection({super.key, required this.stepsModel});

  final StepsModel stepsModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CardComponent(
          stepsCount: stepsModel.steps,
          description: AppLocalizations.of(context)!.distance_today,
          iconPath: AppIcons.icStep,
        ),
        CardComponent(
          stepsCount: stepsModel.totalSteps,
          description: AppLocalizations.of(context)!.distance_total,
          iconPath: AppIcons.icPlusVariant,
        ),
      ],
    );
  }
}

class HomeTeamSection extends StatelessWidget {
  const HomeTeamSection({super.key, required this.stepsModel});

  final StepsModel stepsModel;

  @override
  Widget build(BuildContext context) {
    // Calculate responsive circle size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenWidth * 0.3; // Slightly larger circle size (30% of width)

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                StepsCircleComponent(
                  text: stepsModel.steps,
                  iconPath: AppIcons.icStep,
                  color: AppColors.primary,
                  size: circleSize,
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.distance_today,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 24,
            thickness: 1,
            color: AppColors.primary,
          ),
          Expanded(
            child: Column(
              children: [
                StepsCircleComponent(
                  text: stepsModel.totalSteps,
                  iconPath: AppIcons.icPlusPrimary,
                  color: AppColors.primary,
                  size: circleSize,
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.distance_total,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
