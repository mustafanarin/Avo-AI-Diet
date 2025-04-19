import 'package:hive_flutter/hive_flutter.dart';

part 'water_reminder_model.g.dart';

@HiveType(typeId: 5)
class WaterReminderModel {
  WaterReminderModel({
    this.waterReminderEnabled = false,
  });

  @HiveField(0)
  bool waterReminderEnabled;
}
