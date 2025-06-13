import 'package:pruzi_korak/core/exception/exception_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/auth/AuthRepository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<String> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final tenantId = response.user?.userMetadata?['tenant_id'];

    if (tenantId == null) throw Exception('No tenantId found');
    return tenantId;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> isLoggedIn() async {
    return handleSupabaseExceptions(() async {
      final session = _client.auth.currentSession;
      if (session == null) return false;

      // TODO: Check if we have a valid tenant ID

      return true;
    });
  }
}

//Supabase.instance.client.login.currentSession;
//await Supabase.instance.client.login.signOut();
