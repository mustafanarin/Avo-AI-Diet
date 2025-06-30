import 'package:avo_ai_diet/product/cache/model/daily_calorie/daily_calorie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IDailyCalorieManager {
  Future<void> saveCalorieData(DailyCalorieModel model);
  Future<DailyCalorieModel> getCalorieData();
}

final class DailyCalorieManager implements IDailyCalorieManager {
  static const String _boxName = 'dailyCalories';
  static const String _currentDayKey = 'currentDay';

  Box<DailyCalorieModel>? _box;

  Future<Box<DailyCalorieModel>> _getBox() async {
    _box ??= await Hive.openBox<DailyCalorieModel>(_boxName);
    return _box!;
  }

  @override
  Future<void> saveCalorieData(DailyCalorieModel model) async {
    final box = await _getBox();
    await box.put(_currentDayKey, model);
  }

  @override
  Future<DailyCalorieModel> getCalorieData() async {
    final box = await _getBox();
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    final response = box.get(_currentDayKey, defaultValue: DailyCalorieModel(lastResetDate: today));

    if (response?.lastResetDate != today) {
      final newModel = DailyCalorieModel(lastResetDate: today);
      await saveCalorieData(newModel);
      return newModel;
    }

    return response!;
  }
}