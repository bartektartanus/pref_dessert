import 'dart:convert';

/// Abstract class for deserialization and serialization which you have to implement and then pass it to the
/// [PreferencesRepository]
abstract class DesSer<T> {
  /// Key of the (de)serializer that is used to write and read objects into shared_preferences.
  String get key;

  T deserialize(String s);

  String serialize(T t);
}

/// If you want to store your classes as JSON (which is recommended), use this class and only provide implementation
/// of two methods which converts your objects from and to map.
abstract class JsonDesSer<T> extends DesSer<T> {
  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap(T t);

  @override
  String serialize(T t) {
    return json.encode(toMap(t));
  }

  @override
  T deserialize(String s) {
    return fromMap(json.decode(s));
  }
}
