import 'dart:io' as io;

import 'package:riverpod/riverpod.dart';

import 'constants/env_vars.dart';
import 'exceptions/jajvm_exception.dart';
import 'models/java_project.dart';
import 'models/java_release.dart';
import 'services/file_system_service.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

final jajvmApplicationControllerProvider = Provider((ref) {
  final FileSystemService fileSystemService = ref.watch(fileSystemProvider);

  return JajvmApplicationController(
    fileSystemService: fileSystemService,
  );
});

class JajvmApplicationController {
  JajvmApplicationController({
    FileSystemService? fileSystemService,
  }) : fileSystemService = fileSystemService ?? FileSystemService();

  String get cacheDirectory => kJajvmHome;

  /// The file system service which can be injected for testing purposes
  final FileSystemService fileSystemService;

  /// Initialize application: Creates jajvm folders and symlinks,
  /// and optionally sets the default java release to the java version
  /// already installed after copying it to the jajvm `versions` folder.
  ///
  /// Throws [JajvmException] if it fails to create the folder or symlink
  Future<void> initialize({bool setCurrentJavaHomeAsDefault = false}) async {
    // Create jajvm folder if it does not exist
    fileSystemService
      ..createJajvmFolder()
      ..createVersionsFolder();

    // If setCurrentJavaHomeAsDefault is true, set the current java release as the default
    // - Copy the current JAVA_HOME folder to the jajvm `versions` folder
    // - Create symlink at `~/jajvm/default` which points to `~/jajvm/versions/<new-release>`
    // - reinitializeEnvironment()
    if (!setCurrentJavaHomeAsDefault) return;

    final currentJavaHome = kJavaHomeDirectory;
    if (currentJavaHome == null) return;

    final JavaRelease javaRelease = await copySystemJavaRelease(
      path: currentJavaHome.path,
      alias: 'SystemJavaHome', // TODO: Use better name by parsing path for info
    );
    fileSystemService.createSymLink(
      kDefaultLinkPath,
      javaRelease.path,
    );

    await reinitializeEnvironment();
  }

  /// Set java release as global default
  ///
  /// Throws [JajvmException] if it fails to update the symlink
  Future<io.Link> setGlobalJavaRelease(JavaRelease release) async {
    // Update symlink at `~/jajvm/default` to point to `release.directory.path`
    return fileSystemService.updateSymLink(
      kDefaultLinkPath,
      release.path,
    );
  }

  /// Reinitialize environment variables. 
  /// 
  /// TODO: Support platforms other than windows
  ///
  /// Throws [JajvmException] if the environment variables could not be set.
  Future<void> reinitializeEnvironment() async {
    if (!io.Platform.isWindows) throw UnimplementedError();

    // Set JAVA_HOME to `~/jajvm/default`
    await fileSystemService.writeEnvironmentVariable(
      kJavaHomeKey,
      kDefaultLinkPath,
      global: true,
    );

    // Append default java release bin to system PATH if it is not already
    final path = await fileSystemService.readSystemEnvironmentVariables(kPathKey);
    final hasBinInPath = path.trim().contains(kDefaultJavaBinPath);
    if (!hasBinInPath) {
      await fileSystemService.writeEnvironmentVariable(
        kPathKey,
        kDefaultJavaBinPath,
        global: true,
        append: true,
      );
    }

    // Set JAVA_HOME to the default Java release
    final javaHomePath = await fileSystemService.readSystemEnvironmentVariables(kJavaHomeKey);
    final hasJavaInPath = javaHomePath.trim().contains(kDefaultLinkPath);
    if (!hasJavaInPath) {
      await fileSystemService.writeEnvironmentVariable(
        kPathKey,
        kDefaultLinkPath,
        global: true,
      );
    }
  }

  /// Copy java release on system to jajvm's version directory
  Future<JavaRelease> copySystemJavaRelease({
    required String path,
    String? version,
    String? vender,
    String? alias,
  }) async {
    // User inputs required path to java folder

    // Verify the folder is a valid java installation
    // TODO: Figure out how to determine if it is a valid java release

    // Try to figure out java version
    // - If fails, user inputs java version

    // Try to figure out vender
    // - If fails, user inputs required vender

    // User inputs optional nickname, defaults to normalized folder path

    return JavaRelease.fromPath(
      path: path,
      version: version,
      vender: vender,
      alias: alias,
    );
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
