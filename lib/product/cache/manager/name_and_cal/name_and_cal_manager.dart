import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:hive/hive.dart';

abstract class INameAndCalManager {
  Future<void> saveNameCalori(NameAndCalModel model);
  Future<NameAndCalModel?> getNameCalori();
  Future<bool> isUserRegistered();
}

final class NameAndCalManager implements INameAndCalManager {
  static const String _boxName = 'nameAndCal';
  static const String _userInfoKey = 'userInfo';

  Box<NameAndCalModel>? _box;

  Future<Box<NameAndCalModel>> _getBox() async {
    _box ??= await Hive.openBox<NameAndCalModel>(_boxName);
    return _box!;
  }

  @override
  Future<void> saveNameCalori(NameAndCalModel model) async {
    final box = await _getBox();
    await box.put(_userInfoKey, model);
  }

  @override
  Future<NameAndCalModel?> getNameCalori() async {
    final box = await _getBox();
    final response = box.get(
      _userInfoKey,
      defaultValue: NameAndCalModel(userName: '', targetCal: 2500),
    );
    return response;
  }

  @override
  Future<bool> isUserRegistered() async {
    final userInfo = await getNameCalori();
    return userInfo != null && userInfo.userName.isNotEmpty;
  }
}