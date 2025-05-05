final class FoodModel {
  FoodModel({
    required this.name,
    required this.calorie,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.icon,
    this.unitType = 'gram',
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['name'] as String,
      calorie: (json['calorie'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      icon: json['icon'] as String,
      unitType: json['unit_type'] as String? ?? 'gram',
    );
  }
  
  final String name;
  final double calorie;
  final double protein;
  final double carbohydrate;
  final double fat;
  final String icon;
  final String unitType;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calorie': calorie,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'icon': icon,
      'unit_type': unitType,
    };
  }
  
  String getUnitLabel() {
    return unitType;
  }
}