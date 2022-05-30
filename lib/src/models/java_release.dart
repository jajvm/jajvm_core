import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
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

  final String? libc;

  /// Parsed from the java `release` file
  final String? implementor;

  /// Parsed from the java `release` file
  final String? implementorVersion;

  final String? modules;

  final String? osArchitecture;

  final String? osName;

  final String? source;

  final String? buildSource;

  final String? buildSourceRepo;

  final String? sourceRepo;

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
    this.javaVersionDate,
    this.implementorVersion,
    this.modules,
    this.osArchitecture,
    this.osName,
    this.fullVersion,
    this.semanticVersion,
    this.buildInfo,
    this.jvmVariant,
    this.jvmVersion,
    this.imageType,
    this.javaVersion,
    this.libc,
    this.implementor,
    this.alias,
    this.source,
    this.buildSource,
    this.buildSourceRepo,
    this.sourceRepo,
    String? uid,
  }) {
    this.uid = uid ?? _uuid.v4();
  }

  factory JavaRelease.byPath({
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
    String? libc,
    String? source,
    String? buildSource,
    String? buildSourceRepo,
    String? sourceRepo,
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
        libc: libc,
        source: source,
        buildSource: buildSource,
        buildSourceRepo: buildSourceRepo,
        sourceRepo: sourceRepo,
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
    String? libc,
    String? source,
    String? buildSource,
    String? buildSourceRepo,
    String? sourceRepo,
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
      libc: libc ?? this.libc,
      source: source ?? this.source,
      buildSource: buildSource ?? this.buildSource,
      buildSourceRepo: buildSourceRepo ?? this.buildSourceRepo,
      sourceRepo: sourceRepo ?? this.sourceRepo,
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
      'libc': libc,
      'source': source,
      'buildSource': buildSource,
      'buildSourceRepo': buildSourceRepo,
      'sourceRepo': sourceRepo,
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
      libc: map['libc'],
      source: map['source'],
      buildSource: map['buildSource'],
      buildSourceRepo: map['buildSourceRepo'],
      sourceRepo: map['sourceRepo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaRelease.fromJson(String source) =>
      JavaRelease.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      directory,
      alias ?? '',
      javaVersion ?? '',
      javaVersionDate ?? '',
      libc ?? '',
      implementor ?? '',
      implementorVersion ?? '',
      modules ?? '',
      osArchitecture ?? '',
      osName ?? '',
      source ?? '',
      buildSource ?? '',
      buildSourceRepo ?? '',
      sourceRepo ?? '',
      fullVersion ?? '',
      semanticVersion ?? '',
      buildInfo ?? '',
      jvmVariant ?? '',
      jvmVersion ?? '',
      imageType ?? '',
      uid,
    ];
  }

  @override
  String toString() {
    return 'JavaRelease(directory: $directory, alias: $alias, javaVersion: $javaVersion, javaVersionDate: $javaVersionDate, libc: $libc, implementor: $implementor, implementorVersion: $implementorVersion, modules: $modules, osArchitecture: $osArchitecture, osName: $osName, source: $source, buildSource: $buildSource, buildSourceRepo: $buildSourceRepo, sourceRepo: $sourceRepo, fullVersion: $fullVersion, semanticVersion: $semanticVersion, buildInfo: $buildInfo, jvmVariant: $jvmVariant, jvmVersion: $jvmVersion, imageType: $imageType, uid: $uid)';
  }
}
