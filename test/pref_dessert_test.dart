import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late PreferencesRepository<Person> repo;
  var bartek = new Person("Bartek", 22);
  var bar = new Person("Bar", 1);
  var foo = new Person("Foo", 2);
  var stefan = new Person("Stefan", 42);

  group("PreferencesRepository", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
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

    test('save all', () {
      repo.saveAll([bartek, foo]);
      expect(repo.findAll(), [bartek, foo]);

      repo.saveAll([foo]);
      expect(repo.findAll(), [bartek, foo, foo]);

      repo.saveAll([bar]);
      expect(repo.findAll(), [bartek, foo, foo, bar]);
    });

    test('find one', () {
      var id = repo.save(bartek);
      expect(id, 0);
      var one = repo.findOne(0);
      expect(one, bartek);
    });

    test('find all where', () {
      repo.saveAll([bartek, bar, foo]);
      expect(repo.findAllWhere((p) => p.age > 20), [bartek]);
      expect(repo.findAllWhere((p) => p.age < 20), [bar, foo]);
      expect(repo.findAllWhere((p) => p.age > 0), [bartek, bar, foo]);
    });

    test('find first where', () {
      repo.saveAll([bartek, bar, foo]);
      expect(repo.findFirstWhere((p) => p.age > 20), bartek);
      expect(repo.findFirstWhere((p) => p.age < 20), bar);
      expect(repo.findFirstWhere((p) => p.age > 0), bartek);
      expect(repo.findFirstWhere((p) => p.age > 0, orElse: () => stefan), bartek);
      expect(repo.findFirstWhere((p) => p.age < 0, orElse: () => stefan), stefan);
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

    test('updateWhere', () {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect(repo.findAll().length, 3);
      bartek.name = "Bartolini";
      bartek.age += 10;
      repo.updateWhere((p) => p.age > 0, bartek);
      expect(repo.findAll(), [bartek, bartek, bartek]);
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
      other is Person && runtimeType == other.runtimeType && name == other.name && age == other.age;

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
