import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:train_tracked/helpers/stations_search.dart';
import 'package:workmanager/workmanager.dart';

import '../api/api.dart';

import '../classes/service.dart';
import '../classes/station.dart';
import '../classes/station_list.g.dart';
import '../classes/stopping_point.dart';

import '../helpers/notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "service_check") {
      // Initialise notifications service
      initNotifications();

      // Initialise Hive and register adapters
      await Hive.initFlutter();
      Hive.registerAdapter(StationAdapter());
      Hive.registerAdapter(StoppingPointAdapter());
      Hive.registerAdapter(ServiceAdapter());

      // Open Boxes and get data out of them
      final savedServicesBox = await Hive.openBox<Service?>('savedServices');
      final savedServices = savedServicesBox.values;

      final preferencesBox = await Hive.openBox('preferences');
      final platformChangeNotif = preferencesBox.get('platformChangeNotif') ?? false;
      final delayNotif = preferencesBox.get('delayNotif') ?? false;
      final cancellationNotif = preferencesBox.get('cancellationNotif') ?? false;
      preferencesBox.close();

      // If no notifications are enabled, close immediately
      if (!platformChangeNotif && !delayNotif && !cancellationNotif) { return Future.value(true); }

      // For each service, check if a notification needs to be sent
      for (Service? service in savedServices) {
        // If the service doesn't exist, skip it
        if (service == null) { continue; }
        // If updates are stopped for a service, skip it
        if (service.getUpdates == false) { continue; }
        // If the service arrived before now, there's no point doing anything with it
        if (DateTime.tryParse(service.stoppingPoints.last.ata!)?.isBefore(DateTime.now()) ?? false) { continue; }

        // Only do this parsing once
        int notifId = int.parse(service.rid.substring(8));
        String notifTitle = "${DateTime.tryParse(service.stoppingPoints.first.std!)?.format('H:i')} to ${getStationByCrs(stations, service.stoppingPoints.last.crs)?.stationName}";
        String notifBody = "";

        // Update the service, if possible
        Service? updated = await getServiceDetails(service.rid, null, getUpdates: service.getUpdates);

        if (updated == null) {
          // Notify the user if we were unable to update the information
          sendNotification(notifId, notifTitle, "Unable to get updated information.");
          // If we couldn't get information for this service, we probably can't get it for any services
          break;
        } else {
          // If we got updated information, store it for later use
          savedServicesBox.put(updated.rid, updated);
        }

        // Check through each stopping point for the first new cancellation (in order from origin to destination)
        if (cancellationNotif) {
          for (int i = 0; (i < service.stoppingPoints.length && i < updated.stoppingPoints.length); i++) {
            StoppingPoint oldSP = service.stoppingPoints[i];
            StoppingPoint updatedSP = updated.stoppingPoints[i];

            if (oldSP.cancelledHere != updatedSP.cancelledHere) {
              notifBody = "Cancelled at ${getStationByCrs(stations, updatedSP.crs)?.stationName}.";
              break;
            }
          }
        }

        // Check through each stopping point for the first new delay (in order from origin to destination),
        // only if there have been no cancellations
        if (delayNotif && notifBody == "") {
          for (int i = 0; (i < service.stoppingPoints.length && i < updated.stoppingPoints.length); i++) {
            StoppingPoint oldSP = service.stoppingPoints[i];
            StoppingPoint updatedSP = updated.stoppingPoints[i];

            if ((updatedSP.ataForecast ?? false) && (oldSP.ata != updatedSP.ata)) {
              final delayedMins = DateTime.tryParse(updatedSP.ata!)!.difference(DateTime.tryParse(updatedSP.sta!)!).inMinutes;

              if (delayedMins == 0) {
                notifBody = "Now running on time at ${getStationByCrs(stations, updatedSP.crs)?.stationName}.";
              } else {
                notifBody = "Delayed by $delayedMins minute${delayedMins == 1 ? '' : 's'} at ${getStationByCrs(stations, updatedSP.crs)?.stationName}.";
              }

              break;
            } else if ((updatedSP.atdForecast ?? false) && (oldSP.atd != updatedSP.atd)) {
              final delayedMins = DateTime.tryParse(updatedSP.atd!)!.difference(DateTime.tryParse(updatedSP.std!)!).inMinutes;

              if (delayedMins == 0) {
                notifBody = "Now running on time at ${getStationByCrs(stations, updatedSP.crs)?.stationName}.";
              } else {
                notifBody = "Delayed by $delayedMins minute${delayedMins == 1 ? '' : 's'} at ${getStationByCrs(stations, updatedSP.crs)?.stationName}.";
              }

              break;
            }
          }
        }

        // Check through each stopping point for the first new platform change (in order from origin to destination),
        // only if there have been no cancellations or delays
        if (platformChangeNotif && notifBody == "") {
          for (int i = 0; (i < service.stoppingPoints.length && i < updated.stoppingPoints.length); i++) {
            StoppingPoint oldSP = service.stoppingPoints[i];
            StoppingPoint updatedSP = updated.stoppingPoints[i];

            if ((oldSP.platform != updatedSP.platform)) {
              notifBody = "Platform change at ${getStationByCrs(stations, updatedSP.crs)?.stationName} - Now departing from Platform ${updatedSP.platform}.";
              break;
            }
          }
        }

        if (notifBody != "") {
          notifBody += "\nTap for more details";
          sendNotification(
            notifId,
            notifTitle,
            notifBody,
            actions: [
              AndroidNotificationAction("show${service.rid}", "More Information", showsUserInterface: true),
              AndroidNotificationAction("stop${service.rid}", "Stop Updates", showsUserInterface: true),
            ],
          );
        }
      }

      savedServicesBox.close();

      return Future.value(true);
    } else {
      return Future.value(false);
    }
  });
}