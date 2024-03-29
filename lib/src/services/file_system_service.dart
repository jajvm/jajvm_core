import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:process_run/shell.dart';
import 'package:riverpod/riverpod.dart';

import '../constants/env_vars.dart';
import '../constants/exception_codes.dart';
import '../constants/supported_platform.dart';
import '../exceptions/jajvm_exception.dart';
import '../models/java_release.dart';
import '../utils/java_version_parser.dart';

final _shellProvider = Provider((ref) => Shell(runInShell: Platform.isWindows));

final _fileSystemProvider = Provider<FileSystemService>((ref) {
  final shell = ref.watch(_shellProvider);
  return FileSystemService(shell);
});

class FileSystemService {
  FileSystemService([Shell? shell])
      : _shell = shell?.clone(runInShell: Platform.isWindows) ??
            Shell(runInShell: Platform.isWindows);

  final Shell _shell;

  /// Riverpod Provider for the instance of this class
  static Provider<FileSystemService> provider = _fileSystemProvider;

  /// Creates the jajvm folder at the directory defined by the
  /// environment variable `JAJVM_HOME`. If `JAJVM_HOME` is not
  /// defined, it defaults to [kUserHome]`/jajvm`.
  Future<void> createJajvmFolder() async {
    return createFolder(await envJajvmHomePath);
  }

  /// Creates the jajvm `versions` folder in the [kJajvmHome] folder.
  Future<void> createVersionsFolder() async {
    return createFolder(await envJajvmVersionPath);
  }

