final class SecureStorageException implements Exception {
  SecureStorageException({required this.message});

  final String message;

  @override
  String toString() {
    return 'Secure Storage Exception: $message';
  }
}
