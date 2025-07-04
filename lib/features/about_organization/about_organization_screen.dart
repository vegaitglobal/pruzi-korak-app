import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/organization/organization_model.dart';
import 'package:pruzi_korak/features/about_organization/bloc/about_organization_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_icon.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';
import 'package:pruzi_korak/shared_ui/util/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutOrganizationScreen extends StatefulWidget {
  const AboutOrganizationScreen({super.key});

  @override
  State<AboutOrganizationScreen> createState() =>
      _AboutOrganizationScreenState();
}

class _AboutOrganizationScreenState extends State<AboutOrganizationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutOrganizationBloc, AboutOrganizationState>(
      builder: (context, state) {
        return switch (state) {
          AboutOrganizationInitial() => const AppLoader(),
          AboutOrganizationLoading() => const AppLoader(),
          AboutOrganizationLoaded() => AboutOrganizationContent(
            organization: state.organization,
          ),
          AboutOrganizationError() => ErrorComponent(
            errorMessage:
                AppLocalizations.of(context)!.unexpected_error_occurred,
            onRetry: () {
              context.read<AboutOrganizationBloc>().add(
                const AboutOrganizationLoad(),
              );
            },
          ),
        };
      },
    );
  }
}

class AboutOrganizationContent extends StatelessWidget {
  final OrganizationModel organization;

  const AboutOrganizationContent({super.key, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // centers the entire content horizontally
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: CachedImage(
                      imageUrl: organization.logoUrl,
                      height: 40.0,
                    ),
                  ),
                ),
                // Heading with font size 24px
                Text(
                  organization.heading,
                  style: AppTextStyles.titleLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16.0),

                // Long text with font size 12px
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            organization.description,
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (organization.website_url1.isNotEmpty) ...[
                            GestureDetector(
                              onTap: () async {
                                final url = organization.website_url1;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Text(
                                organization.website_url1,
                                style: AppTextStyles.bodySmall.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                          if (organization.website_url2.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final url = organization.website_url2;
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Text(
                                organization.website_url2,
                                style: AppTextStyles.bodySmall.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

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

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
