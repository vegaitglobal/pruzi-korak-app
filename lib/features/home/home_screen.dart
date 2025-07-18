import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/domain/user/steps_model.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:pruzi_korak/features/home/bloc/home_bloc.dart';
import 'package:pruzi_korak/features/home/home_section.dart';
import 'package:pruzi_korak/features/home/user_section.dart';
import 'package:pruzi_korak/shared_ui/components/app_header.dart';
import 'package:pruzi_korak/shared_ui/components/error_screen.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';
import 'package:pruzi_korak/shared_ui/components/platform_specific_pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _channel = MethodChannel('org.pruziKorak.healthkit/callback');

  @override
  void initState() {
    super.initState();
    _listenToHealthKitCallbacks();
    //_channel.invokeMethod('startStepListener');
  }

  @override
  void dispose() {
    //_channel.invokeMethod('stopStepListener');
    super.dispose();
  }

  void _listenToHealthKitCallbacks() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'stepCountChanged') {
        if (mounted) {
          context.read<HomeBloc>().add(const HomeLoadEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundPrimary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const AppHeader(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return switch (state) {
                    HomeLoading() => const AppLoader(),
                    HomeLoaded() => HomeSection(
                      userModel: state.userModel,
                      userStepsModel: state.userStepsModel,
                      teamStepsModel: state.teamStepsModel,
                      myRank: state.myRank,
                    ),
                    HomeError() => ErrorComponent(
                      errorMessage:
                          AppLocalizations.of(context)!.unexpected_error_occurred,
                      onRetry: () {
                        context.read<HomeBloc>().add(const HomeLoadEvent());
                      },
                    ),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSection extends StatelessWidget {
  const HomeSection({
    super.key,
    required this.userModel,
    required this.userStepsModel,
    required this.teamStepsModel,
    required this.myRank,
  });

  final UserModel userModel;
  final StepsModel userStepsModel;
  final StepsModel teamStepsModel;
  final int myRank;

  @override
  Widget build(BuildContext context) {
    return PlatformSpecificPullToRefresh(
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeLoadEvent());
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserSection(
              fullName: '${userModel.fistName} ${userModel.lastName}',
              badgeValue: myRank > 0 ? myRank.toString() : null,
            ),
            SizedBox(height: 16),
            HomeUserSection(stepsModel: userStepsModel),
            SizedBox(height: 32),
            Text(
              userModel.teamName,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textVariant),
            ),
            SizedBox(height: 32),

            HomeTeamSection(stepsModel: teamStepsModel),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
