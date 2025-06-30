import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

abstract class INotificationService {
  Future<void> init();
  Future<void> scheduleWaterReminder();
  Future<void> cancelWaterReminder();
  Future<void> showPreviewNotification();
}

final class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Her gün için farklı ID'ler (7 gün = 7 farklı bildirim)
  static const List<int> _weeklyNotificationIds = [1001, 1002, 1003, 1004, 1005, 1006, 1007];
  static const int _previewNotificationId = 100;

  @override
  Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Future<void> scheduleWaterReminder() async {
    // Permission kontrolü
    var permissionGranted = false;

    final androidPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final iosPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    permissionGranted = (androidPermission ?? false) || (iosPermission ?? false);

    if (!permissionGranted) {
      return;
    }

    // Mevcut bildirimleri iptal et
    await cancelWaterReminder();

    // 7 gün boyunca farklı random saatlerde bildirimler programla
    await _scheduleWeeklyRandomReminders();
  }

  Future<void> _scheduleWeeklyRandomReminders() async {
    final random = Random();
    final now = tz.TZDateTime.now(tz.local);

    // Her gün için farklı random saat hesapla
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final randomHour = 12 + random.nextInt(10); // 12-21 arası
      final randomMinute = random.nextInt(60); // 0-59 arası

      final targetDate = now.add(Duration(days: dayOffset));
      final scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        randomHour,
        randomMinute,
      );

      // Sadece gelecekteki zamanları programla
      if (scheduledDate.isAfter(now)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          _weeklyNotificationIds[dayOffset],
          'Su Hatırlatıcısı 💧',
          _getRandomWaterMessage(),
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'water_reminder',
              'water_reminder_channel',
              channelDescription: 'Su içmeyi hatırlatan bildirimler',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  String _getRandomWaterMessage() {
    final messages = [
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
    
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  @override
  Future<void> cancelWaterReminder() async {
    // Tüm haftalık bildirimleri iptal et
    for (final id in _weeklyNotificationIds) {
      await _flutterLocalNotificationsPlugin.cancel(id);
    }
  }

  @override
  Future<void> showPreviewNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      _previewNotificationId,
      'Su Hatırlatıcısı 💧',
      _getRandomWaterMessage(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminder',
          channelDescription: 'Su içmeyi hatırlatan bildirimler',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}