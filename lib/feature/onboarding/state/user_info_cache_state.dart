import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';

final class UserInfoCacheState {
  UserInfoCacheState({this.isLoading = false, this.cacheModel, this.error});

  final bool isLoading;
  final UserInfoCacheModel? cacheModel;
  final String? error;

  UserInfoCacheState copyWith({
    bool? isLoading,
    UserInfoCacheModel? cacheModel,
    String? error,
  }) {
    return UserInfoCacheState(
      isLoading: isLoading ?? false,
      cacheModel: cacheModel ?? this.cacheModel,
      error: error ?? this.error,
    );
  }
}
