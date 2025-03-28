import 'package:avo_ai_diet/product/cache/model/daily_calorie/daily_calorie_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IDailyCalorieManager {
  Future<void> saveCalorieData(DailyCalorieModel model);
  Future<DailyCalorieModel> getCalorieData();
}

@singleton
final class DailyCalorieManager implements IDailyCalorieManager {
  Box<DailyCalorieModel>? _box;

  Future<Box<DailyCalorieModel>> _getBox() async {
    _box ??= await Hive.openBox<DailyCalorieModel>('dailyCalories');
    return _box!;
  }

  @override
  Future<void> saveCalorieData(DailyCalorieModel model) async {
    final box = await _getBox();
    await box.put('currentDay', model);
  }

  @override
  Future<DailyCalorieModel> getCalorieData() async {
    final box = await _getBox();
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    final response = box.get('currentDay', defaultValue: DailyCalorieModel(lastResetDate: today));

    if (response?.lastResetDate != today) {
      final newModel = DailyCalorieModel(lastResetDate: today);
      await saveCalorieData(newModel);
      return newModel;
    }

    return response!;
  }
}
