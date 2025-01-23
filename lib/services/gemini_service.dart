import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/product/utility/exceptions/secure_storage_exception.dart';
import 'package:avo_ai_diet/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

@singleton
final class GeminiService {
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

  Future<String> getUserDiet(UserInfoModel user) async {
    try {
      final prompt = '''
          Sen beslenme üzerine de uzman bir diyetisyensin. 
      
        Kullanıcının fiziksel özellikleri ve hedefleri hakkında bilgiler:
        Boy: ${user.height} cm
        Kilo: ${user.weight} kg
        Yaş: ${user.age}
        Cinsiyet: ${user.gender}
        Aktivite seviyes: ${user.activityLevel}
        Hedef: ${user.target}
        Diyet Bütçesi: ${user.budget}
        
        Bu bilgiler ışığında sadece bir diyet listesi öner.
      ''';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      if (response.text == null) {
        throw Exception('Gemini API response error');
      }
      return response.text!;
    } catch (e) {
      throw Exception('Gemini error: $e');
    }
  }
}
