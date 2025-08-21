import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class CardComponent extends StatelessWidget {
  const CardComponent({
    super.key,
    required this.stepsCount,
    required this.description,
    required this.iconPath,
  });

  final String stepsCount;
  final String description;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    // Get screen width to make component responsive
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive width and height with larger percentages
    final cardWidth = (screenWidth - 54) * 0.48; // 48% of available width with less padding reduction
    final cardHeight = cardWidth * 1.25; // Keep the aspect ratio (1.25 is close to original 200/160 ratio)

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: AppColors.backgroundPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipPath(
              clipper: TopClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppGradients.primaryLinearGradient,
                ),
                child: Center(
                  child: StepsCircleComponent(
                    text: stepsCount,
                    iconPath: iconPath,
                    color: AppColors.backgroundPrimary,
                    size: cardWidth * 0.62, // Scale circle relative to card width
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepsCircleComponent extends StatelessWidget {
  const StepsCircleComponent({
    super.key,
    required this.text,
    required this.iconPath,
    required this.color,
    this.size = 100,
  });

  final String text;
  final String iconPath;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(iconPath: iconPath, color: color, size: size * 0.2),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Text(
                text,
                key: ValueKey<String>(text),
                style: AppTextStyles.labelMedium.copyWith(
                  color: color,
                  fontSize: size * 0.16, // Scale text with circle size
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.km,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontSize: size * 0.12, // Scale text with circle size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
