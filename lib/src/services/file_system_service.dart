import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:riverpod/riverpod.dart';

import '../constants/env_vars.dart';
import '../constants/error_codes.dart';
import '../exceptions/jajvm_exception.dart';

final _shellProvider = Provider((ref) => Shell());

final fileSystemProvider = Provider<FileSystemService>((ref) {
  final shell = ref.watch(_shellProvider);
  return FileSystemService(shell);
});

class FileSystemService {
  FileSystemService([Shell? shell]) : _shell = shell ?? Shell();

  final Shell _shell;

  void createJajvmFolder() {
    createFolder(kJajvmHome);
  }

  void createVersionsFolder() {
    createFolder(kJajvmVersionDirectory);
  }

  void createFolder(String path) {
    try {
      final dir = Directory(path);
      if (dir.existsSync()) return;

      dir.createSync(recursive: true);
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not create folder at "${e.path}": ${e.message}',
        code: kCodeCreateFolderFailed,
      );
    }
  }

  Link updateSymLink(String path, String target) {
    try {
      final type = FileSystemEntity.typeSync(path);
      switch (type) {
        case FileSystemEntityType.directory:
          Directory(path).deleteSync(recursive: true);
          return createSymLink(path, target);
        case FileSystemEntityType.file:
          File(path).deleteSync();
          return createSymLink(path, target);
        case FileSystemEntityType.link:
          return Link(path)..updateSync(target);
        case FileSystemEntityType.notFound:
          return createSymLink(path, target);
      }

      // Should not get here
      throw StateError('Error: Unknown file system entity type');
    } on FileSystemException catch (e) {
      throw JajvmException(
        message:
            'Exception: Could not update symlink at "${e.path}": ${e.message}',
        code: kCodeUpdateLinkFailed,
      );
    }
  }

  Link createSymLink(String path, String target) {
    try {
      final link = Link(path);
      if (link.existsSync()) return link;

      final type = FileSystemEntity.typeSync(path);
      switch (type) {
        case FileSystemEntityType.directory:
          Directory(path).deleteSync(recursive: true);
          break;
        case FileSystemEntityType.file:
          File(path).deleteSync();
          break;
        case FileSystemEntityType.link:
          link.deleteSync();
          break;
        case FileSystemEntityType.notFound:
          break;
      }

      return link..createSync(target, recursive: true);
    } on FileSystemException catch (e) {
      // TODO: Catch "ERROR_PRIVILEGE_NOT_HELD" and return different code and message
      throw JajvmException(
        message:
            'Exception: Could not create link from "$path" to "$target": ${e.message}',
        code: kCodeCreateLinkFailed,
      );
    }
  }

  /// Read in an environment variable from the system. Only works on windows.
  ///
  /// Arguments:
  /// - [key] must not have spaces
  ///
  /// Returns null if the environment variable is not set.
  Future<String?> readEnvironmentVariable(String key) async {
    if (!Platform.isWindows) throw UnimplementedError();

    final result = await _shell.runExecutableArguments('echo', ['%$key%']);
    final text = result.outText.trim();
    return text == '%$key%' ? null : text;
  }

  /// Write an environment variable to the system. Only works on windows.
  ///
  /// Arguments:
  /// - [key] must not have spaces
  Future<void> writeEnvironmentVariable(
    String key,
    String value, {
    bool global = false,
  }) async {
    if (!Platform.isWindows) throw UnimplementedError();

    // Set the environment variable for the user or system
    final result = await _shell.runExecutableArguments('setx', [
      if (global) ...['/M'],
      key,
      shellArgument(value),
    ]);
    if (!result.outText.contains('SUCCESS')) {
      throw JajvmException(
        message: 'Could not set environment variable "$key" to "$value"',
        code: kCodeUpdateEnvironmentFailed,
      );
    }

    // Set the environment variable in the current session so that
    // the new value can be used immediately instead of having to
    // restart the application.
    await _shell.runExecutableArguments('set', ['$key=$value']);
    final expected = await _shell.runExecutableArguments('echo', ['%$key%']);
    if (expected.outText.contains('$key=$value')) return;

    throw JajvmException(
      message: 'Could not set environment variable "$key" to "$value"',
      code: kCodeUpdateEnvironmentFailed,
    );
  }

  Future<bool> isAdministratorMode() async {
    switch (_currentPlatform) {
      case _SupportedPlatform.windows:
        final result = await _shell.runExecutableArguments('set', ['session']);
        return !result.outText.contains('Access is denied.');
      default:
        final result = await _shell.run('whoami');
        return result.outText.contains('root');
    }
  }
}

enum _SupportedPlatform {
  windows,
  linux,
  macos,
}

_SupportedPlatform get _currentPlatform {
  if (Platform.isWindows) return _SupportedPlatform.windows;
  if (Platform.isLinux) return _SupportedPlatform.linux;
  if (Platform.isMacOS) return _SupportedPlatform.macos;
  throw UnimplementedError();
}
