import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pref_dessert_test.dart';

void main() {
  SingleElementPreferencesRepository<Person> repo;
  var bartek = new Person("Bartek", 22);
  var bar = new Person("Bar", 1);
  var foo = new Person("Foo", 2);

  group("PreferencesRepository", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      Future.wait([
        SharedPreferences.getInstance().then((p) {
          repo = new SingleElementPreferencesRepository<Person>(
              p, new PersonDesSer());
        })
      ]);
    });

    setUp(() {
      repo.remove();
    });

    test('save and remove person', () {
      expect(repo.find(), null);
      repo.save(bartek);
      expect(repo.find(), bartek);
      repo.remove();
      expect(repo.find(), null);
    });

    test('overwrite previous element', () {
      expect(repo.find(), null);
      repo.save(bartek);
      expect(repo.find(), bartek);
      repo.save(foo);
      expect(repo.find(), foo);
      repo.remove();
      expect(repo.find(), null);
    });
  });
}
