final class UserInfoModel {
  UserInfoModel({
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.target,
    required this.budget,
    required this.targetCalories,
  });

  final double height;
  final double weight;
  final double age;
  final String gender;
  final String activityLevel;
  final String target;
  final String budget;
  final double targetCalories;
}
