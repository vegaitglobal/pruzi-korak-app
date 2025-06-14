import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
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
    return SizedBox(
      width: 160,
      height: 200,
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
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
  });

  final String text;
  final String iconPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: color, // Use the provided color for the border
          width: 3, // Adjust border width as needed
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(iconPath: iconPath, color: color, size: 20),
            const SizedBox(height: 4),
            Text(text, style: AppTextStyles.labelMedium.copyWith(color: color)),
            const SizedBox(height: 4),
            Text("km", style: AppTextStyles.bodySmall.copyWith(color: color)),
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
