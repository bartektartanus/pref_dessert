# pref_dessert
[![pub package](https://img.shields.io/pub/v/pref_dessert.svg)](https://pub.dartlang.org/packages/pref_dessert) [![Build Status](https://travis-ci.org/bartektartanus/pref_dessert.svg?branch=master)](https://travis-ci.org/bartektartanus/pref_dessert)

Package that allows you persist objects as shared preferences easily. Package name comes from: Shared PREFerences DESerializer/SERializer of T (generic) class.

## Getting Started

To use this package you just need to extend `DesSer<T>` class, replace generic T class with the one you want to save in shared preferences. This class requires you to implement two methods to serialize and deserialize objects. In future releases I'm planning to use JSON serializer so it will be much simpler to use. Then pass this class to `PreferenceRepository` or `FuturePreferencesRepository` and you're good to go!

## Example

`Person` class that you want to serialize:
```dart

class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

``` 

`PersonDesSer` which extends `DesSer<T>` and implements two methods which serialize this objects using CSV format:
```dart

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
```

You can also do this using JSON with `convert` package:

```dart
import 'dart:convert';

class JsonPersonDesSer extends DesSer<Person>{
  @override
  Person deserialize(String s) {
    var map = json.decode(s);
    return new Person(map['name'] as String, map['age'] as int);
  }

  @override
  String serialize(Person t) {
    var map = {"name":t.name, "age":t.age};
    return json.encode(map);
  }

}
```

Then create an instance of either class and pass it to the `FuturePreferencesRepository<T>`:
```dart
var repo = new FuturePreferencesRepository<Person>(new PersonDesSer());
repo.save(new Person("FooBar", 42));
var list = repo.findAll();
```
