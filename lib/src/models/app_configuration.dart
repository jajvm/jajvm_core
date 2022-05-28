import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../constants/environment_variables.dart';

final appConfigurationProvider = StateNotifierProvider<AppConfiguration, AppConfigurationModel>((ref) {
  // TODO: Read previous cached directory from database. kJajvmHome is different, move files to new directory
  return AppConfiguration(
    AppConfigurationModel(cacheDirectory: kJajvmHome),
  );
});

class AppConfiguration extends StateNotifier<AppConfigurationModel> {
  AppConfiguration(super.state);
}

class AppConfigurationModel extends Equatable {
  final String cacheDirectory;

  AppConfigurationModel({
    required this.cacheDirectory,
  });

  AppConfigurationModel copyWith({
    String? cacheDirectory,
  }) {
    return AppConfigurationModel(
      cacheDirectory: cacheDirectory ?? this.cacheDirectory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cacheDirectory': cacheDirectory,
    };
  }

  factory AppConfigurationModel.fromMap(Map<String, dynamic> map) {
    return AppConfigurationModel(
      cacheDirectory: map['cacheDirectory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppConfigurationModel.fromJson(String source) =>
      AppConfigurationModel.fromMap(json.decode(source));

  @override
  String toString() => 'AppConfigurationModel(cacheDirectory: $cacheDirectory)';

  @override
  List<Object> get props => [cacheDirectory];
}
