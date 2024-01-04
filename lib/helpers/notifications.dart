import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
}

Future<void> getNotificationsPermission() async {
  await notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  await notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestExactAlarmsPermission();
}

void sendNotification(int id, String title, String body) {
  const AndroidNotificationDetails androidNotifDetails = AndroidNotificationDetails('trainUpdates', 'Train Updates',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails notifDetails = NotificationDetails(android: androidNotifDetails);
  notifications.show(id, title, body, notifDetails);
}