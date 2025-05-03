import 'package:avo_ai_diet/product/constants/enum/general/goal.dart';

extension GoalExtension on Goal {
  String get displayName {
    switch (this) {
      case Goal.loseWeight:
        return 'Kilo vermek';
      case Goal.maintainWeight:
        return 'Kilo korumak';
      case Goal.gainWeight:
        return 'Kilo almak';
    }
  }

  double get multiplier {
    switch (this) {
      case Goal.loseWeight:
        return 0.85;
      case Goal.maintainWeight:
        return 1;
      case Goal.gainWeight:
        return 1.15;
    }
  }

  static Goal fromDisplayName(String name) {
    switch (name) {
      case 'Kilo vermek':
        return Goal.loseWeight;
      case 'Kilo korumak':
        return Goal.maintainWeight;
      case 'Kilo almak':
        return Goal.gainWeight;
      default:
        return Goal.maintainWeight;
    }
  }

  static List<String> get allDisplayNames => Goal.values.map((g) => g.displayName).toList();
}
