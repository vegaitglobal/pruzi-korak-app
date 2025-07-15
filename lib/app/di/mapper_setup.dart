
import 'package:pruzi_korak/core/utils/josn_mapper.dart' show JsonMapper;
import 'package:pruzi_korak/domain/user.dart';

void setupJsonMappers() {
  JsonMapper.register<User>(User.fromJson);
}