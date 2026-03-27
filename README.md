# pref_dessert
[![pub package](https://img.shields.io/pub/v/pref_dessert.svg)](https://pub.dev/packages/pref_dessert) [![Flutter](https://github.com/bartektartanus/pref_dessert/actions/workflows/dart.yml/badge.svg)](https://github.com/bartektartanus/pref_dessert/actions/workflows/dart.yml) [![codecov](https://codecov.io/gh/bartektartanus/pref_dessert/branch/master/graph/badge.svg)](https://codecov.io/gh/bartektartanus/pref_dessert)

Package that allows you persist objects as shared preferences easily. Package name comes from: Shared PREFerences DESerializer/SERializer of T (generic) class.

## Getting Started

To use this package you just need to extend `DesSer<T>` class, replace generic T class with the one you want to save in shared preferences. This class requires you to implement two methods to serialize and deserialize objects. Then pass this class along with a `SharedPreferences` instance to `PreferencesRepository` and you're good to go!

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
```

You can also do this using JSON with `dart:convert`:

```dart
import 'dart:convert';

class JsonPersonDesSer extends DesSer<Person> {
  @override
  Person deserialize(String s) {
    var map = json.decode(s);
    return Person(map['name'] as String, map['age'] as int);
  }

  @override
  String serialize(Person t) {
    return json.encode({"name": t.name, "age": t.age});
  }

  @override
  String get key => "Person";
}
```

Then create a `PreferencesRepository<T>` with a `SharedPreferences` instance:
```dart
var prefs = await SharedPreferences.getInstance();
var repo = PreferencesRepository<Person>(prefs, PersonDesSer());
repo.save(Person("FooBar", 42));
var list = repo.findAll();
```

For storing a single element, use `SingleElementPreferencesRepository<T>`:
```dart
var prefs = await SharedPreferences.getInstance();
var repo = SingleElementPreferencesRepository<Person>(prefs, PersonDesSer());
repo.save(Person("FooBar", 42));
var person = repo.find(); // returns Person?
```

### Using `json_serializable` package to generate DesSer

Step 1: Add [json_serializable](https://pub.dev/packages/json_serializable) to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  pref_dessert: ^1.0.0
  json_annotation: ^4.11.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  json_serializable: ^6.13.0
```

Step 2: Create your class with `@JsonSerializable` annotation:

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:pref_dessert/pref_dessert.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String photoUrl;
  final String displayName;
  final String email;

  User({required this.uid, required this.photoUrl, required this.displayName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserDesSer extends JsonDesSer<User> {
  @override
  String get key => "PREF_USER";

  @override
  User fromMap(Map<String, dynamic> map) => User.fromJson(map);

  @override
  Map<String, dynamic> toMap(User user) => user.toJson();
}
```

Step 3: Run code generation: `dart run build_runner build`
