import 'package:pruzi_korak/domain/user/motivational_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_content_repository.dart';

class UserContentRepositoryImpl implements UserContentRepository {
  final SupabaseClient _client;

  UserContentRepositoryImpl(this._client);

  @override
  Future<MotivationalMessage?> getMyDailyMotivation() async {
    try {
      final response = await _client.rpc('get_my_daily_motivation');
      if (response == null) return null;

      // If the RPC returns a list, take the first item.
      if (response is List && response.isNotEmpty) {
        return MotivationalMessage.fromJson(response.first as Map<String, dynamic>);
      }
      // If the RPC returns a single object.
      if (response is Map<String, dynamic>) {
        return MotivationalMessage.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch daily motivation: $e');
    }
  }
}
