import 'package:pruzi_korak/core/supabase/tenant_supabase_client.dart';

class ExampleRepoImpl {

  final TenantSupabaseClient _client;

  ExampleRepoImpl(this._client);

  Future<void> exampleMethod() async {
    _client.runSafely(() async {
      // Example of using the client to perform a select operation
      final response = await _client.select('example_table');
      if (response.error != null) {
        throw Exception('Failed to fetch data: ${response.error!.message}');
      }
      // Process the response data
      print(response.data);
    });
  }
}