import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';

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

  bool get isSvg => imageUrl.toLowerCase().endsWith(".svg");

  Widget _buildCircle(Widget child) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildCircle(
        Image.asset(AppIcons.userPlaceholder, fit: BoxFit.cover),
      );
    }

    if (isSvg) {
      return FutureBuilder<File>(
        future: DefaultCacheManager().getSingleFile(
          imageUrl,
          headers: token != null ? {"Authorization": "Bearer $token"} : null,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return _buildCircle(
              SvgPicture.file(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          } else if (snapshot.hasError) {
            return _buildCircle(
              Image.asset(AppIcons.icStep, fit: BoxFit.cover),
            );
          } else {
            return _buildCircle(
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }
        },
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        httpHeaders: token != null ? {"Authorization": "Bearer $token"} : null,
        placeholder: (context, url) => _buildCircle(
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        errorWidget: (context, url, error) => _buildCircle(
          Image.asset(AppIcons.icStep, fit: BoxFit.cover),
        ),
        imageBuilder: (context, imageProvider) => _buildCircle(
          Image(image: imageProvider, fit: BoxFit.cover),
        ),
        width: size,
        height: size,
      );
    }
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
    if (imageUrl.trim().isEmpty) {
      return errorPlaceholder ??
          Icon(Icons.broken_image, color: AppColors.error, size: width);
    }

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
