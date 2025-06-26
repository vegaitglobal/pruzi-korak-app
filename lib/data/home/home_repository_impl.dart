import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/domain/user/team_user_stats.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../local/local_storage.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _client;
  final AppLocalStorage _localStorage;

  HomeRepositoryImpl(this._client, this._localStorage);

  @override
  Future<({UserModel user, TeamUserStats teamUserStats})> getHomeData() async {
    try {
      final response = await _client.rpc('get_user_and_team_kilometers');
      final user = await _localStorage.getUser();

      final stats = TeamUserStats.fromJson(response as Map<String, dynamic>);

      return (
        user: user ?? UserModel(fistName: "", lastName: "", teamName: ""),
        teamUserStats: stats,
      );
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }

  Future<void> fetchSyncInfo() async {
    final response = await Supabase.instance.client.functions.invoke('sync-info');

    if (response.status != 200) {
      throw Exception('Failed to fetch sync info: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    final lastSyncAt = DateTime.parse(data['last_sync_at']);
    final lastSignInAt = DateTime.parse(data['last_sign_in_at']);

    print('Last sync: $lastSyncAt');
    print('Last sign in: $lastSignInAt');
  }

  Future<void> sendDailyDistances(
    String deviceId,
    List<Map<String, dynamic>> distances,
  ) async {
    final response = await Supabase.instance.client.functions.invoke(
      'sync-daily-distances',
      body: {
        'device_id': deviceId,
        'distances': distances,
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to sync distances: ${response.data}');
    }
  }

  @override
  Future<UserModel?> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(UserModel user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
