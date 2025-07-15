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
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                StepsCircleComponent(
                  text: stepsModel.steps,
                  iconPath: AppIcons.icStep,
                  color: AppColors.primary,
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
            VerticalDivider(
              width: 1, // Divider thickness
              color: AppColors.primary, // Divider color
            ),
            Column(
              children: [
                StepsCircleComponent(
                  text: stepsModel.totalSteps,
                  iconPath: AppIcons.icPlusPrimary,
                  color: AppColors.primary,
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
          ],
        ),
      ),
    );
  }
}
