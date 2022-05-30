extension JavaVersionProperties on String {
  List<MapEntry<String, String>> get javaVersionProperties {
    return JavaVersionParser(this).javaVersionProperties;
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
}
