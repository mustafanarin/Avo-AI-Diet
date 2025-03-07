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
import '../../../feature/onboarding/cubit/name_and_cal_cubit.dart' as _i784;
import '../../../feature/onboarding/cubit/user_info_cubit.dart' as _i250;
import '../../../services/gemini_service.dart' as _i709;
import '../../../services/secure_storage_service.dart' as _i976;
import '../../cache/favorites_manager/favorite_message_manager.dart' as _i466;
import '../../cache/name_and_cal_manager/name_and_cal_manager.dart' as _i575;
import '../../cache/reponse_manager/ai_response_manager.dart' as _i288;

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
  gh.factory<_i466.FavoriteMessageManager>(
      () => _i466.FavoriteMessageManager());
  gh.factory<_i288.AiResponseManager>(() => _i288.AiResponseManager());
  gh.factory<_i575.NameAndCalManager>(() => _i575.NameAndCalManager());
  gh.singleton<_i976.SecureStorageService>(() => _i976.SecureStorageService());
  gh.factory<_i456.FavoritesCubit>(
      () => _i456.FavoritesCubit(gh<_i466.FavoriteMessageManager>()));
  gh.singleton<_i709.GeminiService>(
      () => _i709.GeminiService(gh<_i976.SecureStorageService>()));
  gh.factory<_i784.NameAndCalCubit>(
      () => _i784.NameAndCalCubit(gh<_i575.NameAndCalManager>()));
  gh.factory<_i250.UserInfoCubit>(() => _i250.UserInfoCubit(
        gh<_i709.GeminiService>(),
        gh<_i288.AiResponseManager>(),
      ));
  gh.factory<_i648.ChatCubit>(() => _i648.ChatCubit(gh<_i709.GeminiService>()));
  return getIt;
}
