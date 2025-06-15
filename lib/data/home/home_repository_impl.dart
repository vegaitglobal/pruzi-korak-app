import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/domain/user/team_user_stats.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _client;

  HomeRepositoryImpl(this._client);

  @override
  Future<({UserModel user, TeamUserStats teamUserStats})> getHomeData() async {
    try {
      final response = await _client.rpc('get_user_and_team_kilometers');

      // TODO: Add to fetch use data from database
      final user = UserModel(id: "id", fullName: "Nemanja Pajic");

      final stats = TeamUserStats.fromJson(response as Map<String, dynamic>);

      return (user: user, teamUserStats: stats);
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }
}
