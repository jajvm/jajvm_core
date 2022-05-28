import 'package:riverpod/riverpod.dart';

import 'constants/constants.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

final jajvmApplicationControllerProvider =
    Provider((ref) => JajvmApplicationController());

class JajvmApplicationController {
  JajvmApplicationController();

  String get cacheDirectory => kJajvmHome;

  /// Initialize application: Creates jajvm folders and symlinks,
  /// and optionally sets the default java release to the java version
  /// already installed after copying it to the jajvm `versions` folder.
  Future<void> initialize({bool setCurrentJavaHomeAsDefault = false}) async {}

  /// Set java release as global default

  /// Reinitialize environment variables

  /// Copy java release on system to jajvm's version directory

  /// Search file system for valid java releases

  /// Change terminal session's java version

  /// Change global java version

  /// Use java version in folder and its children

  /// Delete java release from jajvm's version directory

  /// List java releases in jajvm's version directory

  /// Install Java version from a supported vender

  /// Purge jajvm folder

  /// List Java projects in database

  /// Add java project to database

  /// Find all java projects on system

  /// Open project in editor of choice
}
