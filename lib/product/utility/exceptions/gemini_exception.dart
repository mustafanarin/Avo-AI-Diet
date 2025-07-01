final class GeminiException implements Exception {
  GeminiException({required this.message});

  final String message;

  @override
  String toString() {
    return message;
  }
}
