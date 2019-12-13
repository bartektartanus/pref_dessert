
import 'package:pref_dessert/pref_dessert.dart';

/// Person class that you want to serialize:
class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

/// PersonDesSer which extends DesSer<T> and implements two methods which serialize this objects using CSV format:
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

  @override
  String get key => "Person";

}

void main() {
  var repo = new FuturePreferencesRepository<Person>(new PersonDesSer());
  repo.save(new Person("Foo", 42));
  repo.save(new Person("Bar", 1));
  var list = repo.findAll();

}
