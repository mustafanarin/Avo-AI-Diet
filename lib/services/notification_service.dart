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

  // Notification id
  static const int _waterReminderNotificationId = 0;
  static const int _previewNotificationId = 100;

  @override
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS ayarları eklendi
    const initializationSettingsIOS = DarwinInitializationSettings();

    // iOS ayarları initializationSettings'e eklendi
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS, // Bu satır eksikti
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  @override
  Future<void> scheduleWaterReminder() async {
    // iOS için permission isteği eklendi
    var permissionGranted = false;

    // Android permission kontrolü
    final androidPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS permission kontrolü
    final iosPermission = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Her iki platform için de izin kontrolü
    permissionGranted = (androidPermission ?? false) || (iosPermission ?? false);

    if (!permissionGranted) {
      return;
    }

    // Cancel existing notifications
    await cancelWaterReminder();

    // Schedule random notifications between 12:00-21:00 every day from now on
    await _scheduleDailyRandomReminder();
  }

  Future<void> _scheduleDailyRandomReminder() async {
    final random = Random();

    // Choose a random hour between 12:00 - 21:00
    final randomHour = 12 + random.nextInt(10); // Between 12 and 21
    final randomMinute = random.nextInt(60); // Between 0 and 59

    // Schedule a daily recurring notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _waterReminderNotificationId,
      'Su Hatırlatıcısı',
      'Hey, bugün yeteri kadar su içiyor musun? 🥑',
      _nextInstanceOfTime(randomHour, randomMinute),
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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Calculate the next occurrence for the specified hour and minute
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the selected time has passed, schedule for the next day
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  @override
  Future<void> cancelWaterReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(_waterReminderNotificationId);
  }

  @override
  Future<void> showPreviewNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      _previewNotificationId,
      'Su Hatırlatıcısı',
      'Hey, bugün yeteri kadar su içiyor musun? 🥑',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminder',
          channelDescription: 'Su içmeyi hatırlatan bildirimler',
          importance: Importance.high,
          priority: Priority.high,
        ),
        // iOS ayarları eklendi
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
