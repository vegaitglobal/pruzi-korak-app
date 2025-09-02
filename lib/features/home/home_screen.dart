import 'dart:async';

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

import '../../data/health_data/helth_native_sync.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StreamSubscription<double>? _sub;
  Timer? _debounce;
  AppLifecycleState _life = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(HomeLoadEvent());
    });

    _sub = HealthNativeEvents.instance.kmDeltas.listen((_) async {
      if (_life == AppLifecycleState.resumed) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(seconds: 3), () {
          if (mounted)
            context.read<HomeBloc>().add(const HomeSilentUpdateEvent());
        });
      } else {}
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _life = state;
    if (state == AppLifecycleState.resumed) {
      context.read<HomeBloc>().add(const HomeSilentUpdateEvent());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _sub?.cancel();
    super.dispose();
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
                          AppLocalizations.of(
                            context,
                          )!.unexpected_error_occurred,
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
    // Calculate responsive spacing based on screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final verticalSpacing = screenHeight * 0.025; // 2.5% of screen height

    return PlatformSpecificPullToRefresh(
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeSilentUpdateEvent());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserSection(
              fullName: '${userModel.fistName} ${userModel.lastName}',
              badgeValue: myRank > 0 ? myRank.toString() : null,
              imageUrl: userModel.imageUrl,
            ),
            SizedBox(height: verticalSpacing),
            HomeUserSection(stepsModel: userStepsModel),
            SizedBox(height: verticalSpacing * 1.2),
            Text(
              userModel.teamName,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textVariant,
                fontSize: screenHeight * 0.022, // Make text size responsive
              ),
            ),
            SizedBox(height: verticalSpacing),
            HomeTeamSection(stepsModel: teamStepsModel),
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }
}
