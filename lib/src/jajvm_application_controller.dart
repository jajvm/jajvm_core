import 'package:riverpod/riverpod.dart';

import 'constants/constants.dart';
import 'models/java_project.dart';
import 'models/java_release.dart';

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
  Future<void> initialize({bool setCurrentJavaHomeAsDefault = false}) async {
    // Create jajvm folder if it does not exist

    // If setCurrentJavaHomeAsDefault is true, set the current java release as the default
    // - Copy the current JAVA_HOME folder to the jajvm `versions` folder
    // - Create symlink at `~/jajvm/default` which points to `~/jajvm/versions/<new-release>`
    // - reinitializeEnvironment()
  }

  /// Set java release as global default
  Future<void> setGlobalJavaRelease(JavaRelease release) async {
    // Update symlink at `~/jajvm/default` to point to `release.directory.path`
  }

  /// Reinitialize environment variables
  Future<void> reinitializeEnvironment() async {
    // Set JAVA_HOME to `~/jajvm/default`
    // Remove all java releases from PATH
    // Add `~/jajvm/default/bin` to PATH
  }

  /// Copy java release on system to jajvm's version directory
  Future<void> copyJavaRelease(String releasePath) async {
    // User inputs required path to java folder

    // Verify the folder is a valid java installation

    // Try to figure out java version
    // - If fails, user inputs java version

    // Try to figure out vender
    // - If fails, user inputs required vender

    // User inputs optional nickname, defaults to normalized folder path
  }

  /// Search file system for valid java releases
  Future<List<JavaRelease>> searchForJavaReleases(String root) async {
    // Search for java releases on the system recursively starting from [root]
    // - If found, create JavaRelease object and add to list
    // - If none found, return empty list
    // Exit condition: Folder has no unvisited subfolders
    return [];
  }

  /// Change terminal session's java release
  Future<void> changeTerminalSessionJavaRelease(JavaRelease release) async {}

  /// Use java version in folder and its children
  Future<void> useJavaReleaseInFolder({
    required String path,
    required JavaRelease release,
  }) async {}

  /// Delete java release from jajvm's `versions` directory
  ///
  /// Fails if the release is the default release, unless [force] is `true`
  ///
  /// Returns `true` if the release was deleted, `false` otherwise
  Future<bool> deleteJavaRelease(JavaRelease release) async {
    return false;
  }

  /// List java releases in jajvm's versions directory
  Future<List<JavaRelease>> listJavaReleases() async {
    return [];
  }

  /// Install Java version from a supported vender
  Future<void> installJavaVersion(String version, String vender) async {}

  /// Purge jajvm folder
  ///
  /// This deletes all saved java releases and symlinks
  Future<void> purge() async {
    // Delete `~/jajvm` folder recursively

    // Clear JAVA_HOME and remove itself from PATH
  }

  /// List Java projects in database
  Future<List<JavaProject>> listProjects() async {
    // List all projects in database
    return [];
  }

  /// Add java project to database
  Future<void> addProject(String path) async {
    // Verify path is a valid java project

    // Add project to database
  }

  /// Find all java projects on system
  Future<List<JavaProject>> findProjects() async {
    // Find all java projects on system recursively
    // - If found, create JavaProject object and add to list
    // - If none found, return empty list
    // Exit condition: Folder has no unvisited subfolders
    return [];
  }

  /// Open project in editor of choice
  Future<void> openProjectInEditor(JavaProject project, String editor) async {
    // Open project in editor of choice
  }
}
