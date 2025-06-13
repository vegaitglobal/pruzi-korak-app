
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';

class UserAvatarImage extends StatelessWidget {
  const UserAvatarImage(
      {super.key, required this.imageUrl, this.token, required this.size});

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
        placeholder: (context, url) =>
            CircularProgressIndicator(color: AppColors.primary),
        errorWidget: (context, url, error) =>
            Image.asset(AppIcons.userPlaceholder, width: size, height: size),
        httpHeaders: token != null ? {"Authorization": "Bearer $token"} : null,
        width: size,
        height: size,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }
}