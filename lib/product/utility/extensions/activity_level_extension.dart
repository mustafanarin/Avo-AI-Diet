import 'package:avo_ai_diet/product/constants/enum/general/activity_level.dart';

extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedanter (hareketsiz yaşam)';
      case ActivityLevel.lightlyActive:
        return 'Hafif aktif (haftada 1-3 gün egzersiz)';
      case ActivityLevel.moderatelyActive:
        return 'Orta aktif (haftada 3-5 gün egzersiz)';
      case ActivityLevel.veryActive:
        return 'Çok aktif (haftada 6-7 gün egzersiz)';
      case ActivityLevel.extraActive:
        return 'Profesyonel sporcu seviyesi';
    }
  }

  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.extraActive:
        return 1.9;
    }
  }

  static ActivityLevel fromDisplayName(String name) {
    switch (name) {
      case 'Sedanter (hareketsiz yaşam)':
        return ActivityLevel.sedentary;
      case 'Hafif aktif (haftada 1-3 gün egzersiz)':
        return ActivityLevel.lightlyActive;
      case 'Orta aktif (haftada 3-5 gün egzersiz)':
        return ActivityLevel.moderatelyActive;
      case 'Çok aktif (haftada 6-7 gün egzersiz)':
        return ActivityLevel.veryActive;
      case 'Profesyonel sporcu seviyesi':
        return ActivityLevel.extraActive;
      default:
        return ActivityLevel.sedentary;
    }
  }

  static List<String> get allDisplayNames {
    return ActivityLevel.values.map((level) => level.displayName).toList();
  }
}
