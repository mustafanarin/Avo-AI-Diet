import 'package:avo_ai_diet/product/constants/enum/general/budget.dart';

extension BudgetExtension on Budget {
  String get displayName {
    switch (this) {
      case Budget.low:
        return 'Düşük bütçe';
      case Budget.medium:
        return 'Orta bütçe';
      case Budget.high:
        return 'Yüksek bütçe';
    }
  }

  static Budget fromDisplayName(String name) {
    switch (name) {
      case 'Düşük bütçe':
        return Budget.low;
      case 'Orta bütçe':
        return Budget.medium;
      case 'Yüksek bütçe':
        return Budget.high;
      default:
        return Budget.medium;
    }
  }

  static List<String> get allDisplayNames => Budget.values.map((b) => b.displayName).toList();
}
