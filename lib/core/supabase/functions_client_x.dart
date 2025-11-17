import 'dart:io';

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

      if (res.status == 401) {
        // Sign out and notify UI to redirect to login
        await Supabase.instance.client.auth.signOut();
        if (getIt.isRegistered<SessionStream>()) {
          getIt<SessionStream>().triggerLogout();
        }
        throw SessionExpiredException();
      }

      return res;
    } on AuthRetryableFetchException catch (_) {
      // DNS, timeout, etc. -> let caller retry/handle
      rethrow;
    } on SocketException catch (_) {
      rethrow;
    }
  }
}
