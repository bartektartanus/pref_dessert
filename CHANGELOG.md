## 1.0.0
* **BREAKING**: migrated to Dart 3 / Flutter 3 (SDK constraint `^3.8.0`)
* **BREAKING**: removed `FuturePreferencesRepository` and `FutureSingleElementPreferencesRepository` — use the sync variants with `await SharedPreferences.getInstance()` instead
* **BREAKING**: `remove(index)` now returns `void` instead of `List<T>` for consistency with other mutation methods
* replaced `part`/`part of` with regular imports
* fixed bug where `remove(index)` did not persist the removal to SharedPreferences
* fixed `_update` to use direct list assignment instead of `removeAt` + `insert`
* simplified `SingleElementPreferencesRepository.find()` — removed redundant key lookup
* removed dead `_key` field in `FutureSingleElementPreferencesRepository` that shadowed the parent
* modernized function type syntax (`bool Function(T)` instead of `bool test(T)`)
* updated dependencies: `shared_preferences ^2.5.0`, `json_annotation ^4.11.0`, `json_serializable ^6.13.0`
* added missing test for `remove(index)`

## 0.8.0
* dependency update

## 0.7.0
* dependency update

## 0.6.0
* migration to null-safety and Dart 2.12
* dependency update

## 0.5.1
* removed deprecated `author` tag from `pubspec.yaml`
* added test coverage to travis build
* more tests
* `SharedPreferences` fields are now `final`

## 0.5.0+1
* fixed some tests

## 0.5.0
* new method - `updateWhere`

## 0.4.0+1
* code reformat

## 0.4.0
* dependency update
* issue #4 key feature is not working.

## 0.3.0
* shared_preferences dependency update

## 0.2.3
* `test` version update

## 0.2.2
* `Dart` and `shared_preferences` version update

## 0.2.1
* added SingleElementPreferencesRepository is simplified version of PreferencesRepository 
which only stores one value

## 0.1.0
* added `removeWhere` method

## 0.0.10
* source code reformatted

## 0.0.9
* added `saveAll` method 

## 0.0.8
* fixed bug with shared preferences key

## 0.0.7
* `update` method bug-fix

## 0.0.6
* added example and more comments in code

## 0.0.5
* tests bug fix

## 0.0.4
* There are now two repository classes - 'normal' and `Future` version
* Added more methods to repository classes
* `DesSer<T>` class for DESserializing and SERializing classes instead of two abstract methods in `PreferencesRepository`

## 0.0.2
* Better description with example
* Test for class serialization with json.

## 0.0.1

* First version
