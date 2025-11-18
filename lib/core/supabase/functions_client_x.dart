import 'dart:io';

import 'package:pruzi_korak/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pruzi_korak/app/di/injector.dart';
import 'package:pruzi_korak/core/session/session_stream.dart';

class SessionExpiredException implements Exception {}

extension FunctionsClientX on FunctionsClient {
  Future<FunctionResponse> invokeSafe(
    String functionName, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final res = await invoke(
        functionName,
        body: body,
        headers: headers,
      );

      AppLogger.logDebug(
        "FunctionsClient invokeSafe - Function: $functionName, Status: ${res.status}",
      );

      if (res.status == 401) {
        _handleSessionExpired(source: 'FunctionResponse');
      }

      return res;
    } on FunctionException catch (e) {
      AppLogger.logDebug(
        "FunctionException caught in invokeSafe - Function: $functionName, Status: ${e.status}, Details: ${e.details}",
      );
      if (e.status == 401) {
        _handleSessionExpired(source: 'FunctionException');
        throw SessionExpiredException();
      }
      rethrow;
    } on AuthRetryableFetchException catch (_) {
      rethrow;
    } on SocketException catch (_) {
      rethrow;
    }
  }

  void _handleSessionExpired({required String source}) async {
    AppLogger.logDebug("Session expired detected ($source) - signing out.");
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      AppLogger.logDebug("SignOut failed (ignored): $e");
    }
    if (getIt.isRegistered<SessionStream>()) {
      AppLogger.logDebug("Triggering logout event in SessionStream.");
      getIt<SessionStream>().triggerLogout();
    }
  }
}
