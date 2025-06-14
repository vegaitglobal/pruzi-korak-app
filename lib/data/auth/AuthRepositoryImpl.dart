import 'package:pruzi_korak/core/exception/exception_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/auth/AuthRepository.dart';

const String email_key = "input_email";
const String pass_key = "input_passcode";
const String device_key = "device_id";

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final params = <String, String>{
      email_key: email,
      pass_key: password,
      device_key: "121231231",
    };
    var response = await _client.rpc("log_in", params: params);
    return response;

    // final tenantId = response.user?.userMetadata?['tenant_id'];
    // if (tenantId == null) throw Exception('No tenantId found');
    // return tenantId;
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
