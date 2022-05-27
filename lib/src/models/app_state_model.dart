import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'java_release.dart';

class AppStateModel extends Equatable {
  final JavaRelease? globalJavaRelease;
  final List<JavaRelease> javaDirectories;

  const AppStateModel({
    this.globalJavaRelease,
    this.javaDirectories = const [],
  });

  AppStateModel copyWith({
    JavaRelease? globalJavaRelease,
    List<JavaRelease>? javaDirectories,
  }) {
    return AppStateModel(
      globalJavaRelease: globalJavaRelease ?? this.globalJavaRelease,
      javaDirectories: javaDirectories ?? this.javaDirectories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'globalJavaRelease': globalJavaRelease?.toMap(),
      'javaDirectories': javaDirectories.map((x) => x.toMap()).toList(),
    };
  }

  factory AppStateModel.fromMap(Map<String, dynamic> map) {
    return AppStateModel(
      globalJavaRelease: map['globalJavaRelease'] != null ? JavaRelease.fromMap(map['globalJavaRelease']) : null,
      // ignore: unnecessary_lambdas
      javaDirectories: List<JavaRelease>.from(map['javaDirectories']?.map((x) => JavaRelease.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppStateModel.fromJson(String source) => AppStateModel.fromMap(json.decode(source));

  @override
  String toString() => 'AppStateModel(globalJavaRelease: $globalJavaRelease, javaDirectories: $javaDirectories)';

  @override
  List<Object> get props => [globalJavaRelease ?? '', javaDirectories];
}
