import 'dart:math';

final class WaterNotificationConstants {
  WaterNotificationConstants._();

  static const String title = 'Su Hatırlatıcısı 💧';
  static const String channelName = 'Water Reminder';
  static const String channelDescription = 'Su içmeyi hatırlatan bildirimler';
  static const String channelId = 'water_reminder';
  
  // Notification IDs
  static const List<int> weeklyNotificationIds = [1001, 1002, 1003, 1004, 1005, 1006, 1007];
  static const int previewNotificationId = 100;
  
  // Water reminder messages
  static const List<String> messages = [
    'Hey, bugün yeteri kadar su içiyor musun? 🥑',
    'Su içme zamanı! Vücudun sana teşekkür edecek 💧',
    'Hidrat kalmayı unutma! 🌊',
    'Bir bardak su içmek için mükemmel zaman ✨',
    'Su içmeyi unutma, enerjin için önemli! ⚡',
    'Sağlıklı yaşam suyla başlar 🌿',
    'Vücudunun %70\'i su, eksiltme! 💦',
    'Su iç, kendini iyi hisset! 🌟',
    'Metabolizman için su şart! 🔥',
    'Cildin için su iç! ✨',
  ];

  // Utility method for random message selection
  static String getRandomMessage() {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }
}