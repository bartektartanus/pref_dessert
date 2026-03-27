import 'package:shared_preferences/shared_preferences.dart';

import 'des_ser.dart';

/// Repository that stores a single element in [SharedPreferences].
///
/// This is a simplified version of [PreferencesRepository] which only stores one value.
///
/// Be aware that [SharedPreferences.getInstance] returns a [Future], so you have to await it
/// (e.g. during app startup) before constructing this class.
class SingleElementPreferencesRepository<T> {
  final SharedPreferences prefs;
  final String _key;
  final DesSer<T> desSer;

  SingleElementPreferencesRepository(this.prefs, this.desSer) : _key = desSer.key;

  /// Saves (or overwrites) the element.
  void save(T t) {
    prefs.setString(_key, desSer.serialize(t));
  }

  /// Returns the stored element, or null if none exists.
  T? find() {
    var e = prefs.getString(_key);
    return e != null ? desSer.deserialize(e) : null;
  }

  /// Removes the stored element.
  void remove() {
    prefs.remove(_key);
  }
}
