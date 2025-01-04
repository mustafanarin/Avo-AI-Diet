import 'package:avo_ai_diet/product/utility/exceptions/secure_storage_exception.dart';
import 'package:avo_ai_diet/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService(this._secureStorage) {
    _initialize();
  }
  late final GenerativeModel _model;
  late final SecureStorageService _secureStorage;
  static const String _geminiModel = 'gemini-pro';

  Future<void> _initialize() async {
    final apiKey = await _getSecureApiKey();
    _model = GenerativeModel(model: _geminiModel, apiKey: apiKey);
  }

  Future<String> _getSecureApiKey() async {
    try {
      var apiKey = await _secureStorage.getApiKey();

      if (apiKey == null) {
        apiKey = dotenv.env['GEMINI_API_KEY'];
        if (apiKey == null) {
          throw SecureStorageException(message: 'API key not found');
        }
        await _secureStorage.saveApiKey(apiKey);
      }
      return apiKey;
    } catch (e) {
      throw SecureStorageException(message: 'API key not received: $e');
    }
  }
}
