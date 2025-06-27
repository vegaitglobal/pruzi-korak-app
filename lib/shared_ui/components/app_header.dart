import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getIt<AppLocalStorage>().getLogoUrl(),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSvgIcon(iconPath: AppIcons.appLogo, size: 40),
            CachedImage(
              imageUrl: imageUrl,
              height: 40.0,
              errorPlaceholder: Text(
                AppLocalizations.of(context)!.logo_placeholder,
                style: AppTextStyles.labelMedium,
              ),
            ),
          ],
        );
      },
    );
  }
}
