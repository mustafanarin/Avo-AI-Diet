import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'daily_calorie_model.g.dart';

@HiveType(typeId: 3)
final class DailyCalorieModel extends Equatable {
  const DailyCalorieModel({required this.lastResetDate, this.currentCalories = 0});
  @HiveField(0)
  final int currentCalories;
  @HiveField(1)
  final String lastResetDate;

  @override
  List<Object?> get props => [currentCalories, lastResetDate];
}
