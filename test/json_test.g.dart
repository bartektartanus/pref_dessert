// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) =>
    new Person(json['name'] as String, json['age'] as int);

abstract class _$PersonSerializerMixin {
  String get name;
  int get age;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'age': age};
}
