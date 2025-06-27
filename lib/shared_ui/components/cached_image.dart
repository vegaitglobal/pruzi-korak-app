import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

class UserAvatarImage extends StatelessWidget {
  const UserAvatarImage({
    super.key,
    required this.imageUrl,
    this.token,
    required this.size,
  });

  final String imageUrl;
  final String? token;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Image.asset(AppIcons.userPlaceholder, width: size, height: size);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder:
          (context, url) => CircularProgressIndicator(color: AppColors.primary),
      errorWidget:
          (context, url, error) =>
              Image.asset(AppIcons.icStep, width: size, height: size),
      httpHeaders: token != null ? {"Authorization": "Bearer $token"} : null,
      width: size,
      height: size,
      imageBuilder:
          (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
    );
  }
}

// CachedImage wihtout this circle decoration
class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.imageUrl,
    this.token,
    this.width,
    this.height,
    this.errorPlaceholder,
  });

  final String imageUrl;
  final String? token;
  final double? width;
  final double? height;
  final Widget? errorPlaceholder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder:
          (context, url) => CircularProgressIndicator(color: AppColors.primary),
      errorWidget:
          (context, url, error) =>
          errorPlaceholder ?? Icon(Icons.place, color: AppColors.error),
      httpHeaders: token != null ? {"Authorization": "Bearer $token"} : null,
      width: width,
      height: height,
    );
  }
}
