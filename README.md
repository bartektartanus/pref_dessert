# pref_dessert

Package that allows you persist objects as shared preferences easily. Package name comes from: Shared PREFerences DESerializer/SERializer of T (generic) class.

## Getting Started

To use this package you just need to extend `PreferencesRepository<T>` class, replace generic T class with the one you want to save in shared preferences. This class requires you to implement two methods to serialize and deserialize objects. In future releases I'm planning to use JSON serializer so it will be much simpler to use.

## Example

`Person` class that you want to serialize:
```dart

class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

``` 

`PersonRepository` which extends `PreferencesRepository` and implements two methods:
```dart

class PersonRepository extends PreferencesRepository<Person>{
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
```

Usage in code:
```dart
var repo = new PersonRepository();
repo.save(new Person("FooBar", 42));
var list = repo.getAll();
```