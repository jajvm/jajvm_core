import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class JavaRelease extends Equatable {
  /// The directory of this release
  final Directory directory;
  String get path => directory.path;

  /// The unique nickname given by the user for this
  final String? alias;

  /// Parsed from the java `release` file
  final String? javaVersion;

  /// Parsed from the java `release` file
  final String? javaVersionDate;

  /// Parsed from the java `release` file
  final String? implementor;

  /// Parsed from the java `release` file
  final String? implementorVersion;

  final String? modules;

  final String? osArchitecture;

  final String? osName;

  final String? fullVersion;

  final String? semanticVersion;

  final String? buildInfo;

  final String? jvmVariant;

  final String? jvmVersion;

  final String? imageType;

  late final String uid;

  static const _uuid = Uuid();

  JavaRelease({
    required this.directory,
    required this.javaVersionDate,
    required this.implementorVersion,
    required this.modules,
    required this.osArchitecture,
    required this.osName,
    required this.fullVersion,
    required this.semanticVersion,
    required this.buildInfo,
    required this.jvmVariant,
    required this.jvmVersion,
    required this.imageType,
    required this.javaVersion,
    required this.implementor,
    required this.alias,
    required String? uid,
  }) {
    this.uid = uid ?? _uuid.v4();
  }

  factory JavaRelease.fromPath({
    required String path,
    String? javaVersionDate,
    String? javaVersion,
    String? implementorVersion,
    String? implementor,
    String? modules,
    String? osArchitecture,
    String? osName,
    String? fullVersion,
    String? semanticVersion,
    String? buildInfo,
    String? jvmVariant,
    String? jvmVersion,
    String? imageType,
    String? alias,
    String? uid,
  }) =>
      JavaRelease(
        directory: Directory(path),
        javaVersion: javaVersion,
        implementor: implementor,
        alias: alias,
        uid: uid,
        buildInfo: buildInfo,
        fullVersion: fullVersion,
        imageType: imageType,
        implementorVersion: implementorVersion,
        javaVersionDate: javaVersionDate,
        jvmVariant: jvmVariant,
        jvmVersion: jvmVersion,
        modules: modules,
        osArchitecture: osArchitecture,
        osName: osName,
        semanticVersion: semanticVersion,
      );

  JavaRelease copyWith({
    Directory? directory,
    String? alias,
    String? javaVersion,
    String? javaVersionDate,
    String? implementor,
    String? implementorVersion,
    String? modules,
    String? osArchitecture,
    String? osName,
    String? fullVersion,
    String? semanticVersion,
    String? buildInfo,
    String? jvmVariant,
    String? jvmVersion,
    String? imageType,
    String? uid,
  }) {
    return JavaRelease(
      directory: directory ?? this.directory,
      alias: alias ?? this.alias,
      javaVersion: javaVersion ?? this.javaVersion,
      javaVersionDate: javaVersionDate ?? this.javaVersionDate,
      implementor: implementor ?? this.implementor,
      implementorVersion: implementorVersion ?? this.implementorVersion,
      modules: modules ?? this.modules,
      osArchitecture: osArchitecture ?? this.osArchitecture,
      osName: osName ?? this.osName,
      fullVersion: fullVersion ?? this.fullVersion,
      semanticVersion: semanticVersion ?? this.semanticVersion,
      buildInfo: buildInfo ?? this.buildInfo,
      jvmVariant: jvmVariant ?? this.jvmVariant,
      jvmVersion: jvmVersion ?? this.jvmVersion,
      imageType: imageType ?? this.imageType,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directory': directory.path,
      'alias': alias,
      'javaVersion': javaVersion,
      'javaVersionDate': javaVersionDate,
      'implementor': implementor,
      'implementorVersion': implementorVersion,
      'modules': modules,
      'osArchitecture': osArchitecture,
      'osName': osName,
      'fullVersion': fullVersion,
      'semanticVersion': semanticVersion,
      'buildInfo': buildInfo,
      'jvmVariant': jvmVariant,
      'jvmVersion': jvmVersion,
      'imageType': imageType,
      'uid': uid,
    };
  }

  factory JavaRelease.fromMap(Map<String, dynamic> map) {
    return JavaRelease(
      directory: Directory(map['directory']),
      alias: map['alias'],
      javaVersion: map['javaVersion'],
      javaVersionDate: map['javaVersionDate'],
      implementor: map['implementor'],
      implementorVersion: map['implementorVersion'],
      modules: map['modules'],
      osArchitecture: map['osArchitecture'],
      osName: map['osName'],
      fullVersion: map['fullVersion'],
      semanticVersion: map['semanticVersion'],
      buildInfo: map['buildInfo'],
      jvmVariant: map['jvmVariant'],
      jvmVersion: map['jvmVersion'],
      imageType: map['imageType'],
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaRelease.fromJson(String source) =>
      JavaRelease.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JavaRelease(directory: $directory, alias: $alias, javaVersion: $javaVersion, javaVersionDate: $javaVersionDate, implementor: $implementor, implementorVersion: $implementorVersion, modules: $modules, osArchitecture: $osArchitecture, osName: $osName, fullVersion: $fullVersion, semanticVersion: $semanticVersion, buildInfo: $buildInfo, jvmVariant: $jvmVariant, jvmVersion: $jvmVersion, imageType: $imageType, uid: $uid)';
  }

  @override
  List<Object> get props {
    return [
      directory,
      alias ?? '',
      javaVersion ?? '',
      javaVersionDate ?? '',
      implementor ?? '',
      implementorVersion ?? '',
      modules ?? '',
      osArchitecture ?? '',
      osName ?? '',
      fullVersion ?? '',
      semanticVersion ?? '',
      buildInfo ?? '',
      jvmVariant ?? '',
      jvmVersion ?? '',
      imageType ?? '',
      uid,
    ];
  }
}
