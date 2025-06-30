import 'package:flutter/foundation.dart' show immutable;

@immutable
final class CalorieValidators {
  static const String _ageNotEmpty = 'Yaş boş bırakılamaz';
  static const String _ageNotValid = 'Geçerli bir yaş giriniz';
  static const String _ageTooYoung = "Yaş 13'ten küçük olamaz";
  static const String _ageTooOld = "Yaş 100'den büyük olamaz";

  static const String _heightNotEmpty = 'Boy boş bırakılamaz';
  static const String _heightNotValid = 'Geçerli bir boy giriniz';
  static const String _heightTooShort = "Boy 100 cm'den küçük olamaz";
  static const String _heightTooTall = "Boy 220 cm'den büyük olamaz";

  static const String _weightNotEmpty = 'Kilo boş bırakılamaz';
  static const String _weightNotValid = 'Geçerli bir kilo giriniz';
  static const String _weightTooLight = "Kilo 30 kg'dan küçük olamaz";
  static const String _weightTooHeavy = "Kilo 150 kg'dan büyük olamaz";

  // Age validation
  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return _ageNotEmpty;
    }

    final age = int.tryParse(value);
    if (age == null) {
      return _ageNotValid;
    }

    if (age < 13) {
      return _ageTooYoung;
    }

    if (age > 100) {
      return _ageTooOld;
    }

    return null;
  }

  // Height validation
  String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return _heightNotEmpty;
    }

    final height = int.tryParse(value);
    if (height == null) {
      return _heightNotValid;
    }

    if (height < 100) {
      return _heightTooShort;
    }

    if (height > 220) {
      return _heightTooTall;
    }

    return null;
  }

  // Weight validation
  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return _weightNotEmpty;
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return _weightNotValid;
    }

    if (weight < 30) {
      return _weightTooLight;
    }

    if (weight > 150) {
      return _weightTooHeavy;
    }

    return null;
  }
}
