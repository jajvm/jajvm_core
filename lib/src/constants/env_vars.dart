import 'dart:io';

const String kJajvmHomeKey = 'JAJVM_HOME';
const String kJavaHomeKey = 'JAVA_HOME';
const String kPathKey = 'PATH';
const String kDefaultFolderName = 'default';
const String kBinFolderName = 'bin';
const String kLinuxJajvmGlobalEnvPath = '/etc/profile.d/jajvm_variables.sh';
const String kLinuxJajvmUserEnvPath = '~/.profile';

/// User Home Path Key
String get kUserHomeKey {
  if (Platform.isWindows) {
    return 'UserProfile';
  } else {
    return 'HOME';
  }
}
