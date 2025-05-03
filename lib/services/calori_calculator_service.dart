import 'package:avo_ai_diet/product/constants/enum/general/activity_level.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/activity_level_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/goal_extension.dart';

final class CalorieCalculatorService {
  static double calculateBMR({
    required String gender,
    required double weight,
    required double height,
    required double age,
  }) {
    if (gender == ProjectStrings.male) {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  static double calculateTotalCalories({
    required double bmr,
    required ActivityLevel activityLevel,
    required String goalDisplayName,
  }) {
    var totalCalories = bmr * activityLevel.multiplier;

    final goal = GoalExtension.fromDisplayName(goalDisplayName);

    totalCalories *= goal.multiplier;

    return totalCalories;
  }
}
