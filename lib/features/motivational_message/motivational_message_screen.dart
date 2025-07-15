import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/features/motivational_message/motivational_message_bloc.dart';

class MotivationalMessageScreen extends StatelessWidget {
  const MotivationalMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MotivationalMessageBloc, MotivationalMessageState>(
          builder: (context, state) {
            return Column(
              children: [
                // ───────────────── HEADER ────────────────────────────────
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: AppHeader(),
                ),
                Expanded(
                  child: ClipPath(
                    clipper: _FlagWaveClipper(),
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
                          child: () {
                            if (state is MotivationalMessageLoading) {
                              return const CircularProgressIndicator();
                            } else if (state is MotivationalMessageLoaded) {
                              final msg = state.message;
                              return Text(
                                '“${msg.message}”',
                                textAlign: TextAlign.left,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontSize: 22,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              );
                            } else if (state is MotivationalMessageError) {
                              return Text(
                                loc.unexpected_error_occurred,
                                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }(),
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
            );
          },
        ),
      ),
    );
  }
}

class _FlagWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.10);

    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.03,
      size.width * 0.5,  size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.13,
      size.width,        size.height * 0.05,
    );

    path.lineTo(size.width, size.height * 0.85);

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

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.10);

    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.03,
      size.width * 0.5,  size.height * 0.08,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.13,
      size.width,        size.height * 0.05,
    );

    path.lineTo(size.width, size.height * 0.85);

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
