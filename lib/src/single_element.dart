part of pref_dessert_internal;

/// SingleElementPreferencesRepository that takes [SharedPreferences] directly.
/// Be aware that SharedPreferences.getInstance() returns `Future` so you have to wait for that
/// to complete (eg. during your app startup) to be able to use this class!
/// If you don't want to do this, just use [FutureSingleElementPreferencesRepository]
/// This is simplified version of [PreferencesRepository] which only stores one value.
class SingleElementPreferencesRepository<T>
    extends _InnerSingleElementPreferencesRepository<T> {
  final SharedPreferences prefs;

  SingleElementPreferencesRepository(this.prefs, DesSer<T> desSer)
      : super(desSer);

  void save(T t) {
    _save(prefs, t);
  }

  T find() {
    return _find(prefs);
  }

  void remove() {
    _remove(prefs);
  }
}

/// Repository class that takes [DesSer<T>] and allows you to save and read your objects.
/// This is simplified version of [FuturePreferencesRepository] which only stores one value.
class FutureSingleElementPreferencesRepository<T>
    extends _InnerSingleElementPreferencesRepository<T> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  FutureSingleElementPreferencesRepository(DesSer<T> desSer) : super(desSer);

  final String _key = T.runtimeType.toString();

  Future<void> save(T t) async {
    return _save(await prefs, t);
  }

  Future<T> find() async {
    return _find(await prefs);
  }

  Future<void> remove() async {
    _remove(await prefs);
  }
}

/// Just inner class to simplify implementations
class _InnerSingleElementPreferencesRepository<T> {
  final String _key;
  final DesSer<T> desSer;

  _InnerSingleElementPreferencesRepository(this.desSer)
      : this._key = desSer.key;

  void _save(SharedPreferences prefs, T t) {
    prefs.setString(_key, desSer.serialize(t));
  }

  T _find(SharedPreferences prefs) {
    if (prefs.getKeys().contains(_key)) {
      var e = prefs.getString(_key);
      return desSer.deserialize(e);
    } else {
      return null;
    }
  }

  void _remove(SharedPreferences prefs) {
    prefs.remove(_key);
  }
}
