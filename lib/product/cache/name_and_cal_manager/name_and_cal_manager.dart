import 'package:avo_ai_diet/product/model/name_calori/name_and_cal.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@singleton
final class NameAndCalManager {
  Box<NameAndCalModel>? _box;

  Future<Box<NameAndCalModel>> _getBox() async {
    _box ??= await Hive.openBox<NameAndCalModel>('nameAndCal');
    return _box!;
  }

  Future<void> saveNameCalori(NameAndCalModel model) async {
    final box = await _getBox();
    await box.put('userInfo', model);
  }

  Future<NameAndCalModel?> getNameCalori() async {
    final box = await _getBox();
    final response = box.get(
      'userInfo',
      defaultValue: NameAndCalModel(userName: '', targetCal: 2500),
    );
    return response;
  }
}
