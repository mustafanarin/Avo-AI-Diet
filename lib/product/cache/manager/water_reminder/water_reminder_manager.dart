import 'package:avo_ai_diet/product/cache/model/water_reminder/water_reminder_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class IWaterReminderManager {
  Future<void> saveWaterReminderState(bool isEnabled);

  Future<bool> getWaterReminderState();
}

@singleton
class WaterReminderManager implements IWaterReminderManager {
  LazyBox<WaterReminderModel>? _box;

  Future<LazyBox<WaterReminderModel>> _getBox() async {
    _box ??= await Hive.openLazyBox<WaterReminderModel>('water_reminder');
    return _box!;
  }

  @override
  Future<void> saveWaterReminderState(bool isEnabled) async {
    final box = await _getBox();
    await box.put('state', WaterReminderModel(waterReminderEnabled: isEnabled));
  }

  @override
  Future<bool> getWaterReminderState() async {
    final box = await _getBox();
    final model = await box.get(
      'state',
      defaultValue: WaterReminderModel(),
    );
    return model?.waterReminderEnabled ?? false;
  }
}
