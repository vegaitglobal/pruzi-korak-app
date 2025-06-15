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
