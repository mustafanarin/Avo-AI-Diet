import 'package:avo_ai_diet/product/cache/model/name_calori/name_and_cal.dart';
import 'package:hive/hive.dart';

abstract class INameAndCalManager {
  Future<void> saveNameCalori(NameAndCalModel model);
  Future<NameAndCalModel?> getNameCalori();
}

final class NameAndCalManager implements INameAndCalManager {
  Box<NameAndCalModel>? _box;

  Future<Box<NameAndCalModel>> _getBox() async {
    _box ??= await Hive.openBox<NameAndCalModel>('nameAndCal');
    return _box!;
  }

  @override
  Future<void> saveNameCalori(NameAndCalModel model) async {
    final box = await _getBox();
    await box.put('userInfo', model);
  }

  @override
  Future<NameAndCalModel?> getNameCalori() async {
    final box = await _getBox();
    final response = box.get(
      'userInfo',
      defaultValue: NameAndCalModel(userName: '', targetCal: 2500),
    );
    return response;
  }
}
