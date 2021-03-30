import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pref_dessert/pref_dessert.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FuturePreferencesRepository<Person> repo;
  var bartek = new Person("Bartek", 22);
  var bar = new Person("Bar", 1);
  var foo = new Person("Foo", 2);
  var stefan = new Person("Stefan", 42);

  group("PreferencesRepository", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await Future.wait([
        SharedPreferences.getInstance().then((p) {
          repo = new FuturePreferencesRepository<Person>(new PersonDesSer());
        })
      ]);
    });

    setUp(() {
      repo.removeAll();
    });

    test('save person', () async {
      var id = await repo.save(bartek);
      expect(id, 0);

      var all = await repo.findAll();
      expect(all, [bartek]);

      var fooId = await repo.save(foo);
      expect(fooId, 1);

      all = await repo.findAll();
      expect(all, [bartek, foo]);
    });


    test('save all', () async {
      await repo.saveAll([bartek, foo]);
      expect(await repo.findAll(), [bartek, foo]);

      await repo.saveAll([foo]);
      expect(await repo.findAll(), [bartek, foo, foo]);

      await repo.saveAll([bar]);
      expect(await repo.findAll(), [bartek, foo, foo, bar]);
    });

    test('find one', () async {
      var id = await repo.save(bartek);
      expect(id, 0);
      var one = await repo.findOne(0);
      expect(one, bartek);
    });

    test('find all where', () async {
      await repo.saveAll([bartek, bar, foo]);
      expect(await repo.findAllWhere((p) => p.age > 20), [bartek]);
      expect(await repo.findAllWhere((p) => p.age < 20), [bar, foo]);
      expect(await repo.findAllWhere((p) => p.age > 0), [bartek, bar, foo]);
    });

    test('find first where', () async {
      await repo.saveAll([bartek, bar, foo]);
      expect(await repo.findFirstWhere((p) => p.age > 20), bartek);
      expect(await repo.findFirstWhere((p) => p.age < 20), bar);
      expect(await repo.findFirstWhere((p) => p.age > 0), bartek);
      expect(await repo.findFirstWhere((p) => p.age > 0, orElse: () => stefan), bartek);
      expect(await repo.findFirstWhere((p) => p.age < 0, orElse: () => stefan), stefan);
    });

    test('update', () async {
      await repo.save(bar);
      await repo.save(bartek);
      await repo.save(foo);
      expect((await repo.findAll()).length, 3);
      bartek.name = "Bartolini";
      bartek.age += 10;
      repo.update(1, bartek);
      expect(await repo.findAll(), [bar, bartek, foo]);
    });

    test('updateWhere', () async {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect((await repo.findAll()).length, 3);
      bartek.name = "Bartolini";
      bartek.age += 10;
      repo.updateWhere((p) => p.age > 0, bartek);
      expect(await repo.findAll(), [bartek, bartek, bartek]);
    });

    test('removeAll', () async {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect((await repo.findAll()).length, 3);
      repo.removeAll();
      expect(await repo.findAll(), []);
    });

    test('removeWhere', () async {
      repo.save(bar);
      repo.save(bartek);
      repo.save(foo);
      expect((await repo.findAll()).length, 3);
      repo.removeWhere((p) => p.age > 18);
      expect(await repo.findAll(), [bar, foo]);
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
