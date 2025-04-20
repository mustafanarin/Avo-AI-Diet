// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../../feature/chat/cubit/chat_cubit.dart' as _i648;
import '../../../feature/favorites/cubit/favorites_cubit.dart' as _i456;
import '../../../feature/home/cubit/ai_diet_advice_cubit.dart' as _i568;
import '../../../feature/home/cubit/daily_calorie_cubit.dart' as _i688;
import '../../../feature/onboarding/cubit/name_and_cal_cubit.dart' as _i784;
import '../../../feature/onboarding/cubit/user_info_cache_cubit.dart' as _i924;
import '../../../feature/onboarding/cubit/user_info_cubit.dart' as _i250;
import '../../../feature/profile/cubit/name_edit_cubit.dart' as _i307;
import '../../../feature/profile/cubit/water_reminder_cubit.dart' as _i927;
import '../../../feature/search/cubit/search_cubit.dart' as _i104;
import '../../../services/gemini_service.dart' as _i709;
import '../../../services/notification_service.dart' as _i354;
import '../../../services/secure_storage_service.dart' as _i976;
import '../../cache/manager/daily_calorie/daily_calorie_manager.dart' as _i18;
import '../../cache/manager/favorites/favorite_message_manager.dart' as _i45;
import '../../cache/manager/name_and_cal/name_and_cal_manager.dart' as _i490;
import '../../cache/manager/reponse/ai_response_manager.dart' as _i697;
import '../../cache/manager/user_info/user_info_manager.dart' as _i833;
import '../../cache/manager/water_reminder/water_reminder_manager.dart'
    as _i859;
import 'app_module.dart' as _i460;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.factory<_i45.FavoriteMessageManager>(() => _i45.FavoriteMessageManager());
  gh.factory<_i104.SearchCubit>(() => _i104.SearchCubit());
  gh.singleton<_i859.WaterReminderManager>(() => _i859.WaterReminderManager());
  gh.singleton<_i697.AiResponseManager>(() => _i697.AiResponseManager());
  gh.singleton<_i18.DailyCalorieManager>(() => _i18.DailyCalorieManager());
  gh.singleton<_i490.NameAndCalManager>(() => _i490.NameAndCalManager());
  gh.singleton<_i833.UserInfoManager>(() => _i833.UserInfoManager());
  gh.singleton<_i18.IDailyCalorieManager>(() => appModule.dailyCalorieManager);
  gh.singleton<_i976.ISecureStorageService>(
      () => appModule.secureStorageService);
  gh.singleton<_i709.IGeminiService>(() => appModule.geminiService);
  gh.singleton<_i45.IFavoriteMessageManager>(
      () => appModule.favoriteMessageManager);
  gh.singleton<_i490.INameAndCalManager>(() => appModule.nameAndCalManager);
  gh.singleton<_i697.IAiResponseManager>(() => appModule.aiResponseManager);
  gh.singleton<_i833.IUserInfoManager>(() => appModule.userInfoManager);
  gh.singleton<_i354.INotificationService>(() => appModule.notificationService);
  gh.singleton<_i859.IWaterReminderManager>(
      () => appModule.waterReminderManager);
  gh.singleton<_i354.NotificationService>(() => _i354.NotificationService());
  gh.singleton<_i976.SecureStorageService>(() => _i976.SecureStorageService());
  gh.factory<_i648.ChatCubit>(
      () => _i648.ChatCubit(gh<_i709.IGeminiService>()));
  gh.factory<_i927.WaterReminderCubit>(() => _i927.WaterReminderCubit(
        gh<_i354.INotificationService>(),
        gh<_i859.IWaterReminderManager>(),
      ));
  gh.factory<_i456.FavoritesCubit>(
      () => _i456.FavoritesCubit(gh<_i45.IFavoriteMessageManager>()));
  gh.factory<_i688.DailyCalorieCubit>(
      () => _i688.DailyCalorieCubit(gh<_i18.IDailyCalorieManager>()));
  gh.singleton<_i709.GeminiService>(
      () => _i709.GeminiService(gh<_i976.ISecureStorageService>()));
  gh.factory<_i568.AiDietAdviceCubit>(
      () => _i568.AiDietAdviceCubit(gh<_i697.IAiResponseManager>()));
  gh.factory<_i307.NameEditCubit>(
      () => _i307.NameEditCubit(gh<_i490.INameAndCalManager>()));
  gh.factory<_i784.NameAndCalCubit>(
      () => _i784.NameAndCalCubit(gh<_i490.INameAndCalManager>()));
  gh.factory<_i924.UserInfoCacheCubit>(
      () => _i924.UserInfoCacheCubit(gh<_i833.IUserInfoManager>()));
  gh.factory<_i250.UserInfoCubit>(() => _i250.UserInfoCubit(
        gh<_i709.IGeminiService>(),
        gh<_i697.IAiResponseManager>(),
      ));
  return getIt;
}

class _$AppModule extends _i460.AppModule {}
