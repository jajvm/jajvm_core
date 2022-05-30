import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class JavaRelease extends Equatable {
  /// The directory of this release
  final Directory directory;
  String get path => directory.path;

  /// The version number of the Java release
  final String? version;

  /// The name of the vendor given by the user
  final String? vendor;

  /// The unique nickname given by the user for this
  final String? alias;

  late final String id;

  static const _uuid = Uuid();

  factory JavaRelease.fromPath({
    required String path,
    String? version,
    String? vendor,
    String? alias,
    String? id,
  }) =>
      JavaRelease(
        directory: Directory(path),
        version: version,
        vendor: vendor,
        alias: alias,
        id: id,
      );

  JavaRelease({
    required this.directory,
    this.version,
    this.vendor,
    this.alias,
    String? id,
  }) {
    this.id = id ?? _uuid.v4();
  }

  JavaRelease copyWith({
    Directory? directory,
    String? version,
    String? vendor,
    String? alias,
    String? id,
  }) {
    return JavaRelease(
      directory: directory ?? this.directory,
      version: version ?? this.version,
      vendor: vendor ?? this.vendor,
      alias: alias ?? this.alias,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directory': directory.path,
      'version': version,
      'vendor': vendor,
      'alias': alias,
      'id': id,
    };
  }

  factory JavaRelease.fromMap(Map<String, dynamic> map) {
    return JavaRelease(
      directory: Directory(map['directory']),
      version: map['version'],
      vendor: map['vendor'],
      alias: map['alias'],
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaRelease.fromJson(String source) =>
      JavaRelease.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JavaRelease(directory: $directory, version: $version, vendor: $vendor, alias: $alias, id: $id)';
  }

  @override
  List<Object> get props {
    return [
      directory,
      version ?? 'no version',
      vendor ?? 'no vendor',
      alias ?? 'no alias',
      id,
    ];
  }
}
