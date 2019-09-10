import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pref_dessert/pref_dessert.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'json_test.g.dart';

void main() {
  FuturePreferencesRepository<Person> repo;
  var bart;
  group("PreferencesRepository", () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      repo = new FuturePreferencesRepository<Person>(new PersonDesSer());

      bart = new Person("Bart", 22);
      var id = await repo.save(bart);
      expect(id, 0);
    });

    test('save person', () async {
      var all = await repo.findAll();
      expect(all, [bart]);

      var foo = new Person("Foo", 1);
      var fooId = await repo.save(foo);
      expect(fooId, 1);

      all = await repo.findAll();
      expect(all, [bart, foo]);
    });

    test('find one', () async {
      var one = await repo.findOne(0);
      expect(one, bart);
    });
  });
}

@JsonSerializable()
class Person extends _$PersonSerializerMixin {
  String name;
  int age;

  Person(this.name, this.age);

  factory Person.fromJson(Map<String, dynamic> map) {
    return _$PersonFromJson(map);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

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
