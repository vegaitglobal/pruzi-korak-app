typedef FromJsonFunc<T> = T Function(Map<String, dynamic>);

class JsonMapper {
  static final Map<Type, FromJsonFunc> _mappers = {};

  static void register<T>(FromJsonFunc<T> fromJson) {
    _mappers[T] = fromJson;
  }

  static T fromJson<T>(Map<String, dynamic> json) {
    final mapper = _mappers[T];
    if (mapper == null) {
      throw Exception("No mapper registered for type $T");
    }
    return mapper(json) as T;
  }

  static List<T> fromJsonList<T>(List<dynamic> jsonList) {
    return jsonList.map((e) => fromJson<T>(e as Map<String, dynamic>)).toList();
  }
}