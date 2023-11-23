import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import 'live_tracking_page.dart';
import 'main.dart';
import 'service.dart';
import 'station.dart';
import 'stations_search.dart';
import 'stopping_point.dart';

const Color onTimeColour = Colors.lightGreen;
const Color delayedColour = Colors.orange;
const Color cancelledColour = Colors.red;


List<Service> getLiveDepartures(String crs) {
  List<Service> services = [];

  // Temp services for testing
  services.add(Service(
    20231122001,
    StoppingPoint(
      "3",
      null,
      null,
      DateTime.tryParse("2023-11-22T15:03:00"),
      DateTime.tryParse("2023-11-22T15:03:00"),
      getStationByCrs(stations, "WEY"),
      false
    ),
    StoppingPoint(
      "16",
      DateTime.tryParse("2023-11-22T17:51:00"),
      DateTime.tryParse("2023-11-22T17:54:00"),
      null,
      null,
      getStationByCrs(stations, "WAT"),
      true
    ),
    <StoppingPoint>[
      StoppingPoint(
        "3",
        null,
        null,
        DateTime.tryParse("2023-11-22T15:03:00"),
        DateTime.tryParse("2023-11-22T15:03:00"),
        getStationByCrs(stations, "WEY"),
        false
      ),
      StoppingPoint(
        "1",
        DateTime.tryParse("2023-11-22T15:12:00"),
        DateTime.tryParse("2023-11-22T15:12:00"),
        DateTime.tryParse("2023-11-22T15:13:00"),
        DateTime.tryParse("2023-11-22T15:13:00"),
        getStationByCrs(stations, "DCH"),
        false
      ),
      StoppingPoint(
        "1",
        DateTime.tryParse("2023-11-22T15:27:00"),
        DateTime.tryParse("2023-11-22T15:27:00"),
        DateTime.tryParse("2023-11-22T15:28:00"),
        DateTime.tryParse("2023-11-22T15:28:00"),
        getStationByCrs(stations, "WRM"),
        false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T15:34:00"),
          DateTime.tryParse("2023-11-22T15:34:00"),
          DateTime.tryParse("2023-11-22T15:35:00"),
          DateTime.tryParse("2023-11-22T15:35:00"),
          getStationByCrs(stations, "HAM"),
          false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T15:39:00"),
          DateTime.tryParse("2023-11-22T15:39:00"),
          DateTime.tryParse("2023-11-22T15:40:00"),
          DateTime.tryParse("2023-11-22T15:40:00"),
          getStationByCrs(stations, "POO"),
          false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T15:44:00"),
          DateTime.tryParse("2023-11-22T15:44:00"),
          DateTime.tryParse("2023-11-22T15:44:00"),
          DateTime.tryParse("2023-11-22T15:44:00"),
          getStationByCrs(stations, "PKS"),
          false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T15:48:00"),
          DateTime.tryParse("2023-11-22T15:48:00"),
          DateTime.tryParse("2023-11-22T15:48:00"),
          DateTime.tryParse("2023-11-22T15:48:00"),
          getStationByCrs(stations, "BSM"),
          false
      ),
      StoppingPoint(
          "2",
          DateTime.tryParse("2023-11-22T15:54:00"),
          DateTime.tryParse("2023-11-22T15:54:00"),
          DateTime.tryParse("2023-11-22T15:59:00"),
          DateTime.tryParse("2023-11-22T15:59:00"),
          getStationByCrs(stations, "BMH"),
          false
      ),
      StoppingPoint(
          "2",
          DateTime.tryParse("2023-11-22T16:13:00"),
          DateTime.tryParse("2023-11-22T16:13:00"),
          DateTime.tryParse("2023-11-22T16:14:00"),
          DateTime.tryParse("2023-11-22T16:14:00"),
          getStationByCrs(stations, "BCU"),
          false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T16:28:00"),
          DateTime.tryParse("2023-11-22T16:28:00"),
          DateTime.tryParse("2023-11-22T16:30:00"),
          DateTime.tryParse("2023-11-22T16:30:00"),
          getStationByCrs(stations, "SOU"),
          false
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T16:37:00"),
          DateTime.tryParse("2023-11-22T16:37:00"),
          DateTime.tryParse("2023-11-22T16:38:00"),
          DateTime.tryParse("2023-11-22T16:38:00"),
          getStationByCrs(stations, "SOA"),
          true
      ),
      StoppingPoint(
          "1",
          DateTime.tryParse("2023-11-22T16:47:00"),
          DateTime.tryParse("2023-11-22T16:49:00"),
          DateTime.tryParse("2023-11-22T16:48:00"),
          DateTime.tryParse("2023-11-22T16:52:00"),
          getStationByCrs(stations, "WIN"),
          true
      ),
      StoppingPoint(
          "2",
          DateTime.tryParse("2023-11-22T17:20:00"),
          DateTime.tryParse("2023-11-22T17:24:00"),
          DateTime.tryParse("2023-11-22T17:21:00"),
          DateTime.tryParse("2023-11-22T17:25:00"),
          getStationByCrs(stations, "WOK"),
          false
      ),
      StoppingPoint(
        "16",
        DateTime.tryParse("2023-11-22T17:51:00"),
        DateTime.tryParse("2023-11-22T17:54:00"),
        null,
        null,
        getStationByCrs(stations, "WAT"),
        true
      ),
    ],
    "16:27",
    "On Time",
    "16:30",
    "On Time",
    "2a",
    5
  ));
  services.add(Service(
      20231122002,
      StoppingPoint(
        "3",
        null,
        null,
        DateTime.tryParse("2023-11-22T14:03:00"),
        DateTime.tryParse("2023-11-22T14:03:00"),
        getStationByCrs(stations, "WEY"),
        false
      ),
      StoppingPoint(
        "16",
        DateTime.tryParse("2023-11-22T18:51:00"),
        DateTime.tryParse("2023-11-22T18:51:00"),
        null,
        null,
        getStationByCrs(stations, "WAT"),
        true
      ),
      <StoppingPoint>[
        StoppingPoint(
          "3",
          null,
          null,
          DateTime.tryParse("2023-11-22T14:03:00"),
          DateTime.tryParse("2023-11-22T14:03:00"),
          getStationByCrs(stations, "WEY"),
          false
        ),
        StoppingPoint(
          "16",
          DateTime.tryParse("2023-11-22T18:51:00"),
          DateTime.tryParse("2023-11-22T18:51:00"),
          null,
          null,
          getStationByCrs(stations, "WAT"),
          true
        ),
      ],
      "17:27",
      "On Time",
      "17:30",
      "On Time",
      "1",
      10
  ));

  return services;
}

