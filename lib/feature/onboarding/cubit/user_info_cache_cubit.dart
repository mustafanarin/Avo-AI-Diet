import 'package:avo_ai_diet/feature/onboarding/state/user_info_cache_state.dart';
import 'package:avo_ai_diet/product/cache/manager/user_info/user_info_manager.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
final class UserInfoCacheCubit extends Cubit<UserInfoCacheState> {
  UserInfoCacheCubit(this._manager) : super(UserInfoCacheState());

  final IUserInfoManager _manager;

  Future<void> loadUserInfo() async {
    emit(state.copyWith(isLoading: true));
    try {
      final userData = await _manager.getUserInfo();
      if (userData != null) {
        emit(state.copyWith(cacheModel: userData, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Maalesef eski bilgiler yüklenemedi.', isLoading: false));
    }
  }

  Future<void> saveUserInfo(UserInfoCacheModel userInfo) async {
    emit(state.copyWith(isLoading: false));
    try {
      await _manager.saveUserInfo(userInfo);
      emit(state.copyWith(cacheModel: userInfo, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: 'Bilgiler kaydedilemedi.', isLoading: false));
    }
  }
}
