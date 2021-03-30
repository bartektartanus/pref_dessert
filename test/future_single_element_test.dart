import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pref_dessert_test.dart';

void main() {
  late FutureSingleElementPreferencesRepository<Person> repo;
  var bartek = new Person("Bartek", 22);
  var bar = new Person("Bar", 1);
  var foo = new Person("Foo", 2);

  group("FutureSingleElementPreferencesRepository", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await SharedPreferences.getInstance().then((p) {
        repo = new FutureSingleElementPreferencesRepository<Person>(new PersonDesSer());
      });
    });

    setUp(() async {
      await repo.remove();
    });

    test('save and remove person', () async {
      expect(await repo.find(), null);
      repo.save(bartek);
      expect(await repo.find(), bartek);
      repo.remove();
      expect(await repo.find(), null);
    });

    test('overwrite previous element', () async {
      expect(await repo.find(), null);
      repo.save(bartek);
      expect(await repo.find(), bartek);
      repo.save(foo);
      expect(await repo.find(), foo);
      repo.remove();
      expect(await repo.find(), null);
    });
  });

}
