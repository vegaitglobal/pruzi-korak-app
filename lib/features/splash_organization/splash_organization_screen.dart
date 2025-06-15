import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';
import 'dart:math' as math;

class SplashOrganizationScreen extends StatelessWidget {
  const SplashOrganizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This URL can be easily replaced when implementing actual data fetching
    const String partnerLogoUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMQJIvdAWXjzmThRBeIyvFbxP4Bs6ekmuRog&s";
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Top wave
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: TopWavePainter(),
              size: const Size(double.infinity, 150),
            ),
          ),
          
          // Bottom wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: BottomWavePainter(),
              size: const Size(double.infinity, 150),
            ),
          ),
          
          // Main content with logos
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First logo - App Logo Large
                const AppSvgIcon(
                  iconPath: AppIcons.appLogoLarge,
                  size: 150,
                  color: AppColors.primary,
                ),
                
                const SizedBox(height: 60), // raised bottom logo by 40 px
                
                // Second logo - Partner Logo (dynamically loaded)
                const CachedImage(
                  imageUrl: partnerLogoUrl,
                  width: 200,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the top wave
class TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppGradients.backgroundLinearGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Desired: left edge ≈150 px, right edge ≈50 px (gentle rise).
    const amplitudePx = 50.0;               // 2·A drop = 100 → 150‑100 = 50 px
    const leftY = 150.0;                    // y at x = 0
    final verticalShift = leftY - amplitudePx; // cos(0)=1 → leftY
    final amplitude = amplitudePx;

    final path = Path()..moveTo(0, leftY);

    // sample the half‑cosine curve
    const samples = 60;
    for (int i = 1; i <= samples; i++) {
      final x = size.width * i / samples;
      final y = verticalShift + amplitude * math.cos(math.pi * x / size.width);
      path.lineTo(x, y);
    }

    // close to top
    path
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the bottom wave
class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFF5FD198), // light green
          Color(0xFF00ABA7), // dark teal
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    // Gornji talas: cos poluperiod, po­činje na 150, završava 50.
    // Donji treba obrnuto: počinje na h-50, završava na h-150.
    const amplitudePx = 50.0;          // isto A kao gore
    final verticalShift = size.height - 140.0; // baseline h-140  (shift up additional 20)

    final path = Path()..moveTo(0, verticalShift + amplitudePx); // h‑90 (was h‑70)

    const samples = 60;
    for (int i = 1; i <= samples; i++) {
      final x = size.width * i / samples;
      // PLUS cos → obrnut profil
      final y = verticalShift +
          amplitudePx * math.cos(math.pi * x / size.width);
      path.lineTo(x, y);
    }

    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
