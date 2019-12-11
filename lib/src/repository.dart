part of pref_dessert_internal;

/// Abstract class for deserialization and serialization which you have to implement and then pass it to the
/// [PreferencesRepository]
abstract class DesSer<T> {
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

/// PreferencesRepository that takes [SharedPreferences] directly. Be aware that SharedPreferences.getInstance() returns
/// `Future` so you have to wait for that to complete (eg. during your app startup) to be able to use this class!
/// If you don't want to do this, just use [FuturePreferencesRepository]
class PreferencesRepository<T> extends _InnerPreferencesRepository<T> {
  final SharedPreferences prefs;

  PreferencesRepository(this.prefs, DesSer<T> desSer) : super(desSer);

  int save(T t) {
    return _save(prefs, t);
  }

  void saveAll(List<T> list) {
    _saveAll(prefs, list);
  }

  List<T> findAll() {
    return _findAll(prefs);
  }

  List<T> findAllWhere(bool test(T element)) {
    return findAll().where(test).toList();
  }

  T findOne(int i) {
    return _findOne(prefs, i);
  }

  T findFirstWhere(bool test(T element), {T orElse()}) {
    return _findOneWhere(prefs, test, orElse: orElse);
  }

  void update(int index, T t) {
    _update(prefs, index, t);
  }

  void updateWhere(bool test(T t), T t) {
    _updateWhere(prefs, test, t);
  }

  List<T> remove(int index) {
    return _remove(prefs, index);
  }

  void removeAll() {
    _removeAll(prefs);
  }

  void removeWhere(bool test(T element)) {
    _removeWhere(prefs, test);
  }
}

/// Repository class that takes [DesSer<T>] and allows you to save and read your objects.
class FuturePreferencesRepository<T> extends _InnerPreferencesRepository<T> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  FuturePreferencesRepository(DesSer<T> desSer) : super(desSer);

  Future<int> save(T t) async {
    return _save(await prefs, t);
  }

  Future<void> saveAll(List<T> list) async {
    return _saveAll(await prefs, list);
  }

  Future<List<T>> findAll() async {
    return _findAll(await prefs);
  }

  Future<List<T>> findAllWhere(bool test(T element)) async {
    return (await findAll()).where(test).toList();
  }

  Future<T> findOne(int i) async {
    return _findOne(await prefs, i);
  }

  Future<T> findFirstWhere(bool test(T element), {T orElse()}) async {
    return _findOneWhere(await prefs, test, orElse: orElse);
  }

  void update(int index, T t) async {
    _update(await prefs, index, t);
  }

  void updateWhere(bool test(T t), T t) async {
    _updateWhere(await prefs, test, t);
  }

  Future<List<T>> remove(int index) async {
    return _remove(await prefs, index);
  }

  void removeAll() async {
    _removeAll(await prefs);
  }

  void removeWhere(bool Function(T element) test) async {
    _removeWhere(await prefs, test);
  }
}

/// Just inner class to simplify implementations
class _InnerPreferencesRepository<T> {
  final String _key;
  final DesSer<T> desSer;

  _InnerPreferencesRepository(this.desSer) : this._key = desSer.key;

  int _save(SharedPreferences prefs, T t) {
    var list = prefs.getStringList(_key);
    if (list == null) {
      list = [desSer.serialize(t)];
    } else {
      list.add(desSer.serialize(t));
    }
    prefs.setStringList(_key, list);
    return list.length - 1;
  }

  void _saveAll(SharedPreferences prefs, List<T> listToSave) {
    var list = prefs.getStringList(_key);
    if (list == null) {
      list = listToSave.map((t) => desSer.serialize(t)).toList();
    } else {
      list.addAll(listToSave.map((t) => desSer.serialize(t)));
    }
    prefs.setStringList(_key, list);
  }

  List<T> _findAll(SharedPreferences prefs) {
    var list = prefs.getStringList(_key);
    if (list == null) {
      return [];
    } else {
      return list.map((s) => desSer.deserialize(s)).toList();
    }
  }

  T _findOne(SharedPreferences prefs, int i) {
    var list = prefs.getStringList(_key);
    if (list == null || list.length <= i) {
      return null;
    } else {
      return desSer.deserialize(list[i]);
    }
  }

  T _findOneWhere(SharedPreferences prefs, bool test(T element), {T orElse()}) {
    return _findAll(prefs).firstWhere(test, orElse: orElse);
  }

  void _update(SharedPreferences prefs, int index, T t) {
    var list = prefs.getStringList(_key);
    list.removeAt(index);
    list.insert(index, desSer.serialize(t));
    // without this preferences are not persisted and lost after app restart
    prefs.setStringList(_key, list);
  }

  void _updateWhere(SharedPreferences prefs, bool test(T element), T t) {
    var list = _findAll(prefs);
    var result = list.map((e){
      if(test(e)){
        return t;
      }else{
        return e;
      }
    }).map(desSer.serialize).toList();
    // without this preferences are not persisted and lost after app restart
    prefs.setStringList(_key, result);
  }

  List<T> _remove(SharedPreferences prefs, int index) {
    var list = prefs.getStringList(_key);
    list.removeAt(index);
    return list.map((s) => desSer.deserialize(s)).toList();
  }

  void _removeAll(SharedPreferences prefs) {
    prefs.remove(_key);
  }

  void _removeWhere(SharedPreferences prefs, bool test(T element)) {
    var list = _findAll(prefs);
    list.removeWhere(test);
    // without this preferences are not persisted and lost after app restart
    prefs.setStringList(_key, list.map(desSer.serialize).toList());
  }
}
