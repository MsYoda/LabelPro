extension StringExt on String {
  String toCamelCase() {
    final parts = split('_');
    return parts.first + parts.skip(1).map((e) => e[0].toUpperCase() + e.substring(1)).join();
  }
}