  /// Creates a folder at the given path if it does not exist.
  Future<void> createFolder(String path) async {
    try {
      final dir = Directory(path);
      if (await dir.exists()) return;

      await dir.create(recursive: true);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not create folder at "${e.path}": ${e.message}',
        code: JajvmExceptionCode.createDirectoryFailed,
      );
    }
  }

  /// Updates a [Link] to point to a new path. If a [FileSystemEntity] already
  /// exists at [path], it will be deleted and a new [Link] will be created.
  ///
  /// Throws [JajvmException] if it fails to update the [Link]
  Future<Link> updateSymLink(String path, String target) async {
    try {
      final type = await FileSystemEntity.type(path);
      switch (type) {
        case FileSystemEntityType.directory:
        case FileSystemEntityType.file:
          return createSymLink(path, target);
        case FileSystemEntityType.link:
          return Link(path).update(target);
        case FileSystemEntityType.notFound:
          return createSymLink(path, target);
        case FileSystemEntityType.pipe:
        case FileSystemEntityType.unixDomainSock:
          // TODO(@getBoolean): Unknown if this will fail
          return createSymLink(path, target);
      }

      // Should not get here
      throw StateError('Error: Unknown file system entity type');
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not update symlink at "${e.path}": ${e.message}',
        code: JajvmExceptionCode.updateLinkFailed,
      );
    }
  }

  /// Create a symlink at `path` which points to `target`. On windows, the
  /// application must be running as administrator or have developer mode
  /// enabled: https://bit.ly/3vxRr2M, otherwise it will throw [JajvmException]
  /// with code [JajvmExceptionCode.administratorRequired].
  ///
  /// Throws [JajvmException] if it fails to create the symlink.
  Future<Link> createSymLink(String path, String target) async {
    try {
      final link = Link(path);
      if (await link.exists()) return link;

      if (Platform.isWindows && !await isAdministratorMode()) {
        throw JajvmException(
          message:
              'Exception: Could not create symlink at "$path" to "$target" because not running with elevated priveleges',
          code: JajvmExceptionCode.administratorRequired,
        );
      }

      final type = await FileSystemEntity.type(path);
      switch (type) {
        case FileSystemEntityType.directory:
          await Directory(path).delete(recursive: true);
          break;
        case FileSystemEntityType.file:
          await File(path).delete();
          break;
        case FileSystemEntityType.link:
          await link.delete();
          break;
        case FileSystemEntityType.notFound:
          break;
        case FileSystemEntityType.pipe:
        case FileSystemEntityType.unixDomainSock:
          // TODO(@getBoolean): Can this be deleted?
          break;
      }

      return link.create(target, recursive: true);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not create link from "$path" to "$target": ${e.message}',
        code: JajvmExceptionCode.createLinkFailed,
      );
    } on Exception catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not create link from "$path" to "$target": ${e.toString()}',
        code: JajvmExceptionCode.createLinkFailed,
      );
    }
  }

  /// Checks if the process is running as administrator or root/sudo.
  ///
  /// Throws [JajvmException] if the shell command failed.
  Future<bool> isAdministratorMode() async {
    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          final result =
              await _shell.runExecutableArguments('net', ['session']);
          return !result.outText.contains('Access is denied.');
        default:
          final result = await _shell.runExecutableArguments('whoami', []);
          return result.outText.contains('root');
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not determine if running as administrator: ${e.message}',
        code: JajvmExceptionCode.checkAdministratorFailed,
      );
    }
  }

  /// Read in an environment variable from the system.
  ///
  /// Arguments:
  /// - [key] must not have spaces
  ///
  /// Returns null if the environment variable is not set.
  ///
  /// Throws [JajvmException] if it fails to read the environment variable.
  Future<String?> readEnvironmentVariable(String key) async {
    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          final result =
              await _shell.runExecutableArguments('echo', ['%$key%']);
          final text = result.outText.trim();
          return text == '%$key%' ? null : text;
        default:
          final result = await _shell.runExecutableArguments('printenv', [key]);
          final text = result.outText.trim();
          return text.isEmpty ? null : text;
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not read environment variable "$key": ${e.message}',
        code: JajvmExceptionCode.readEnvironmentFailed,
      );
    }
  }

  /// Read only windows system environment variables.
  ///
  /// Returns null if the environment variable is not set.
  ///
  /// Throws [JajvmException] if it fails to read the environment variable.
  Future<String?> readSystemEnvironmentVariable(String key) async {
    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          final result = await _shell.runExecutableArguments('reg', [
            'query',
            'HKLM\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment /v $key'
          ]);
          if (result.exitCode == 1 ||
              result.outText.contains('Invalid parameter(s)')) {
            return null;
          }
          return result.outText;
        default:
          final result = await _shell
              .runExecutableArguments('cat', [kUnixJajvmGlobalEnvPath]);
          final value = result.outText.trim();
          if (result.exitCode > 0 ||
              value.contains('No such file or directory') ||
              !value.contains('export $key')) {
            return null;
          }

          // Return the part after the equals sign
          return result.outLines
              .firstWhere((line) =>
                  line.trim().startsWith('export') &&
                  line
                      .trim()
                      .replaceFirst('export', '')
                      .trim()
                      .startsWith(key) &&
                  line.trim().replaceFirst(key, '').trim().startsWith('='))
              .replaceFirst('export', '')
              .trimLeft()
              .replaceFirst(key, '')
              .trimLeft()
              .replaceFirst('=', '')
              .trim();
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not read global environment variables: ${e.message}',
        code: JajvmExceptionCode.readEnvironmentFailed,
      );
    }
  }

  /// Write an environment variable to the system
  ///
  /// Arguments:
  /// - [key] must not have spaces
  /// - [value]
  /// - [global] must be running as administrator or root/sudo to use
  ///
  /// Throws [JajvmException] if the environment variable could not be set.
  Future<void> writeEnvironmentVariable({
    required String key,
    required String value,
    bool global = false,
    bool append = false,
  }) async {
    if (global && !await isAdministratorMode()) {
      throw JajvmException(
        message:
            'Exception: Cannot write environment variable: Not running as administrator or developer mode not enabled: https://bit.ly/3vxRr2M',
        code: JajvmExceptionCode.administratorRequired,
      );
    }

    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          // Set the environment variable for the user or system
          final result = await _shell.runExecutableArguments('setx', [
            if (global) ...['/M'],
            key,
            '${shellArgument(value)}${append ? ';%$key%' : ''}',
          ]);
          if (!result.outText.contains('SUCCESS')) {
            throw JajvmException(
              message:
                  'Exception: Could not set environment variable "$key" to "$value"',
              code: JajvmExceptionCode.updateEnvironmentFailed,
            );
          }

          // Set the environment variable in the current session so that
          // the new value can be used immediately instead of having to
          // restart the application.
          await _shell.runExecutableArguments('set', [
            '$key=$value${append ? ';%$key%' : ''}',
          ]);
          final expected =
              await _shell.runExecutableArguments('echo', ['%$key%']);
          if (expected.outText.contains('$key=$value')) return;

          throw JajvmException(
            message:
                'Exception: Could not set environment variable "$key" to "$value"',
            code: JajvmExceptionCode.updateEnvironmentFailed,
          );
        default:
          final environmentFilePath =
              global ? kUnixJajvmGlobalEnvPath : kUnixJajvmUserEnvPath;

          final result = await _shell.run('cat $environmentFilePath');
          final previousValue = result.outText.trim();
          if (previousValue.contains('No such file or directory')) {
            // Global environment file not created
            final results = await _shell.run('''
${global ? 'sudo ' : ''}touch $environmentFilePath
echo export $key=${shellArgument(value)} >> $environmentFilePath
source $environmentFilePath
echo \$$key
''');
            if (results.outText
                .contains('export $key=${shellArgument(value)}')) {
              return;
            }

            throw JajvmException(
              message:
                  'Exception: Could not set environment variable "$key" to "$value"',
              code: JajvmExceptionCode.updateEnvironmentFailed,
            );
          } else if (previousValue
              .contains('export $key=${shellArgument(value)}')) {
            // Already set, do nothing
            return;
          } else {
            // Key exists but value is different
            final strippedValue = previousValue.replaceAll(
                'export $key=${shellArgument(value)}', '');
            // TODO: DANGEROUS - TEST THIS ON VM
            final result = await _shell.run('''
${global ? 'sudo ' : ''}rm $environmentFilePath
touch $environmentFilePath
echo $strippedValue >> $environmentFilePath
echo export $key=${shellArgument(value)} >> $environmentFilePath
source $environmentFilePath
echo \$$key
''');
            if (result.outText
                .contains('export $key=${shellArgument(value)}')) {
              return;
            }

            throw JajvmException(
              message:
                  'Exception: Could not set environment variable "$key" to "$value"',
              code: JajvmExceptionCode.updateEnvironmentFailed,
            );
          }
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not set environment variable "$key" to "$value": ${e.message}',
        code: JajvmExceptionCode.updateEnvironmentFailed,
      );
    }
  }

  /// Remove value from the global (system) environment
  Future<void> removeWindowsGlobalEnvironmentVariable({
    required String key,
    String? value,
    bool global = false,
  }) async {
    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          if (global && !await isAdministratorMode()) {
            throw JajvmException(
              message:
                  'Exception: Cannot write environment variable: Not running as administrator or developer mode not enabled: https://bit.ly/3vxRr2M',
              code: JajvmExceptionCode.administratorRequired,
            );
          }

          await _shell.runExecutableArguments('setx', [
            if (global) ...['/M'],
            key,
            if (value != null) value,
            '/D',
          ]);
          break;
        default:
          break;
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not remove environment variable "$key": ${e.message}',
        code: JajvmExceptionCode.updateEnvironmentFailed,
      );
    }
  }

  /// Parsers the java release file
  ///
  /// Returns null if the file does not exist
  ///
  /// Arguments:
  /// - `path` to the java release directory
  /// - `alias` of the java release. Must be unique.
  ///
  /// Throws [JajvmException] if the file could not be read
  Future<JavaRelease> parseJavaReleaseDetails(String path) async {
    try {
      final releaseFile = File(join(path, 'release'));
      final data = await releaseFile.readAsString();
      return data.getJavaRelease(path);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not read java release file at "${e.path}": ${e.message}',
        code: JajvmExceptionCode.readFileFailed,
      );
    }
  }

  /// Copy a directory to a new location using shell
  ///
  /// This will override any files that exist in the destination with the same name
  ///
  /// Arguments:
  /// - `source` full path to the source directory, should include the drive letter
  /// - `destination` full path to the destination directory, should include the drive letter
  ///
  /// Throws [JajvmException] if the directory could not be copied
  Future<void> copyDirectory(String source, String destination) async {
    try {
      switch (kCurrentPlatform) {
        case JajvmSupportedPlatform.windows:
          // Will override any files that exist in the destination with the same name
          final result = await _shell.runExecutableArguments(
              'xcopy', [source, destination, '/s', '/e', '/y']);
          // Failure exit codes are 4 and 5: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy
          if (result.exitCode <= 3 || result.exitCode > 5) return;

          final message = result.exitCode == 4
              ? 'Exception: Could not copy directory "$source" to "$destination": Initialization error occurred. There is not enough memory or disk space, or you entered an invalid drive name or invalid syntax on the command line.'
              : 'Exception: Could not copy directory "$source" to "$destination": Disk write error occurred.';

          throw JajvmException(
            message: message,
            code: JajvmExceptionCode.copyDirectoryFailed,
          );
        default:
          final result = await _shell.runExecutableArguments(
              'cp', ['-r', join(source, '*'), destination]);
          // Success exit code is 0: https://www.gnu.org/software/coreutils/manual/html_node/cp-invocation.html#cp-invocation
          if (result.exitCode == 0) return;

          throw JajvmException(
            message:
                'Exception: Could not copy directory "$source" to "$destination"',
            code: JajvmExceptionCode.copyDirectoryFailed,
          );
      }
    } on ShellException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not copy directory "$source" to "$destination": ${e.message}',
        code: JajvmExceptionCode.copyDirectoryFailed,
      );
    }
  }

  /// Delete a directory
  Future<void> deleteDirectory(String path) async {
    try {
      await Directory(path).delete(recursive: true);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not delete directory "${e.path}": ${e.message}',
        code: JajvmExceptionCode.deleteDirectoryFailed,
      );
    }
  }

  /// Determines if a release is the default
  Future<bool> isDefaultRelease(String path) async {
    try {
      final link = Link(await envDefaultLinkPath);
      if (!await link.exists()) return false;

      final target = await link.target();
      return canonicalize(target) == canonicalize(path);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not read symlink at "${e.path}": ${e.message}',
        code: JajvmExceptionCode.readLinkFailed,
      );
    }
  }

  /// List java releases in jajvm `versions` directory
  Future<List<JavaRelease>> listReleases() async {
    try {
      final versionsDir = Directory(await envJajvmVersionPath);
      final files = <Future<JavaRelease>>[];
      final completer = Completer<List<Future<JavaRelease>>>();
      final lister = versionsDir.list(recursive: false);
      lister.map((entry) => parseJavaReleaseDetails(entry.path)).listen(
            onDone: () => completer.complete(files),
            files.add,
          );

      return Future.wait(await completer.future).catchError((e, st) {
        throw JajvmException(
          message: 'Exception: Could not list java releases: ${e.message}',
          code: JajvmExceptionCode.listReleasesFailed,
        );
      });
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not read versions directory at "${e.path}": ${e.message}',
        code: JajvmExceptionCode.readDirectoryFailed,
      );
    }
  }
}

