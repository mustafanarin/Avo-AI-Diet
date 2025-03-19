import 'package:hive_flutter/hive_flutter.dart';

part 'daily_calorie_model.g.dart';
// TODOequtable?
@HiveType(typeId: 3)
final class DailyCalorieModel {
  DailyCalorieModel({required this.lastResetDate, this.currentCalories = 0});
  @HiveField(0)
  final int currentCalories;
  @HiveField(1)
  final String lastResetDate;
}
