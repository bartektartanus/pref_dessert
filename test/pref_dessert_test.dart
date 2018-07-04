import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pref_dessert/pref_dessert.dart';


void main() {

  FuturePreferencesRepository<Person> repo = new FuturePreferencesRepository<Person>(new PersonDesSer());
  var bart;
  group("PreferencesRepository", () {

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});

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

class Person {
  String name;
  int age;

  Person(this.name, this.age);

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

class PersonDesSer extends DesSer<Person>{
  @override
  Person deserialize(String s) {
    var split = s.split(",");
    return new Person(split[0], int.parse(split[1]));
  }

  @override
  String serialize(Person t) {
    return "${t.name},${t.age}";
  }
  
}
