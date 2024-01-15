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
  await notifications.initialize(notifInitSettings);

  // If we were launched from a notification, push the service view to the navigator
  final NotificationAppLaunchDetails? appLaunchDetails = await notifications.getNotificationAppLaunchDetails();

  if (appLaunchDetails != null && appLaunchDetails.didNotificationLaunchApp) {
    if (appLaunchDetails.notificationResponse?.actionId != null) {
      Service? service = await getServiceDetails(appLaunchDetails.notificationResponse!.actionId!, null);
      if (service != null) {
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => ServiceViewPage(service: service, oldService: false)
        ));
      }
    }
  }
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