import 'package:pruzi_korak/domain/profile/user_rank_model.dart';

abstract class ProfileRepository {
  Future<UserRankModel?> getUserRanks();
}

