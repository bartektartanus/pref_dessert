library pref_dessert;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesRepository<T> {

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final String _key = T.runtimeType.toString();

  T deserialize(String s);
  String serialize(T t);

  Future<int> save(T t) async {
    var list = (await prefs).getStringList(_key);
    if(list == null){
      list = [serialize(t)];
    }else{
      list.add(serialize(t));
    }
    (await prefs).setStringList(_key, list);
    return list.length-1;
  }

  Future<List<T>> getAll() async {
    var list = (await prefs).getStringList(_key);
    if(list == null){
      return [];
    }else{
      return list.map((s) => deserialize(s)).toList();
    }
  }

  Future<T> findOne(int i) async{
    var list = (await prefs).getStringList(_key);
    if(list == null || list.length <= i){
      return null;
    }else{
      return deserialize(list[i]);
    }
  }

  void update(int index, T t) async {
    var list = (await prefs).getStringList(_key);
    list.removeAt(index);
    list.insert(index, serialize(t));
  }

  Future<List<T>> remove(int index) async{
    var list = (await prefs).getStringList(_key);
    list.removeAt(index);
    return list.map((s) => deserialize(s)).toList();
  }


}
