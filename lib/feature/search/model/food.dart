
class Food {
  final String name;
  final double calorie;
  final double protein;
  final double carbohydrate;
  final double fat;

  Food({
    required this.name,
    required this.calorie,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] as String,
      calorie: (json['calorie'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbohydrate: (json['carbohydrate'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calorie': calorie,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
    };
  }
}