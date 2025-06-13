import 'package:supabase_flutter/supabase_flutter.dart';

import '../exception/exception_handler.dart';

class TenantSupabaseClient {
  final SupabaseClient client;
  final String tenantId;

  final _tenantIdKey = 'tenant_id';

  TenantSupabaseClient({required this.client, required this.tenantId});

  PostgrestFilterBuilder select(String table) {
    return client.from(table).select().eq(_tenantIdKey, tenantId);
  }

  Future<dynamic> insert(String table, Map<String, dynamic> data) {
    return client
        .from(table)
        .insert({...data, _tenantIdKey: tenantId});
  }

  PostgrestFilterBuilder update(String table, Map<String, dynamic> values) {
    return client.from(table).update(values).eq(_tenantIdKey, tenantId);
  }

  PostgrestFilterBuilder delete(String table) {
    return client.from(table).delete().eq(_tenantIdKey, tenantId);
  }

}

extension TenantSupabaseClientExtension on TenantSupabaseClient {
  Future<T> runSafely<T>(Future<T> Function() block) => handleSupabaseExceptions(block);
}

// Supabase.instance.client.login.onAuthStateChange.listen((data) {
// final AuthChangeEvent event = data.event;
//
// if (event == AuthChangeEvent.signedOut) {
// //
// }
//
// if (event == AuthChangeEvent.tokenRefreshed) {
// //
// }
//
// if (event == AuthChangeEvent.userUpdated) {
// //
// }
// });