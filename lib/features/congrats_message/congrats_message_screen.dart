// lib/features/motivation/motivational_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class CongratsMessageScreen extends StatelessWidget {
  const CongratsMessageScreen({super.key});

  /// Dynamic value passed from the caller (e.g. 25.0)
  final double distanceKm = 25;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ───────────────── HEADER ────────────────────────────────
            const Padding(
              padding: EdgeInsets.all(16),
              child: AppHeader(),
            ),

            // ───── CENTRAL FLAG-BLOCK ────────────────────────────────
            Expanded(
              child: ClipPath(
                clipper: _FlagWaveClipper(), // talasasti rubovi
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF5FD198), // light
                        Color(0xFF00ABA7), // dark
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Trophy icon
                          AppSvgIcon(
                            iconPath: AppIcons.trophy,
                            size: 120,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 40),
                          // "ČESTITAMO!"
                          Text(
                            loc.congrats, // "ČESTITAMO!"
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 34,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // "Upravo ste prešli 25 km"
                          Text(
                            '${loc.congrats_message} ${distanceKm.toStringAsFixed(0)} ${loc.km}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 22,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ───── BUTTON ────────────────────────────────────────────
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: loc.continue_to_app,
                  onPressed: () => context.go(AppRoutes.home.path()),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────
// ClipPath za gornji + donji plitki talas (isti oblik kao na motivacionoj strani)
// ───────────────────────────────────────────────────────────────────────
class _FlagWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.10); // viši početak – izraženija zastava

    // gornji talas (0 → 50 %) sa većom amplitudom
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.03,
      size.width * 0.5,  size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.13,
      size.width,        size.height * 0.05,
    );

    // desni rub
    path.lineTo(size.width, size.height * 0.85); // niži baseline donjeg talasa

    // donji talas (50 % → 0) – ogledalo gornjeg
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.93,
      size.width * 0.5,  size.height * 0.88,
    );
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.83,
      0,                 size.height * 0.90,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ----------------------------------------------------------------------
// Talasasti isječak – gornji blagi luk & donji blagi luk
// ----------------------------------------------------------------------
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.10); // niži početak (tanja amplituda)

    // gornji talas (0 → 50 %)
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.03,
      size.width * 0.5,  size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.13,
      size.width,        size.height * 0.05,
    );

    // desni rub на dnu
    path.lineTo(size.width, size.height * 0.85); // viši baseline donjeg talasa

    // donji talas (50 % → 0)
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.93,
      size.width * 0.5,  size.height * 0.88,
    );
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.83,
      0,                 size.height * 0.90,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}