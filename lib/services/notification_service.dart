import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

abstract class INotificationService {
  Future<void> init();

  Future<void> scheduleWaterReminder();

  Future<void> cancelWaterReminder();

  Future<void> showPreviewNotification();
}

@singleton
final class NotificationService implements INotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Notification id
  static const int _waterReminderNotificationId = 0;
  static const int _resetNotificationId = 1;
  static const int _previewNotificationId = 100;

  @override
  Future<void> init() async {
    tz_data.initializeTimeZones();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // notification plugin start
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.id == _resetNotificationId) {
      scheduleWaterReminder();
    }
  }

  @override
  Future<void> scheduleWaterReminder() async {
    final permissionStatus = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (permissionStatus != true) {
      return;
    }
    // cancel existing notifications to avoid further notifications
    await cancelWaterReminder();

    final now = DateTime.now();
    final random = Random();

    // choose a random time between 12:00 - 21:00
    final randomHour = 12 + random.nextInt(10);
    final randomMinute = random.nextInt(60);

    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      randomHour,
      randomMinute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _waterReminderNotificationId,
      'Su Hatırlatıcısı',
      'Hey, bugün yeteri kadar su içiyor musun? 🥑',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder',
          'water_reminder_channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    // this notification will not appear, it will work at midnight next day
    await _scheduleResetNotification();
  }

  // used only to program a new water reminder
  Future<void> _scheduleResetNotification() async {
    final now = DateTime.now();

    final midnightTime = DateTime(now.year, now.month, now.day + 1);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      _resetNotificationId,
      '',
      '',
      tz.TZDateTime.from(midnightTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reset_notification',
          'reset_notification_channel',
          playSound: false,
          enableVibration: false,
          importance: Importance.low,
          priority: Priority.low,
          channelShowBadge: false,
          visibility: NotificationVisibility.secret,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'reset_water_reminder',
    );
  }

  @override
  Future<void> cancelWaterReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(_waterReminderNotificationId);

    await _flutterLocalNotificationsPlugin.cancel(_resetNotificationId);
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
          'Su Hatırlatıcısı',
          channelDescription: 'Su içmeyi hatırlatan bildirimler',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
