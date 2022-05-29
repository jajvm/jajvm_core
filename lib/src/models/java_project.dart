import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';

import 'java_release.dart';

class JavaProject extends Equatable {
  /// The directory of this release
  final Directory directory;

  String get name => directory.path.split('/').last;
  String get path => directory.path;

  /// The configured Java release
  ///
  /// If null, the default Java release is used
  final JavaRelease? release;

  const JavaProject({
    required this.directory,
    required this.release,
  });

  JavaProject copyWith({
    Directory? directory,
    JavaRelease? release,
  }) {
    return JavaProject(
      directory: directory ?? this.directory,
      release: release ?? this.release,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directory': directory.path,
      'release': release?.toMap(),
    };
  }

  factory JavaProject.fromMap(Map<String, dynamic> map) {
    return JavaProject(
      directory: Directory(map['directory']),
      release:
          map['release'] != null ? JavaRelease.fromMap(map['release']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaProject.fromJson(String source) =>
      JavaProject.fromMap(json.decode(source));

  @override
  String toString() => 'JavaProject(directory: $directory, release: $release)';

  @override
  List<Object> get props => [directory, release ?? 'no release specified'];
}
