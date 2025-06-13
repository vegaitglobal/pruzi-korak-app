import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/app/navigation/app_routes.dart';
import 'package:pruzi_korak/core/session/session_stream.dart';
import 'package:pruzi_korak/core/utils/app_logger.dart';


class SessionListener extends StatefulWidget {
  final Widget child;
  final GoRouter router;
  //final LocalLogoutUseCase logoutUseCase;

  const SessionListener({
    super.key,
    required this.child,
    required this.router,
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
        //await widget.logoutUseCase.execute(); CHECK IF NEEDED
        widget.router.go(AppRoutes.login.path());
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