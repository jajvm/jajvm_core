import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';

class JavaRelease extends Equatable {
  /// The directory of this release
  final Directory directory;
  String get path => directory.path;

  /// The version number of the Java release
  final String? version;

  /// The name of the vender given by the user
  final String? vender;

  /// The unique nickname given by the user for this
  final String? alias;

  factory JavaRelease.fromPath({
    required String path,
    String? version,
    String? vender,
    String? alias,
  }) =>
      JavaRelease(
        directory: Directory(path),
        version: version,
        vender: vender,
        alias: alias,
      );

  const JavaRelease({
    required this.directory,
    this.version,
    this.vender,
    this.alias,
  });

  JavaRelease copyWith({
    Directory? directory,
    String? version,
    String? vender,
    String? alias,
  }) {
    return JavaRelease(
      directory: directory ?? this.directory,
      version: version ?? this.version,
      vender: vender ?? this.vender,
      alias: alias ?? this.alias,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directory': directory.path,
      'version': version,
      'vender': vender,
      'alias': alias,
    };
  }

  factory JavaRelease.fromMap(Map<String, dynamic> map) {
    return JavaRelease(
      directory: Directory(map['directory']),
      version: map['version'] ?? '',
      vender: map['vender'] ?? '',
      alias: map['nickname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaRelease.fromJson(String source) =>
      JavaRelease.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JavaRelease(directory: $directory, version: $version, vender: $vender, nickname: $alias)';
  }

  @override
  List<Object> get props => [
        directory,
        version ?? 'no version',
        vender ?? 'no vender',
        alias ?? 'no alias',
      ];
}
