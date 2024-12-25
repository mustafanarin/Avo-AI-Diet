import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract final class ProjectStrings {
  // Welcome Page
  static const String welcomeTitle = 'Sağlıklı Yaşama Merhaba!';
  static const String welcomeDescription =
      'Ben Avo! Yapay zeka destekli beslenme koçun olarak, seni daha sağlıklı ve enerjik bir yaşama ulaştırmak için buradayım.';
  static const String welcomeButton = 'Hadi Başlayalım';

  // Name Input Page
  static const String nameInputTitle = 'Seni Tanıyalım!';
  static const String nameInputDescription = 'Sana daha iyi hizmet verebilmem için\nadını öğrenebilir miyim?';
  static const String nameInputButton = 'Devam Et';
  static const String nameInputHintText = 'Adını yazar mısın?';
}
