import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Person class that you want to serialize:
class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

/// PersonDesSer which extends DesSer<T> and implements two methods which serialize this objects using CSV format:
class PersonDesSer extends DesSer<Person> {
  @override
  Person deserialize(String s) {
    var split = s.split(",");
    return Person(split[0], int.parse(split[1]));
  }

  @override
  String serialize(Person t) {
    return "${t.name},${t.age}";
  }

  @override
  String get key => "Person";
}

void main() async {
  var prefs = await SharedPreferences.getInstance();
  var repo = PreferencesRepository<Person>(prefs, PersonDesSer());
  repo.save(Person("Foo", 42));
  repo.save(Person("Bar", 1));
  var list = repo.findAll();
  print(list);
}
