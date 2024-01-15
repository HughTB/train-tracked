import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:train_tracked/api/api.dart';
import 'package:train_tracked/pages/service_view.dart';

import '../classes/service.dart';
import '../main.dart';

late final FlutterLocalNotificationsPlugin notifications;

void initNotifications() async {
  notifications = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings notifSettingsAndroid =
  AndroidInitializationSettings('notif_icon');
  const LinuxInitializationSettings notifSettingsLinux =
  LinuxInitializationSettings(
      defaultActionName: 'Open notification');
  const InitializationSettings notifInitSettings = InitializationSettings(
      android: notifSettingsAndroid,
      linux: notifSettingsLinux);

  await notifications.initialize(
    notifInitSettings,
    onDidReceiveNotificationResponse: _onReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: _onReceiveNotificationResponse,
  );
}

Future<void> getNotificationsPermission() async {
  await notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  await notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
}

void sendNotification(int id, String title, String body, {AndroidNotificationAction? action}) {
  AndroidNotificationDetails androidNotifDetails = AndroidNotificationDetails(
    'trainUpdates',
    'Train Updates',
    importance: Importance.high,
    priority: Priority.high,
    actions: (action != null) ? [action] : null,
  );
  NotificationDetails notifDetails = NotificationDetails(android: androidNotifDetails);
  notifications.show(id, title, body, notifDetails);
}

void _onReceiveNotificationResponse(NotificationResponse response) async {
  // Prefer the actionId, otherwise reassemble the first 4 digits of the RID from the date
  final rid = response.actionId ?? "${DateTime.now().format("Ymd")}${response.id}";

  Service? service = await getServiceDetails(rid, null);

  if (service != null) {
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => ServiceViewPage(service: service, oldService: true), // Report oldService so we don't make the same request twice
    ));
  }
}