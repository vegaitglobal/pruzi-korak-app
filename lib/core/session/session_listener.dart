import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/app/navigation/navigation_router.dart';
import 'package:pruzi_korak/app/theme/app_text_styles.dart';
import 'package:pruzi_korak/app/theme/colors.dart';
import 'package:pruzi_korak/core/localization/app_localizations.dart';
import 'package:pruzi_korak/core/session/session_stream.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:pruzi_korak/domain/auth/auth_repository.dart';

class SessionListener extends StatefulWidget {
  final Widget child;
  final GoRouter router;
  final AuthRepository authRepository;

  const SessionListener({
    super.key,
    required this.child,
    required this.router,
    required this.authRepository,
  });

  @override
  State<SessionListener> createState() => _SessionListenerState();
}

class _SessionListenerState extends State<SessionListener> {
  late final StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = getIt<SessionStream>().stream.listen((event) async {
      if (event is SessionExpired) {
        AppLogger.logInfo("Session Expired - logging out.");
        try {
          await widget.authRepository.forceLogout();
        } catch (e, st) {
          AppLogger.logError("Logout failed after session expired", e, st);
        } finally {
          widget.router.go(AppRoutes.login.path());
          _showSessionExpiredMessage();
        }
      }
    });
  }

  void _showSessionExpiredMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        final l10n = AppLocalizations.of(ctx);
        final message = l10n?.sessionExpired ?? 'Session expired.';
        ScaffoldMessenger.of(ctx)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 4),
            ),
          );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
