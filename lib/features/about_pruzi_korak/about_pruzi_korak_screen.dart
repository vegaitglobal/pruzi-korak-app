import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/shared_ui/components/app_header_gradient.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_icon.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';
import 'package:pruzi_korak/shared_ui/util/url_launcher.dart';

class AboutPruziKorakScreen extends StatelessWidget {
  const AboutPruziKorakScreen({super.key});

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
      },
      {
        'iconPath': AppIcons.twitter,
        'url': 'https://twitter.com',
      },
      {
        'iconPath': AppIcons.email,
        'url': 'mailto:a.mudric@vegaitglobal.com',
      }
    ];
    return Scaffold(
      body: Center( // centers the entire content horizontally
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
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.",
                            style: AppTextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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

                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      );
  }
}
