import 'package:pruzi_korak/core/exception/supabase_error_extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_logger.dart';
import 'dart:io';

import 'app_exceptions.dart';

typedef ExceptionHandler<T> = Future<T> Function();

Future<T> handleSupabaseExceptions<T>(ExceptionHandler<T> handler) async {
  try {
    return await handler();
  } on PostgrestException catch (e, stackTrace) {
    AppLogger.logError('PostgrestException', e, stackTrace);
    throw e.toAppException();
  } on AuthException catch (e, stackTrace) {
    AppLogger.logError('AuthException', e, stackTrace);
    throw UnauthorizedException();
  } on SocketException catch (e, stackTrace) {
    AppLogger.logError('SocketException', e, stackTrace);
    throw NetworkException();
  } catch (e, stackTrace) {
    AppLogger.logError('Unknown error', e, stackTrace);
    throw UnknownException();
  }
}
