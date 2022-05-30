import '../../jajvm_core.dart';

extension JavaVersionProperties on String {
  List<MapEntry<String, String>> get javaVersionProperties {
    return JavaVersionParser(this).javaVersionProperties;
  }

  JavaRelease getJavaRelease(String path) {
    return JavaVersionParser(this).getJavaRelease(path);
  }
}

class JavaVersionParser {
  final String data;

  JavaVersionParser(this.data);

  List<MapEntry<String, String>> get javaVersionProperties => data
      .split('\n')
      // Split the lines
      .map((line) => line.trim().split('=').map((part) => part.trim()).toList())
      // Convert to a list of [key, value]
      .fold<List<MapEntry<String, String>>>(
          [],
          (List<MapEntry<String, String>> accumulator, List<String> line) => [
                ...accumulator,
                if (line.length == 2) ...[
                  MapEntry(line[0], line[1].replaceAll('"', '')),
                ],
              ]);

  JavaRelease getJavaRelease(String path) =>
      javaVersionProperties.fold<JavaRelease>(JavaRelease.byPath(path: path),
          (accumulator, pair) {
        switch (pair.key) {
          case 'IMPLEMENTOR_VERSION':
            return accumulator.copyWith(implementorVersion: pair.value);
          case 'IMPLEMENTOR':
            return accumulator.copyWith(implementor: pair.value);
          case 'JAVA_VERSION':
            return accumulator.copyWith(javaVersion: pair.value);
          case 'JAVA_VERSION_DATE':
            return accumulator.copyWith(javaVersionDate: pair.value);
          case 'LIBC':
            return accumulator.copyWith(libc: pair.value);
          case 'MODULES':
            return accumulator.copyWith(modules: pair.value);
          case 'OS_ARCH':
            return accumulator.copyWith(osArchitecture: pair.value);
          case 'OS_NAME':
            return accumulator.copyWith(osName: pair.value);
          case 'SOURCE':
            return accumulator.copyWith(source: pair.value);
          case 'BUILD_SOURCE':
            return accumulator.copyWith(buildSource: pair.value);
          case 'BUILD_SOURCE_REPO':
            return accumulator.copyWith(buildSourceRepo: pair.value);
          case 'SOURCE_REPO':
            return accumulator.copyWith(sourceRepo: pair.value);
          case 'FULL_VERSION':
            return accumulator.copyWith(fullVersion: pair.value);
          case 'SEMANTIC_VERSION':
            return accumulator.copyWith(semanticVersion: pair.value);
          case 'BUILD_INFO':
            return accumulator.copyWith(buildInfo: pair.value);
          case 'JVM_VARIANT':
            return accumulator.copyWith(jvmVariant: pair.value);
          case 'JVM_VERSION':
            return accumulator.copyWith(jvmVersion: pair.value);
          case 'IMAGE_TYPE':
            return accumulator.copyWith(imageType: pair.value);
          default:
            return accumulator;
        }
      });
}
