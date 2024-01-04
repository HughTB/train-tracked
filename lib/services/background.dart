import 'package:workmanager/workmanager.dart';

import '../helpers/notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (task == "service_check") {
      initNotifications();
      sendNotification(10, "More Testing Notification", "This is a test notification sent from $task");
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  });
}