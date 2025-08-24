import 'dart:math';

import 'package:avo_ai_diet/product/constants/water_notification_constants.dart';
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
    // Permission check
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

    // Cancel current notifications
    await cancelWaterReminder();

    // Schedule notifications at different random times for 7 days
    await _scheduleWeeklyRandomReminders();
  }

  Future<void> _scheduleWeeklyRandomReminders() async {
    final random = Random();
    final now = tz.TZDateTime.now(tz.local);

    for (var dayOffset = 0; dayOffset < 365; dayOffset++) {
      // Calculate new random time for each day
      final randomHour = 12 + random.nextInt(10); // 12-21 
      final randomMinute = random.nextInt(60); // 0-59

      var targetDate = now.add(Duration(days: dayOffset));
      var scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        randomHour,
        randomMinute,
      );

      // If the time calculated for today has passed, postpone it until tomorrow
      if (dayOffset == 0 && scheduledDate.isBefore(now)) {
        targetDate = now.add(const Duration(days: 1));
        scheduledDate = tz.TZDateTime(
          tz.local,
          targetDate.year,
          targetDate.month,
          targetDate.day,
          randomHour,
          randomMinute,
        );
      }

      // Only time future times
      if (scheduledDate.isAfter(now)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          1000 + dayOffset, 
          WaterNotificationConstants.title,
          WaterNotificationConstants.getRandomMessage(),
          scheduledDate,
          _getNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  NotificationDetails _getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        WaterNotificationConstants.channelId,
        WaterNotificationConstants.channelName,
        channelDescription: WaterNotificationConstants.channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  @override
  Future<void> cancelWaterReminder() async {
    for (final id in WaterNotificationConstants.weeklyNotificationIds) {
      await _flutterLocalNotificationsPlugin.cancel(id);
    }

    for (var i = 0; i < 365; i++) {
      await _flutterLocalNotificationsPlugin.cancel(1000 + i);
    }
  }

  @override
  Future<void> showPreviewNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      WaterNotificationConstants.previewNotificationId,
      WaterNotificationConstants.title,
      WaterNotificationConstants.getRandomMessage(),
      _getNotificationDetails(),
    );
  }
}
