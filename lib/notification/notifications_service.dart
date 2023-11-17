import 'package:app_tarefas/notification/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimeZone();
    await _initializeNotifications();
  }

  Future<void> _setupTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = tz.local;
    tz.setLocalLocation(timeZoneName);
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationPlugin.initialize(
        const InitializationSettings(
          android: android,
        ),
        onSelectNotification: _onSelectedNotification);
  }

  _onSelectedNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .pushReplacementNamed(payload);
    }
  }

  showNotification(CustomNotification notification, DateTime date) {
    androidDetails = const AndroidNotificationDetails(
        'lembrete_notifications', 'Lembretes',
        channelDescription: 'Este canal é apra lembretes',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true);

    localNotificationPlugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        tz.TZDateTime.from(date, tz.local),
        NotificationDetails(android: androidDetails),
        payload: notification.payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  deleteNotification(int id) {
    localNotificationPlugin.cancel(id);
  }

  checkForNotification() async {
    final details =
        await localNotificationPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectedNotification(details.payload);
    }
  }
}
