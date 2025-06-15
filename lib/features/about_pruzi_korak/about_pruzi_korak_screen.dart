import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/organization/organization_model.dart';
import 'package:pruzi_korak/features/about_pruzi_korak/bloc/about_pruzi_korak_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/app_header_gradient.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_icon.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';
import 'package:pruzi_korak/shared_ui/util/url_launcher.dart';

class AboutPruziKorakScreen extends StatefulWidget {
  const AboutPruziKorakScreen({super.key});

  @override
  State<AboutPruziKorakScreen> createState() => _AboutPruziKorakScreenState();
}

class _AboutPruziKorakScreenState extends State<AboutPruziKorakScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutPruziKorakBloc, AboutPruziKorakState>(
      builder: (context, state) {
        return switch (state) {
          AboutPruziKorakInitial() => const AppLoader(),
          AboutPruziKorakLoading() => const AppLoader(),
          AboutPruziKorakLoaded() => AboutPruziKorakContent(
              organization: state.organization,
            ),
          AboutPruziKorakError() => ErrorComponent(
              errorMessage: AppLocalizations.of(context)!.unexpected_error_occurred,
              onRetry: () {
                context.read<AboutPruziKorakBloc>().add(const AboutPruziKorakLoad());
              },
            ),
        };
      },
    );
  }
}

class AboutPruziKorakContent extends StatelessWidget {
  final OrganizationModel organization;

  const AboutPruziKorakContent({
    super.key,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const CurvedHeaderBackground(height: 180),
                  Positioned.fill(
                    child: Center(
                      child: Image.asset(
                        AppIcons.splashLogo,
                        height: 160,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Long text with font size 12px
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          organization.description,
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Wrap of clickable social‑media icons with uniform spacing
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final link in organization.socialLinks)
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: ClickableIcon(
                        appSvgIcon: AppSvgIcon(
                          iconPath: link.iconPath,
                          size: 44, // fills the 56×56 box with 6‑px padding
                        ),
                        onPressed: () => launchURL(link.url),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
