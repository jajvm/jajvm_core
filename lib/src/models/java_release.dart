import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';

class JavaRelease extends Equatable {
  /// The directory of this release
  final Directory directory;

  /// The version number of the Java release
  final String version;

  /// The name of the vender given by the user
  final String vender;

  /// The unique nickname given by the user for this
  final String nickname;
  
  const JavaRelease({
    required this.directory,
    required this.version,
    required this.vender,
    required this.nickname,
  });


  JavaRelease copyWith({
    Directory? directory,
    String? version,
    String? vender,
    String? nickname,
  }) {
    return JavaRelease(
      directory: directory ?? this.directory,
      version: version ?? this.version,
      vender: vender ?? this.vender,
      nickname: nickname ?? this.nickname,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'directory': directory.path,
      'version': version,
      'vender': vender,
      'nickname': nickname,
    };
  }

  factory JavaRelease.fromMap(Map<String, dynamic> map) {
    return JavaRelease(
      directory: Directory(map['directory']),
      version: map['version'] ?? '',
      vender: map['vender'] ?? '',
      nickname: map['nickname'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JavaRelease.fromJson(String source) => JavaRelease.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JavaRelease(directory: $directory, version: $version, vender: $vender, nickname: $nickname)';
  }

  @override
  List<Object> get props => [directory, version, vender, nickname];
}
