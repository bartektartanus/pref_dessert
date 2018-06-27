library pref_dessert;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


abstract class DesSer<T> {
  T deserialize(String s);
  String serialize(T t);
}

class PreferencesRepository<T> extends _InnerPreferencesRepository<T>{

  final SharedPreferences prefs;

  PreferencesRepository(this.prefs, DesSer<T> desSer) : super(desSer);

  int save(T t) {
    return _save(prefs, t);
  }

  List<T> getAll()  {
    return _getAll(prefs);
  }

  T findOne(int i) {
    return _findOne(prefs, i);
  }

  void update(int index, T t) {
    _update(prefs, index, t);
  }

  List<T> remove(int index) {
    return _remove(prefs, index);
  }

}

class FuturePreferencesRepository<T> extends _InnerPreferencesRepository<T>{

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  FuturePreferencesRepository(DesSer<T> desSer) : super(desSer);

  final String _key = T.runtimeType.toString();

  Future<int> save(T t) async {
    return _save(await prefs, t);
  }

  Future<List<T>> getAll() async {
    return _getAll(await prefs);
  }

  Future<T> findOne(int i) async{
    return _findOne(await prefs, i);
  }

  void update(int index, T t) async {
    _update(await prefs, index, t);
  }

  Future<List<T>> remove(int index) async{
    return _remove(await prefs, index);
  }

}


class _InnerPreferencesRepository<T> {

  final String _key = T.runtimeType.toString();
  final DesSer<T> desSer;

  _InnerPreferencesRepository(this.desSer);

  int _save(SharedPreferences prefs, T t) {
    var list = prefs.getStringList(_key);
    if(list == null){
      list = [desSer.serialize(t)];
    }else{
      list.add(desSer.serialize(t));
    }
    prefs.setStringList(_key, list);
    return list.length-1;
  }

  List<T> _getAll(SharedPreferences prefs)  {
    var list = prefs.getStringList(_key);
    if(list == null){
      return [];
    }else{
      return list.map((s) => desSer.deserialize(s)).toList();
    }
  }

  T _findOne(SharedPreferences prefs, int i) {
    var list = prefs.getStringList(_key);
    if(list == null || list.length <= i){
      return null;
    }else{
      return desSer.deserialize(list[i]);
    }
  }

  void _update(SharedPreferences prefs, int index, T t) {
    var list = prefs.getStringList(_key);
    list.removeAt(index);
    list.insert(index, desSer.serialize(t));
  }

  List<T> _remove(SharedPreferences prefs, int index) {
    var list = prefs.getStringList(_key);
    list.removeAt(index);
    return list.map((s) => desSer.deserialize(s)).toList();
  }

}
