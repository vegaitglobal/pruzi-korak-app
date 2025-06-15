import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_icon.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';
import 'package:pruzi_korak/shared_ui/util/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutOrganizationScreen extends StatelessWidget {
  const AboutOrganizationScreen({super.key});

  final String description = 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.';
  final String websiteUrl = 'https://www.kroonstudio.com';
  final String logoUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMQJIvdAWXjzmThRBeIyvFbxP4Bs6ekmuRog&s';
  final String heading = 'Poruka kompanije';

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with backend‑fetched list
    final socialLinks = [
      {
        'iconPath': AppIcons.facebook,
        'url': 'https://facebook.com',
      },
      {
        'iconPath': AppIcons.instagram,
        'url': 'https://instagram.com',
      },
      {
        'iconPath': AppIcons.linkedin,
        'url': 'https://linkedin.com',
      }
    ];
    
    return Scaffold(
      body: Center( // centers the entire content horizontally
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
                      imageUrl:
                          logoUrl,
                      height: 40.0,
                    ),
                  ),
                ),
                // Heading with font size 24px
                Text(
                  heading,
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
                            description,
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () async {
                              final url = websiteUrl;
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Text(
                              websiteUrl,
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20.0),

                // Row of clickable social‑media icons 20 px above nav
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < socialLinks.length; i++) ...[
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClickableIcon(
                          appSvgIcon: AppSvgIcon(
                            iconPath: socialLinks[i]['iconPath'] as String,
                            size: 60,   // fills the 70×70 box comfortably
                          ),
                          onPressed: () {
                            launchURL(socialLinks[i]['url'] as String);
                          },
                        ),
                      ),
                      if (i != socialLinks.length - 1)
                        const SizedBox(width: 4),
                    ],
                  ],
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ));
  }
}
