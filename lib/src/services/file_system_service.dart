import 'dart:io';

import 'package:riverpod/riverpod.dart';

import '../constants/constants.dart';
import '../constants/error_codes.dart';
import '../exceptions/jajvm_exception.dart';

final fileSystemProvider = Provider<FileSystemService>((ref) {
  return FileSystemService();
});

class FileSystemService {
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
        message: 'Could not create folder at "${e.path}": ${e.message}',
        code: kCodeCreateFolderFailed,
      );
    }
  }
}