extension EnvironmentReader on FileSystemService {
  /// User Home Path
  Future<String> get envUserHomePath async {
    final userHome = await readEnvironmentVariable(kUserHomeKey);
    return userHome!;
  }

  /// User Home Path
  Future<String> get envPath async {
    final userHome = await readEnvironmentVariable(kPathKey);
    return userHome!;
  }

  /// Jajvm Home Path
  Future<String> get envJajvmHomePath async {
    final home = await readEnvironmentVariable(kJajvmHomeKey);
    if (home != null) {
      return normalize(home);
    }

    return join(await envUserHomePath, 'jajvm');
  }

  /// Jajvm Java Versions Path
  Future<String> get envJajvmVersionPath async =>
      join(await envJajvmHomePath, 'versions');

  /// User Home Path
  Future<String?> get envJavaHomePath async {
    return await readEnvironmentVariable(kJavaHomeKey);
  }

  /// Java Home Path
  Future<Directory?> get envJavaHomeDirectory async {
    final home = await envJavaHomePath;
    return home != null ? Directory(home) : null;
  }

  Future<String> get envDefaultLinkPath async =>
      join(await envJajvmHomePath, kJajvmDefaultSymLinkName);

  Future<String> get envDefaultJajvmJavaBinPath async =>
      join(await envDefaultLinkPath, kBinFolderName);
}
