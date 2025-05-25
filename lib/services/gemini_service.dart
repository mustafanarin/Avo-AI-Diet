import 'dart:io';

import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IGeminiService {
  Future<String> getUserDiet(UserInfoModel user);
  Future<String> aiChat(String text, String conversationHistory, UserInfoCacheModel userInfo);
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions);
  Future<bool> isInternetAvailable();
}

@singleton
final class GeminiService implements IGeminiService {
  GeminiService();

  late final GenerativeModel _model;
  late final FirebaseRemoteConfig _remoteConfig;
  final String _defaultModel = 'gemini-2.0-flash-lite';

  late final Future<void> _initFuture = _initialize();

  Future<void> _initialize() async {
    try {
      // Start firebase app check
      await FirebaseAppCheck.instance.activate();

      // Start remote config
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // Default remote config values
      await _remoteConfig.setDefaults({
        'gemini_model': _defaultModel,
        'temperature': 0.7,
        'daily_request_limit_per_user': 9,
      });

      await _remoteConfig.fetchAndActivate();

      final modelName = _remoteConfig.getString('gemini_model');

      _model = FirebaseAI.googleAI().generativeModel(
        model: modelName.isEmpty ? _defaultModel : modelName,
        generationConfig: GenerationConfig(
          temperature: _remoteConfig.getDouble('temperature'), //for creativity
        ),
        safetySettings: [
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
        ],
      );
    } catch (e) {
      print('🚨 Firebase initialization hatası: $e');

      _remoteConfig = FirebaseRemoteConfig.instance;

      _model = FirebaseAI.googleAI().generativeModel(
        model: _defaultModel,
        generationConfig: GenerationConfig(temperature: 0.7),
        safetySettings: [
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium, null),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
        ],
      );
    }
  }

  // Internet check
  @override
  Future<bool> isInternetAvailable() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      return connectivity.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      print('İnternet kontrolü hatası: $e');
      return false;
    }
  }

  // Daily request limit per user
  Future<bool> _canMakeRequest() async {
    final userLimit = _remoteConfig.getInt('daily_request_limit_per_user');
    final today = DateTime.now().toIso8601String().split('T')[0];
    final userKey = 'user_requests_$today';

    final prefs = await SharedPreferences.getInstance();
    final userRequestCount = prefs.getInt(userKey) ?? 0;

    if (userRequestCount >= userLimit) {
      throw GeminiException(
        message: 'Günlük AI sorgu limitiniz ($userLimit) aşıldı. Yarın tekrar deneyin.',
      );
    }

    await prefs.setInt(userKey, userRequestCount + 1);
    return true;
  }

  Future<String> _makeGeminiRequest(String prompt) async {
    // Internet check
    if (!await isInternetAvailable()) {
      throw GeminiException(
        message: 'İnternet bağlantınızı kontrol edin. AI özelliklerini kullanmak için internet gereklidir.',
      );
    }

    try {
      // User limit check
      await _canMakeRequest();

      final response = await _model.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw GeminiException(message: 'AI yanıt oluşturamadı. Lütfen tekrar deneyin.');
      }

      return response.text!;
    } on FirebaseException catch (e) {
      // Firebase Error
      throw GeminiException(message: _handleFirebaseError(e));
    } on SocketException catch (e) {
      // Internet error
      throw GeminiException(
        message: 'İnternet bağlantı sorunu. Lütfen bağlantınızı kontrol edin.',
      );
    } catch (e) {
      // Limit error
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('quota') ||
          errorString.contains('limit') ||
          errorString.contains('429') ||
          errorString.contains('resource-exhausted')) {
        throw GeminiException(
          message: 'Günlük AI kapasitemiz doldu. Yarın tekrar deneyin. 🙏',
        );
      }

      throw GeminiException(
        message: 'AI hizmeti geçici olarak kullanılamıyor. Lütfen daha sonra tekrar deneyin.',
      );
    }
  }

  String _handleFirebaseError(FirebaseException e) {
    print('🚨 Firebase Error: ${e.code} - ${e.message}');

    switch (e.code) {
      case 'quota-exceeded':
      case 'resource-exhausted':
        return 'Günlük AI kapasitemiz doldu. Yarın tekrar deneyin. 🙏';

      case 'permission-denied':
        return 'AI hizmet erişimi reddedildi. Lütfen uygulamayı güncelleyin.';

      case 'unavailable':
        return 'AI hizmeti geçici olarak kullanılamıyor. Birkaç dakika sonra tekrar deneyin.';

      case 'deadline-exceeded':
        return 'AI yanıt süresi aşıldı. Lütfen tekrar deneyin.';

      default:
        return 'AI hizmeti hatası. Lütfen daha sonra tekrar deneyin.';
    }
  }

  @override
  Future<String> getUserDiet(UserInfoModel user) async {
    await _initFuture;

    final prompt = '''
Sen beslenme uzmanı bir diyetisyensin ve Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. Karşındakiyle arkadaş canlısı bir konuşma şeklin var. Kullanıcı sana Avo olarak hitap ediyor.

Kullanıcının fiziksel özellikleri ve hedefleri:
Boy: ${user.height} cm
Kilo: ${user.weight} kg
Yaş: ${user.age}
Cinsiyet: ${user.gender}
Aktivite seviyesi: ${user.activityLevel}
Hedef: ${user.target}
Diyet Bütçesi: ${user.budget}

Kullanıcının günlük kalori ihtiyacı ${user.targetCalories} kalori olarak hesaplanmıştır. 
Lütfen bu kalori miktarına uygun bir günlük diyet listesi oluştur. Hazırlayacağın diyet listesi bu kalorinin en fazla 50 aşağısında veya 50 yukarısında olabilir!

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

    return _makeGeminiRequest(prompt);
  }

  @override
  Future<String> aiChat(String text, String conversationHistory, UserInfoCacheModel userInfo) async {
    await _initFuture;

    final prompt = '''
Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. Karşındakiyle arkadaş canlısı bir konuşma şeklin var.

Kullanıcı Bilgileri:
- Yaş: ${userInfo.age}
- Boy: ${userInfo.height}
- Kilo: ${userInfo.weight}
- Cinsiyet: ${userInfo.gender}

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

    return _makeGeminiRequest(prompt);
  }

  @override
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions) async {
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

Yanıtını direkt Avo olarak ver. Asla "Kullanıcı:" veya "Ben Avo:" veya "Avo:" gibi etiketler kullanma. Cevap verirken en başta kendini tanıtmana gerek yok, kısa bir giriş cümlesiyle konuşmaya başla. Yanıtın 300 kelimeyi geçmesin. Arkadaş canlısı ve motive edici ol.
''';

    return _makeGeminiRequest(prompt);
  }
}
