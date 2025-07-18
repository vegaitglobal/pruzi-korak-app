import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/constants/icons.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/profile/user_rank_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/features/profile/bloc/profile_bloc.dart';
import 'package:pruzi_korak/features/profile/team_ranking_card.dart';
import 'package:pruzi_korak/shared_ui/components/app_header_gradient.dart';
import 'package:pruzi_korak/shared_ui/components/buttons.dart';
import 'package:pruzi_korak/shared_ui/components/clickable_text.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/initials_avatar.dart';
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
        if (state is ProfileLoggedOut) {
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
            userRankModel: state.userRankModel,
            onLogout: () => _showLogoutDialog(context),
            onDeleteAccount: () => _showDeleteAccountDialog(context),
          );
        } else {
          return ErrorComponent(
            errorMessage:
                AppLocalizations.of(context)!.unexpected_error_occurred,
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
            title: AppLocalizations.of(context)!.leaving_us_title,
            description: AppLocalizations.of(context)!.leaving_us_message,
            cancelText: AppLocalizations.of(context)!.quit,
            confirmText: AppLocalizations.of(context)!.delete_profile,
            onCancel: () => Navigator.of(context).pop(),
            onConfirm:
                () => context.read<ProfileBloc>().add(ProfileDeleteAccount()),
          ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmActionDialog(
            icon: AppSvgIcon(iconPath: AppIcons.icSad, size: 38),
            title: AppLocalizations.of(context)!.logout_dialog_title,
            description: AppLocalizations.of(context)!.logout_dialog_message,
            cancelText: AppLocalizations.of(context)!.quit,
            confirmText: AppLocalizations.of(context)!.log_out,
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: () => context.read<ProfileBloc>().add(ProfileLogOut()),
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
    this.userRankModel,
  });

  final UserModel userModel;
  final UserRankModel? userRankModel;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final initial = userModel.fistName.isNotEmpty ? userModel.fistName[0] : '?';

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
                "${userModel.fistName} ${userModel.lastName}",
                style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundPrimary,
                ),
                child: InitialsAvatar(initial: initial, size: 124),
              ),
              const SizedBox(height: 24),
              if (userRankModel != null)
                TeamRankingCard(
                  teamName: userRankModel!.teamName,
                  teamRank: userRankModel!.teamRankGlobal,
                  userTeamRank: userRankModel!.userRankTeam,
                  userGlobalRank: userRankModel!.userRankGlobal,
                )
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
                text: AppLocalizations.of(context)!.log_out,
                iconPath: AppIcons.icLogout,
                onPressed: onLogout,
              ),
              const SizedBox(height: 24),
              ClickableText(
                text: AppLocalizations.of(context)!.delete_profile,
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
