import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:avo_ai_diet/product/utility/exceptions/secure_storage_exception.dart';
import 'package:avo_ai_diet/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

abstract class IGeminiService {
  Future<String> getUserDiet(UserInfoModel user);
  Future<String> aiChat(String text, String conversationHistory);
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions);
}

@singleton
final class GeminiService implements IGeminiService {
  GeminiService(this._secureStorage);
  final ISecureStorageService _secureStorage;
  late final GenerativeModel _model;
  final String _geminiModel = 'gemini-2.0-flash-lite';

  late final Future<void> _initFuture = _initialize();

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

  @override
  Future<String> getUserDiet(UserInfoModel user) async {
    try {
      await _initFuture;

      final prompt = '''
      Sen beslenme uzmanı bir diyetisyensin ve Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. Karşındakiyle arkadaş canlısı bir konuşma şeklin var. Kullanıcı sana Avo  olarak hitap ediyor.

      Kullanıcının fiziksel özellikleri ve hedefleri:
      Boy: ${user.height} cm
      Kilo: ${user.weight} kg
      Yaş: ${user.age}
      Cinsiyet: ${user.gender}
      Aktivite seviyesi: ${user.activityLevel}
      Hedef: ${user.target}
      Diyet Bütçesi: ${user.budget}

      Kullanıcının günlük kalori ihtiyacı ${user.targetCalories} kalori olarak hesaplanmıştır. 
      Lütfen bu kalori miktarına uygun bir günlük diyet listesi oluştur.Hazırlayacağın diyet listesi bu kalorinin en fazla 50 aşşağısında veya 50 yukarısında olabilir!

      Lütfen sadece bir günlük diyet listesi oluştur. Liste aşağıdaki formatta olmalı ve her öğünün yaklaşık kalori değerini parantez içinde belirt:

      - Kahvaltı: [detaylar] (yaklaşık ... kalori)
      - Öğle: [detaylar] (yaklaşık ... kalori)
      - Akşam: [detaylar] (yaklaşık ... kalori)
      - Ara öğünler: [detaylar ve toplam kalori değeri]
      Listeyi oluşturduktan sonra tüm gün toplam kalori değerini belirt ve aşağıdaki 3 notu eklemeyi unutma:
      - Günde en az 2 litre sıvı tüketmeniz gerekli.
      - Bu sadece bir örnek listedir, kendi zevklerinize göre değişiklikler yapabilirsiniz. Ancak değişiklik yaparken kalori dengesine dikkat edin.
      - Sağlıklı bir beslenme planı oluşturmak için bir diyetisyene danışmanız her zaman en iyisidir.
      ''';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      if (response.text == null) {
        throw GeminiException(message: 'Gemini API response error');
      }
      return response.text!;
    } catch (e) {
      throw GeminiException(message: 'Gemini error: $e');
    }
  }

  @override
  Future<String> aiChat(String text, String conversationHistory) async {
    try {
      await _initFuture;

      final prompt = '''
      Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. Karşındakiyle 
      arkadaş canlısı bir konuşma şeklin var.

      Uzmanlık alanların:
      - Yemek tarifleri ve pişirme yöntemleri
      - Besinlerin değerleri ve faydaları 
      - Dengeli beslenme önerileri
      - Sağlıklı yaşam tavsiyeleri
      - Besinlerin yaklaşık kalori değerleri

      Önceki konuşma:
      $conversationHistory
      
      Kullanıcının mesajı: $text
      
      Yanıtını direkt Avo olarak ver. Asla "Kullanıcı:" veya "Ben Avo:" veya "Avo:" gibi etiketler kullanma. Doğrudan bir avokado maskotu olarak yanıt ver.

      Not1: Yalnızca uzmanlık alanlarında yanıt ver. Farklı konularda "Üzgünüm, yalnızca beslenme ve sağlıklı yaşam konularında yardımcı olabilirim." şeklinde yanıt ver.

      Not2: SADECE kullanıcı açıkça teşekkür ettiğinde "Rica ederim! Size başka hangi konuda yardımcı olabilirim?" şeklinde yanıt ver. Kullanıcı teşekkür etmediyse, yanıtını "Rica ederim!" veya benzer ifadelerle bitirme.
      ''';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw GeminiException(message: 'Gemini API response error');
      }
      return response.text!;
    } catch (e) {
      throw GeminiException(message: 'Gemini error: $e');
    }
  }

  @override
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions) async {
    try {
      await _initFuture;

      final regionText = selectedRegions.join(', ');

      final prompt = '''
      Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. Karşındakiyle arkadaş canlısı bir konuşma şeklin var.
      
      Sağlıklı beslenme uzmanı bir diyetisyen olarak, vücudun belirli bölgelerinde yağ yakmak isteyen bir kişiye tavsiye ver.
      
      Kullanıcının fiziksel özellikleri:
      - Boy: ${userInfo.height} cm
      - Kilo: ${userInfo.weight} kg
      - Yaş: ${userInfo.age}
      - Cinsiyet: ${userInfo.gender}
      
      Kişi şu bölgelerde yağ yakmak istiyor: $regionText
      
      Seçilen bölgeler için:
      1. Bölgesel yağ yakımının bilimsel olarak sınırlı olduğunu nazikçe açıkla
      2. Ancak yine de genel yağ yakımı ve şu bölgeleri hedefleyen egzersiz tavsiyeleri ver: $regionText
      3. Maksimum 3 adet etkili egzersiz öner
      4. Bu bölgelerde yağ yakmayı destekleyecek beslenme tavsiyelerini 3 madde halinde ver
      5. Bu bölgelerdeki kas tonunu artırmak için ipuçları ver
      
      Yanıtını direkt Avo olarak ver. Asla "Kullanıcı:" veya "Ben Avo:" veya "Avo:" gibi etiketler kullanma. Yanıtın 300 kelimeyi geçmesin. Arkadaş canlısı ve motive edici ol.
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw GeminiException(message: 'Gemini API response error');
      }
      return response.text!;
    } catch (e) {
      throw GeminiException(message: 'Bölgesel yağ yakımı tavsiyesi alınamadı: $e');
    }
  }
}
