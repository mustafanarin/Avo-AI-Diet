import 'package:avo_ai_diet/product/cache/model/water_reminder/water_reminder_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class IWaterReminderManager {
  Future<void> saveWaterReminderState(bool isEnabled);
  Future<bool> getWaterReminderState();
}

final class WaterReminderManager implements IWaterReminderManager {
  static const String _boxName = 'water_reminder';
  static const String _stateKey = 'state';

  LazyBox<WaterReminderModel>? _box;

  Future<LazyBox<WaterReminderModel>> _getBox() async {
    _box ??= await Hive.openLazyBox<WaterReminderModel>(_boxName);
    return _box!;
  }

  @override
  Future<void> saveWaterReminderState(bool isEnabled) async {
    final box = await _getBox();
    await box.put(_stateKey, WaterReminderModel(waterReminderEnabled: isEnabled));
  }

  @override
  Future<bool> getWaterReminderState() async {
    final box = await _getBox();
    final model = await box.get(
      _stateKey,
      defaultValue: WaterReminderModel(),
    );
    return model?.waterReminderEnabled ?? false;
  }
}