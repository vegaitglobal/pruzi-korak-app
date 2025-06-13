import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/app/theme/gradients.dart';
import 'package:pruzi_korak/features/splash/bloc/splash_bloc.dart';
import 'package:pruzi_korak/shared_ui/components/loading_components.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
          context.go(AppRoutes.home.path());
        } else if (state is UserNotLoggedIn) {
          context.go(AppRoutes.login.path());
        }
      },
      buildWhen: (context, state) {
        return state is SplashInitial;
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppGradients.backgroundLinearGradient,
          ),
          child: Center(child: AppLoader(color: AppColors.backgroundPrimary)),
        );
      },
    );
  }
}
