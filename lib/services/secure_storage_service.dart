import 'package:avo_ai_diet/product/utility/exceptions/secure_storage_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
final class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _keyName = 'gemini_api_key';

  Future<void> saveApiKey(String apiKey) async {
    try {
      await _storage.write(key: _keyName, value: apiKey);
    } catch (e) {
      throw SecureStorageException(message: 'API key not recording: $e');
    }
  }

  Future<String?> getApiKey() async {
    return _storage.read(key: _keyName);
  }
}
