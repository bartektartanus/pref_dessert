import 'package:shared_preferences/shared_preferences.dart';

import 'des_ser.dart';

/// Repository class that takes [SharedPreferences] and [DesSer<T>] and allows you to save and read your objects.
///
/// Be aware that [SharedPreferences.getInstance] returns a [Future], so you have to await it
/// (e.g. during app startup) before constructing this class.
class PreferencesRepository<T> {
  final SharedPreferences prefs;
  final String _key;
  final DesSer<T> desSer;

  PreferencesRepository(this.prefs, this.desSer) : _key = desSer.key;

  /// Saves new object in repository and returns its index.
  int save(T t) {
    var list = prefs.getStringList(_key) ?? [];
    list.add(desSer.serialize(t));
    prefs.setStringList(_key, list);
    return list.length - 1;
  }

  /// Saves all objects in repository.
  void saveAll(List<T> listToSave) {
    var list = prefs.getStringList(_key) ?? [];
    list.addAll(listToSave.map(desSer.serialize));
    prefs.setStringList(_key, list);
  }

  /// Returns all saved objects from the repository.
  List<T> findAll() {
    return prefs.getStringList(_key)?.map(desSer.deserialize).toList() ?? [];
  }

  /// Returns all saved objects matching [test].
  List<T> findAllWhere(bool Function(T element) test) {
    return findAll().where(test).toList();
  }

  /// Returns object at [index], or null if not found.
  T? findOne(int index) {
    var list = prefs.getStringList(_key);
    if (list == null || list.length <= index) {
      return null;
    }
    return desSer.deserialize(list[index]);
  }

  /// Returns first object matching [test].
  T? findFirstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return findAll().firstWhere(test, orElse: orElse);
  }

  /// Replaces object at [index] with [t].
  void update(int index, T t) {
    var list = prefs.getStringList(_key)!;
    list[index] = desSer.serialize(t);
    prefs.setStringList(_key, list);
  }

  /// Replaces all objects matching [test] with [t].
  void updateWhere(bool Function(T element) test, T t) {
    var list = findAll();
    var result = list.map((e) => test(e) ? t : e).map(desSer.serialize).toList();
    prefs.setStringList(_key, result);
  }

  /// Removes object at [index].
  void remove(int index) {
    var list = prefs.getStringList(_key)!;
    list.removeAt(index);
    prefs.setStringList(_key, list);
  }

  /// Removes all objects from the repository.
  void removeAll() {
    prefs.remove(_key);
  }

  /// Removes all objects matching [test].
  void removeWhere(bool Function(T element) test) {
    var list = findAll();
    list.removeWhere(test);
    prefs.setStringList(_key, list.map(desSer.serialize).toList());
  }
}
