# pref_dessert
[![pub package](https://img.shields.io/pub/v/pref_dessert.svg)](https://pub.dartlang.org/packages/pref_dessert) [![Build Status](https://travis-ci.org/bartektartanus/pref_dessert.svg?branch=master)](https://travis-ci.org/bartektartanus/pref_dessert) [![codecov](https://codecov.io/gh/bartektartanus/pref_dessert/branch/master/graph/badge.svg)](https://codecov.io/gh/bartektartanus/pref_dessert)
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
### Using `json_serializable` package to generate DesSer

Step 1: import library  [json_serializable.](https://pub.dev/packages/json_serializable) in _pubspec.yaml_

```yaml
dependencies:
  flutter:
    sdk: flutter
  pref_dessert: ^0.4.0+1
  json_serializable: ^3.2.2
  json_annotation: ^3.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^1.0.0
```

Step 2:  Create your class with annotation `@JsonSerializable`

```dart
import 'package:pref_dessert/pref_dessert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String uid = "";
  String photoUrl = "";
  String displayName = "";
  String email = "";

  User({this.uid, this.photoUrl, this.displayName, this.email});
}

class UserDesSer extends JsonDesSer<User> {
  @override
  String get key => "PREF_USER";

  @override
  User fromMap(Map<String, dynamic> map) => _$UserFromJson(map);

  @override
  Map<String, dynamic> toMap(User user) => _$UserToJson(user);
}

```

Step 3: Run command :  `flutter pub run build_runner build` 
