import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IUserInfoManager {
  Future<void> saveUserInfo(UserInfoCacheModel model);
  Future<UserInfoCacheModel?> getUserInfo();
}

class UserInfoManager implements IUserInfoManager {
  static const String _boxName = 'user_info_box';
  static const String _userInfoKey = 'user_info';

  LazyBox<UserInfoCacheModel>? _box;
  UserInfoCacheModel? _cachedUserInfo;

  Future<LazyBox<UserInfoCacheModel>> _getBox() async {
    _box ??= await Hive.openLazyBox<UserInfoCacheModel>(_boxName);
    return _box!;
  }

  @override
  Future<void> saveUserInfo(UserInfoCacheModel model) async {
    final box = await _getBox();
    await box.put(_userInfoKey, model);
    _cachedUserInfo = model;
  }

  @override
  Future<UserInfoCacheModel?> getUserInfo() async {
    if (_cachedUserInfo != null) {
      return _cachedUserInfo;
    }

    final box = await _getBox();
    final response = await box.get(
      _userInfoKey,
      defaultValue: const UserInfoCacheModel(
        age: '',
        gender: '',
        height: '',
        weight: '',
      ),
    );
    _cachedUserInfo = response;
    return response;
  }
}