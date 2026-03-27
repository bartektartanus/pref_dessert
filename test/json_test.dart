import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'json_test.g.dart';

void main() {
  late PreferencesRepository<Person> repo;
  var bart = Person("Bart", 22);

  group("PreferencesRepository with JSON", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      repo = PreferencesRepository<Person>(prefs, PersonDesSer());

      var id = repo.save(bart);
      expect(id, 0);
    });

    test('save person', () {
      var all = repo.findAll();
      expect(all, [bart]);

      var foo = Person("Foo", 1);
      var fooId = repo.save(foo);
      expect(fooId, 1);

      all = repo.findAll();
      expect(all, [bart, foo]);
    });

    test('find one', () {
      var one = repo.findOne(0);
      expect(one, bart);
    });
  });
}

@JsonSerializable()
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  factory Person.fromJson(Map<String, dynamic> map) => _$PersonFromJson(map);

  Map<String, dynamic> toJson() => _$PersonToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && runtimeType == other.runtimeType && name == other.name && age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}

class PersonDesSer extends DesSer<Person> {
  @override
  Person deserialize(String s) {
    return Person.fromJson(json.decode(s));
  }

  @override
  String serialize(Person t) {
    return json.encode(t.toJson());
  }

  @override
  String get key => "Person";
}
