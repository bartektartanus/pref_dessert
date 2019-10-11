import 'dart:async';

import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pref_dessert/pref_dessert.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  PreferencesRepository<Person> repo;
  var bartek = new Person("Bartek", 22);
  var bar = new Person("Bar", 1);
  var foo = new Person("Foo", 2);

  group("PreferencesRepository", () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      Future.wait([
        SharedPreferences.getInstance().then((p) {
          repo = new PreferencesRepository<Person>(p, new PersonDesSer());
        })
      ]);
    });

    setUp(() {
      repo.removeAll();
    });

    test('save person', () {
      var id = repo.save(bartek);
      expect(id, 0);

      var all = repo.findAll();
      expect(all, [bartek]);

      var fooId = repo.save(foo);
      expect(fooId, 1);

      all = repo.findAll();
      expect(all, [bartek, foo]);
    });

    test('find one', () {
      var id = repo.save(bartek);
      expect(id, 0);
      var one = repo.findOne(0);
      expect(one, bartek);
    });

    test('update', () {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect(repo.findAll().length, 3);
      bartek.name = "Bartolini";
      bartek.age += 10;
      repo.update(1, bartek);
      expect(repo.findAll(), [bar, bartek, foo]);
    });

    test('removeAll', () {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect(repo.findAll().length, 3);
      repo.removeAll();
      expect(repo.findAll(), []);
    });

    test('removeWhere', () {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect(repo.findAll().length, 3);
      repo.removeWhere((p) => p.age > 18);
      expect(repo.findAll(), [bar, foo]);
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

  @override
  String toString() {
    return 'Person{name: $name, age: $age}';
  }
}

class PersonDesSer extends DesSer<Person> {
  @override
  Person deserialize(String s) {
    var split = s.split(",");
    return new Person(split[0], int.parse(split[1]));
  }

  @override
  String serialize(Person t) {
    return "${t.name},${t.age}";
  }

  @override
  String get key => "Person";
}
