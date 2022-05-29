import 'dart:io';

import 'package:riverpod/riverpod.dart';

import '../constants/env_vars.dart';
import '../constants/error_codes.dart';
import '../exceptions/jajvm_exception.dart';

final fileSystemProvider = Provider<FileSystemService>((ref) {
  return FileSystemService();
});

class FileSystemService {
  const FileSystemService();

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

  Link createSymLink(String path, String target) {
    try {
      final link = Link(path);
      if (link.existsSync()) return link;

      final type = FileSystemEntity.typeSync(path);
      switch (type) {
        case FileSystemEntityType.directory:
          Directory(path).deleteSync();
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
}
