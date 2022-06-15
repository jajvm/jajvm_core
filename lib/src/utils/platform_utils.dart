import 'dart:io';

class PlatformUtils {
  static bool get isUnix => isLinux || isMacOS;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isWindows => Platform.isWindows;
}
