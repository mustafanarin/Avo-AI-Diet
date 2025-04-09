import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IUserInfoManager {
  Future<void> saveUserInfo(UserInfoCacheModel model);
  Future<UserInfoCacheModel?> getUserInfo();
}

@singleton
class UserInfoManager implements IUserInfoManager {
  LazyBox<UserInfoCacheModel>? _box;

  Future<LazyBox<UserInfoCacheModel>> _getBox() async {
    _box ??= await Hive.openLazyBox<UserInfoCacheModel>('user_info_box');
    return _box!;
  }

  @override
  Future<void> saveUserInfo(UserInfoCacheModel model) async {
    final box = await _getBox();
    await box.put('user_info', model);
  }

  @override
  Future<UserInfoCacheModel?> getUserInfo() async {
    final box = await _getBox();
    final response = await box.get(
      'user_info',
      defaultValue: const UserInfoCacheModel(age: '', gender: '', height: '', weight: ''),
    );
    return response;
  }
}
