import 'dart:io';

import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:avo_ai_diet/product/constants/prompt_repository.dart';
import 'package:avo_ai_diet/product/utility/exceptions/gemini_exception.dart';
import 'package:avo_ai_diet/services/rate_limit_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

abstract class IGeminiService {
  Future<String> getUserDiet(UserInfoModel user);
  Future<String> aiChat(String text, String conversationHistory, UserInfoCacheModel userInfo);
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions);
  Future<bool> isInternetAvailable();
}

@singleton
final class GeminiService implements IGeminiService {
  GeminiService(this._promptRepository, this._rateLimitService);
  final IPromptRepository _promptRepository;
  final IRateLimitService _rateLimitService;

  late final GenerativeModel _model;
  late final FirebaseRemoteConfig _remoteConfig;

  static const String _defaultModel = 'gemini-2.0-flash-lite';
  static const int _defaultDailyRequestLimit = 15;
  static const Duration _requestTimeout = Duration(seconds: 30);

  late final Future<void> _initFuture = _initialize();

  Future<void> _initialize() async {
    try {
      await _initializeFirebase();
      await _setupRemoteConfig();
      _setupGeminiModel();
    } catch (e) {
      print('🚨 Firebase initialization hatası: $e');
      _setupFallbackModel();
    }
  }

  Future<void> _initializeFirebase() async {
    await FirebaseAppCheck.instance.activate();
  }

  Future<void> _setupRemoteConfig() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.setDefaults({
      'gemini_model': _defaultModel,
      'temperature': 0.7,
      'daily_request_limit_per_user': _defaultDailyRequestLimit,
    });

    await _remoteConfig.fetchAndActivate();
  }

  void _setupGeminiModel() {
    final modelName = _remoteConfig.getString('gemini_model');
    final temperature = _remoteConfig.getDouble('temperature');

    _model = FirebaseAI.googleAI().generativeModel(
      model: modelName.isEmpty ? _defaultModel : modelName,
      generationConfig: GenerationConfig(temperature: temperature),
      safetySettings: _getSafetySettings(),
    );
  }

  void _setupFallbackModel() {
    _remoteConfig = FirebaseRemoteConfig.instance;
    _model = FirebaseAI.googleAI().generativeModel(
      model: _defaultModel,
      generationConfig: GenerationConfig(temperature: 0.7),
      safetySettings: _getSafetySettings(),
    );
  }

  List<SafetySetting> _getSafetySettings() {
    return [
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium, null),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium, null),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium, null),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high, null),
    ];
  }

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

  // rate limit check
  Future<void> _checkRateLimit() async {
    final userLimit = _getDailyRequestLimit();

    await _rateLimitService.checkAndIncrementRequestLimit(dailyLimit: userLimit);
  }

  int _getDailyRequestLimit() {
    try {
      return _remoteConfig.getInt('daily_request_limit_per_user');
    } catch (e) {
      print('Remote config error, using default limit: $e');
      return _defaultDailyRequestLimit;
    }
  }

  // focused Gemini request method
  Future<String> _makeGeminiRequest(String prompt) async {
    // Pre-flight checks
    if (!await isInternetAvailable()) {
      throw GeminiException(
        message: 'İnternet bağlantınızı kontrol edin. AI özelliklerini kullanmak için internet gereklidir.',
      );
    }

    // Rate limit check - delegated to specialized service
    await _checkRateLimit();

    try {
      final response = await _model.generateContent([Content.text(prompt)]).timeout(_requestTimeout);

      if (response.text == null || response.text!.isEmpty) {
        throw GeminiException(message: 'AI yanıt oluşturamadı. Lütfen tekrar deneyin.');
      }

      return response.text!;
    } on GeminiException {
      rethrow;
    } on FirebaseException catch (e) {
      throw GeminiException(message: _handleFirebaseError(e));
    } on SocketException {
      throw GeminiException(
        message: 'İnternet bağlantı sorunu. Lütfen bağlantınızı kontrol edin.',
      );
    } catch (e) {
      throw GeminiException(message: _handleGenericError(e));
    }
  }

  String _handleFirebaseError(FirebaseException e) {
    print('🚨 Firebase Error: ${e.code} - ${e.message}');

    final errorMessages = {
      'quota-exceeded': '💸 Günlük token limitimiz doldu.\n Sistem kapasitesi yarın yenilenecek.',
      'resource-exhausted': '💸 Günlük token limitimiz doldu.\n Sistem kapasitesi yarın yenilenecek.',
      'permission-denied': '🔒 AI hizmet erişimi reddedildi.\n Lütfen uygulamayı güncelleyin.',
      'unavailable': '🛠️ AI hizmeti bakımda.\n Birkaç dakika sonra tekrar deneyin.',
      'deadline-exceeded': '⏱️ AI yanıt süresi aşıldı.\n Lütfen tekrar deneyin.',
      'unauthenticated': '🔑 Kimlik doğrulama hatası.\n Uygulamayı yeniden başlatın.',
    };

    return errorMessages[e.code] ?? '⚠️ AI hizmeti hatası.\n Lütfen daha sonra tekrar deneyin.';
  }

  String _handleGenericError(dynamic e) {
    final errorString = e.toString().toLowerCase();

    if (errorString.contains('quota') || errorString.contains('429') || errorString.contains('resource-exhausted')) {
      return '💸 Günlük token limitimiz doldu.\n Sistem kapasitesi yarın yenilenecek.';
    }

    if (errorString.contains('timeout') || errorString.contains('deadline')) {
      return '⏱️ AI yanıt süresi aşıldı.\n Lütfen tekrar deneyin.';
    }

    return '⚠️ AI hizmeti geçici olarak kullanılamıyor.\n Lütfen daha sonra tekrar deneyin.';
  }

  // AI requests
  @override
  Future<String> getUserDiet(UserInfoModel user) async {
    await _initFuture;
    final prompt = _promptRepository.getDietPrompt(user);
    return _makeGeminiRequest(prompt);
  }

  @override
  Future<String> aiChat(String text, String conversationHistory, UserInfoCacheModel userInfo) async {
    await _initFuture;
    final prompt = _promptRepository.getChatPrompt(text, conversationHistory, userInfo);
    return _makeGeminiRequest(prompt);
  }

  @override
  Future<String> getRegionalFatBurningAdvice(UserInfoCacheModel userInfo, List<String> selectedRegions) async {
    await _initFuture;
    final prompt = _promptRepository.getRegionalFatBurningPrompt(userInfo, selectedRegions);
    return _makeGeminiRequest(prompt);
  }
}
