import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'app_exceptions.dart';

extension SupabaseErrorExtension on PostgrestException {
  AppException toAppException() {
    final statusCode = int.tryParse(code ?? '');
    switch (statusCode) {
      case 400:
        return BadRequestException();
      case 401:
        return UnauthorizedException();
      case 403:
        return ForbiddenException();
      case 404:
        return NotFoundException();
      case 500:
        return ServerException();
      default:
        return UnknownException();
    }
  }
}


