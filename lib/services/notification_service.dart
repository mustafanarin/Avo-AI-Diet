import 'dart:math';

import 'package:avo_ai_diet/product/constants/water_notification_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
// WaterNotificationConstants import'unu buraya ekleyin

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

    // Calculate different random hours for each day
    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final randomHour = 12 + random.nextInt(10); // Between 12-21
      final randomMinute = random.nextInt(60); // Between 0-59

      final targetDate = now.add(Duration(days: dayOffset));
      final scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        randomHour,
        randomMinute,
      );

      // Only program future times
      if (scheduledDate.isAfter(now)) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          WaterNotificationConstants.weeklyNotificationIds[dayOffset],
          WaterNotificationConstants.title,
          WaterNotificationConstants.getRandomMessage(),
          scheduledDate,
          _getNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
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
    // Cancel all weekly notifications
    for (final id in WaterNotificationConstants.weeklyNotificationIds) {
      await _flutterLocalNotificationsPlugin.cancel(id);
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
