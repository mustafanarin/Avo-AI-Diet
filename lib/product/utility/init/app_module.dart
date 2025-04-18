import 'package:avo_ai_diet/product/cache/manager/daily_calorie/daily_calorie_manager.dart';
import 'package:avo_ai_diet/product/cache/manager/favorites/favorite_message_manager.dart';
import 'package:avo_ai_diet/product/cache/manager/name_and_cal/name_and_cal_manager.dart';
import 'package:avo_ai_diet/product/cache/manager/reponse/ai_response_manager.dart';
import 'package:avo_ai_diet/services/gemini_service.dart';
import 'package:avo_ai_diet/services/secure_storage_service.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @singleton
  IDailyCalorieManager get dailyCalorieManager => DailyCalorieManager();

  @singleton
  ISecureStorageService get secureStorageService => SecureStorageService();

  @singleton
  IGeminiService get geminiService => GeminiService(secureStorageService);

  @singleton
  IFavoriteMessageManager get favoriteMessageManager => FavoriteMessageManager();

  @singleton
  INameAndCalManager get nameAndCalManager => NameAndCalManager();

  @singleton
  IAiResponseManager get aiResponseManager => AiResponseManager();
}
