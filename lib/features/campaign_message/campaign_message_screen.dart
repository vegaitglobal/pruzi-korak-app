import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/campaign/campaign_message.dart';
import 'package:pruzi_korak/features/campaign_message/bloc/campaign_message_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';

class CampaignMessageScreen extends StatefulWidget {
  const CampaignMessageScreen({super.key});

  @override
  State<CampaignMessageScreen> createState() => _CampaignMessageScreenState();
}

class _CampaignMessageScreenState extends State<CampaignMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampaignMessageBloc, CampaignMessageState>(
      builder: (context, state) {
        return switch (state) {
          CampaignMessageInitial() => const AppLoader(),
          CampaignMessageLoading() => const AppLoader(),
          CampaignMessageLoaded() => CampaignMessageContent(
            campaignMessage: state.campaignMessage,
          ),
          CampaignMessageError() => ErrorComponent(
            errorMessage:
                AppLocalizations.of(context)!.unexpected_error_occurred,
            onRetry: () {
              context.read<CampaignMessageBloc>().add(
                const CampaignMessageLoad(),
              );
            },
          ),
        };
      },
    );
  }
}

class CampaignMessageContent extends StatelessWidget {
  final CampaignMessage campaignMessage;

  const CampaignMessageContent({super.key, required this.campaignMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Center(
                  child: CachedImage(
                    imageUrl: campaignMessage.logoUrl,
                    height: 40.0,
                  ),
                ),
              ),

              Text(
                campaignMessage.heading,
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16.0),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: SingleChildScrollView(
                    child: Text(
                      campaignMessage.message,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              AppButton(
                text: AppLocalizations.of(context)!.continue_to_app,
                onPressed: () {
                  context.go(AppRoutes.home.path());
                },
              ),
              const SizedBox(height: 24.0),

            ],
          ),
        ),
      ),
    );
  }
}
