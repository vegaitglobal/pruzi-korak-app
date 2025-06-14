import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/features/profile/bloc/profile_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/app_header_gradient.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';
import 'package:pruzi_korak/shared_ui/components/cached_image.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_text.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';
import 'package:pruzi_korak/shared_ui/components/svg_icon.dart';

import '../../shared_ui/components/dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutPressed) {
          context.go(AppRoutes.login.path());
        } else if (state is ProfileDeleted) {
          context.go(AppRoutes.login.path());
        }
      },
      buildWhen: (previous, current) {
        return current is ProfileLoading || current is ProfileLoaded;
      },
      builder: (context, state) {
        if (state is ProfileInitial) {
          return const AppLoader();
        } else if (state is ProfileLoading) {
          return const AppLoader();
        } else if (state is ProfileLoaded) {
          return ProfileLoadedSection(
            userModel: state.userModel,
            onLogout: () => context.read<ProfileBloc>().add(ProfileLogOut()),
            onDeleteAccount: () => _showDeleteAccountDialog(context),
          );
        } else {
          return ErrorComponent(
            errorMessage: 'Greška pri učitavanju profila',
            onRetry: () {
              context.read<ProfileBloc>().add(ProfileLoad());
            },
          );
        }
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmActionDialog(
            icon: AppSvgIcon(iconPath: AppIcons.icSad, size: 38),
            title: 'Napustate nas?',
            description:
                'Da li ste sigurni da želite da obrišete svoj profil? Sve informacije i vaš učinak će biti izbrisani.',
            cancelText: 'Odustani',
            confirmText: 'Obriši Profil',
            onCancel: () => Navigator.of(context).pop(),
            onConfirm:
                () => context.read<ProfileBloc>().add(ProfileDeleteAccount()),
          ),
    );
  }
}

class ProfileLoadedSection extends StatelessWidget {
  const ProfileLoadedSection({
    super.key,
    required this.userModel,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final UserModel userModel;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const CurvedHeaderBackground(height: 180),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                userModel.fullName,
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundPrimary,
                ),
                child: UserAvatarImage(imageUrl: userModel.imageUrl, size: 124),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Column(
            children: [
              AppButtonWithIcon(
                text: 'Odjavi se',
                iconPath: AppIcons.icLogout,
                onPressed: onLogout,
              ),
              const SizedBox(height: 24),
              ClickableText(
                text: 'Obriši nalog',
                textColor: AppColors.error,
                fontSize: 14,
                onPressed: onDeleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
