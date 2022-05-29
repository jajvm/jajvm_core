import 'dart:io';

import 'package:path/path.dart';

const String kJajvmHomeKey = 'JAJVM_HOME';
const String kJavaHomeKey = 'JAVA_HOME';

// Code adapted from fvm: https://github.com/fluttertools/fvm/blob/main/lib/constants.dart

Map<String, String> get kEnvVars => Platform.environment;

/// User Home Path
String get kUserHome {
  if (Platform.isWindows) {
    return kEnvVars['UserProfile']!;
  } else {
    return kEnvVars['HOME']!;
  }
}

/// FVM Home directory
String get kJajvmHome {
  final home = kEnvVars[kJajvmHomeKey];
  if (home != null) {
    return normalize(home);
  }

  return join(kUserHome, 'jajvm');
}

String get kPath {
  return kEnvVars['PATH']!;
}

String get kJajvmVersionDirectory => join(kJajvmHome, 'versions');

String? get kJavaHome => kEnvVars[kJavaHomeKey];

Directory? get kJavaHomeDirectory =>
    kJavaHome != null ? Directory(kJajvmHome) : null;

String get kDefaultLinkPath => join(kJajvmHome, 'default');
