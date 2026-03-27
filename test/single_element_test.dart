import 'package:flutter_test/flutter_test.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pref_dessert_test.dart';

void main() {
  late SingleElementPreferencesRepository<Person> repo;
  var bartek = Person("Bartek", 22);
  var foo = Person("Foo", 2);

  group("SingleElementPreferencesRepository", () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      var prefs = await SharedPreferences.getInstance();
      repo = SingleElementPreferencesRepository<Person>(prefs, PersonDesSer());
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
