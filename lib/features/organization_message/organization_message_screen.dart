import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';

class OrganizationMessageScreen extends StatelessWidget {
  const OrganizationMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Default header
              const AppHeader(),
              
              const SizedBox(height: 32.0),
              
              // Heading with font size 24px
              Text(
                "Organization Message", // This could be replaced with a localized string
                style: AppTextStyles.titleLarge,
              ),
              
              const SizedBox(height: 16.0),
              
              // Long text with font size 12px
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.",
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ),
              
              const SizedBox(height: 24.0),
              
              // Button with primary color and text "continue_to_app"
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: localizations.continue_to_app, 
                  onPressed: () {
                    // Navigate to the home screen or any other screen as needed
                    context.go(AppRoutes.home.path());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
