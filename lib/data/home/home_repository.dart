import 'package:pruzi_korak/domain/user.dart';
import 'package:pruzi_korak/domain/user/team_user_stats.dart';
import 'package:pruzi_korak/domain/user/user_model.dart';

abstract class HomeRepository {
  Future<({UserModel user, TeamUserStats teamUserStats})> getHomeData();
}