List<Widget> getLiveCards(List<Service> services, BuildContext context) {
  List<Widget> cards = [];

  if (services.isEmpty) {
    cards.add(const Text("There are no trains :,("));
    return cards;
  }

  for (Service service in services) {
    bool delayedDeparture = (service.thisEtd != "On Time");
    bool delayedArrival = (service.destination.eta != service.destination.sta);

    cards.add(
      Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: (delayedDeparture || delayedArrival) ? delayedColour : onTimeColour,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "to ${service.destination.station?.stationName}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "${service.numCoaches} Coaches",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: (delayedDeparture ? <TextSpan>[TextSpan(
                              text: "${service.thisEtd} ",
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                color: delayedColour,
                              )
                          )] : <TextSpan>[]) + <TextSpan>[TextSpan(
                            text: "${service.thisStd}",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              decoration: delayedDeparture ? TextDecoration.lineThrough : null,
                            ),
                          )],
                        ),
                      ),
                      Container(
                        width: 1.5,
                        height: 15,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      Text.rich(
                        TextSpan(
                          children: (delayedArrival ? <TextSpan>[TextSpan(
                            text: "${service.destination.eta?.format('H:i')} ",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: delayedColour,
                            )
                          )] : <TextSpan>[]) + <TextSpan>[TextSpan(
                            text: "${service.destination.sta?.format('H:i')}",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              decoration: delayedArrival ? TextDecoration.lineThrough : null,
                            ),
                          )],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Platform",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "${service.thisPlatform}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => LiveTrackingPage(
                service: service,
              )
            ));
          },
        ),
      )
    );
  }

  return cards;
}

List<Widget> getServiceView(BuildContext context, Service service) {
  List<Widget> widgets = [];

  int i = 0;
  int last = service.stoppingPoints.length - 1;

  for (StoppingPoint stoppingPoint in service.stoppingPoints) {
    bool delayedDeparture = (stoppingPoint.std != stoppingPoint.etd);
    bool delayedArrival = (stoppingPoint.sta != stoppingPoint.eta);

    widgets.add(Row(
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: (i == 0) ? 25 : 0, bottom: (i == last) ? 25 : 0),
              child: Container(
                width: 2,
                height: (i == 0 || i == last) ? 25 : 50,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                width: 10,
                height: 2,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            width: 50,
            child: (i == last) ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${stoppingPoint.sta?.format('H:i')}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      decoration: (delayedArrival) ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ] + ((delayedArrival) ? [
                  TextSpan(
                    text: " ${stoppingPoint.eta?.format('H:i')}",
                    style: TextStyle(
                      color: (delayedArrival) ? delayedColour : Theme.of(context).canvasColor,
                    ),
                  ),
                ] : []),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ) : Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "${stoppingPoint.std?.format('H:i')}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      decoration: (delayedDeparture) ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ] + ((delayedDeparture) ? [
                  TextSpan(
                    text: " ${stoppingPoint.etd?.format('H:i')}",
                    style: TextStyle(
                      color: (delayedDeparture) ? delayedColour : Theme.of(context).canvasColor,
                    ),
                  ),
                ] : []),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${stoppingPoint.station?.stationName}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "Platform ${stoppingPoint.platform}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    ));

    i++;
  }

  return widgets;
}