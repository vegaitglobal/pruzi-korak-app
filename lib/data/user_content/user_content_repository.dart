import 'package:pruzi_korak/domain/user/motivational_message.dart';

abstract class UserContentRepository {
  Future<MotivationalMessage?> getMyDailyMotivation();
}
