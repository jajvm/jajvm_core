import 'dart:io';

enum JajvmSupportedPlatform {
  windows,
  linux,
  macos,
}

JajvmSupportedPlatform get kCurrentPlatform {
  if (Platform.isWindows) return JajvmSupportedPlatform.windows;
  if (Platform.isLinux) return JajvmSupportedPlatform.linux;
  if (Platform.isMacOS) return JajvmSupportedPlatform.macos;
  throw UnimplementedError();
}
