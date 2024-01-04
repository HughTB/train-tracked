import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import '../api/api.dart';
import '../pages/service_view.dart';
import '../main.dart';
import '../classes/service.dart';
import 'stations_search.dart';
import '../classes/station_list.g.dart';
import '../classes/stopping_point.dart';

const Color onTimeColour = Colors.lightGreen;
const Color delayedColour = Colors.orange;
const Color cancelledColour = Colors.red;

Future<List<Widget>> getLiveCards(String crs, bool arrivals, BuildContext context) async {
  List<Widget> cards = [];
  List<Service>? services;

  if (arrivals) {
    services = await getArrivals(crs, ScaffoldMessenger.of(context));
  } else {
    services = await getDepartures(crs, ScaffoldMessenger.of(context));
  }

  if (services == null) {
    cards.add(const Text("There are no trains at this time :("));
    return cards;
  }

  for (Service service in services) {
    bool delayedDeparture = (service.atd?.substring(0, 16) != service.std?.substring(0, 16) && service.atd != null);
    bool delayedArrival = (service.ata?.substring(0, 16) != service.sta?.substring(0, 16) && service.ata != null);
    bool cancelled = service.cancelledHere ?? false;

    bool delayed = (arrivals) ? delayedArrival : delayedDeparture;
    bool replacementBus = service.platform == "BUS";
    bool replacementBusCancellation = preferencesBox.get("railReplacementCancellation");

    cards.add(
      Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 10,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: (cancelled || (replacementBus && replacementBusCancellation)) ? cancelledColour : (delayed || replacementBus) ? delayedColour : onTimeColour,
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
                          "${arrivals ? "from" : "to"} ${getStationByCrs(stations, (arrivals) ? service.origin.first : service.destination.first)?.stationName}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          service.operator,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: (cancelled ? <TextSpan>[TextSpan(
                              text: "Cancelled\n",
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                color: cancelledColour,
                              )
                          )] : delayed ? <TextSpan>[TextSpan(
                              text: "${DateTime.tryParse((arrivals) ? service.ata! : service.atd!)?.format('H:i')}\n",
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                                color: delayedColour,
                              )
                          )] : <TextSpan>[]) + <TextSpan>[TextSpan(
                            text: "${DateTime.tryParse((arrivals) ? service.sta! : service.std!)?.format('H:i')}",
                            style: TextStyle(
                              fontSize: (delayed || cancelled) ? Theme.of(context).textTheme.bodyMedium?.fontSize : Theme.of(context).textTheme.titleLarge?.fontSize,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              decoration: (delayed || cancelled) ? TextDecoration.lineThrough : null,
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
                      service.platform ?? "tbc",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ServiceViewPage(
                service: service,
                oldService: false,
              )
            ));
          },
        ),
      )
    );
  }

  return cards;
}

Future<List<Widget>> getServiceView(BuildContext context, Service? service, bool? updateServiceDetails) async {
  List<Widget> widgets = [];

  if (updateServiceDetails == true) {
    service = await getServiceDetails(service!.rid, ScaffoldMessenger.of(context));
  }

  if (service == null) {
    return [];
  }

  int i = 0;
  int last = service.stoppingPoints.length - 1;

  for (StoppingPoint stoppingPoint in service.stoppingPoints) {
    bool delayedArrival = (stoppingPoint.sta?.substring(0, 16) != stoppingPoint.ata?.substring(0, 16) && stoppingPoint.ata != null);
    bool delayedDeparture = (stoppingPoint.std?.substring(0, 16) != stoppingPoint.atd?.substring(0, 16) && stoppingPoint.atd != null);
    bool cancelled = stoppingPoint.cancelledHere ?? false;
    
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
            width: 70,
            child: (i == last) ? Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: DateTime.tryParse(stoppingPoint.sta!)?.format('H:i'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      decoration: (delayedArrival || cancelled) ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ] + ((cancelled) ? [
                  TextSpan(
                    text: "\nCancelled",
                    style: TextStyle(
                      color: (cancelled) ? cancelledColour : Theme.of(context).canvasColor,
                    ),
                  ),
                ] : (delayedArrival) ? [
                  TextSpan(
                    text: "\n${DateTime.tryParse(stoppingPoint.ata!)?.format('H:i')}",
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
                    text: DateTime.tryParse(stoppingPoint.std!)?.format('H:i'),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      decoration: (delayedDeparture || cancelled) ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ] + ((cancelled) ? [
                  TextSpan(
                    text: "\nCancelled",
                    style: TextStyle(
                      color: (cancelled) ? cancelledColour : Theme.of(context).canvasColor,
                    ),
                  ),
                ] : (delayedDeparture) ? [
                  TextSpan(
                    text: "\n${DateTime.tryParse(stoppingPoint.atd!)?.format('H:i')}",
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
              "${getStationByCrs(stations, stoppingPoint.crs)?.stationName}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "Platform ${(stoppingPoint.platform != null) ? stoppingPoint.platform : "tbc"}",
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

Future<Widget?> getSavedServiceWidget(Service? service, bool oldServices, bool last, BuildContext context) async {
  // If the service cannot be found, ignore it
  if (service == null) { return null; }

  // If the service finished more than 24 hours ago, ignore it if oldServices is false
  bool? thisServiceIsOld = DateTime.tryParse(service.stoppingPoints.last.sta!)?.isBefore(DateTime.now().subtract(const Duration(hours: 24)));
  if (thisServiceIsOld != oldServices) { return null; }
  if (thisServiceIsOld == false) {
    service = await getServiceDetails(service.rid, ScaffoldMessenger.of(context));
  }

  // If the service can no longer be found, ignore it
  if (service == null) { return null; }

  return InkWell(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).dividerColor.withAlpha((last) ? 0 : 50),
              width: 1.0
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "${DateTime.tryParse(service.stoppingPoints.first.std!)?.format('d/m/Y')} - "
              "${getStationByCrs(stations, service.stoppingPoints.first.crs)?.stationName} "
              "(${DateTime.tryParse(service.stoppingPoints.first.std!)?.format('H:i')}) "
              "to ${getStationByCrs(stations, service.stoppingPoints.last.crs)?.stationName} "
              "(${DateTime.tryParse(service.stoppingPoints.last.sta!)?.format('H:i')})",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => ServiceViewPage(
          service: service!,
          oldService: thisServiceIsOld ?? true,
        ),
      ));
    },
  );
}

Future<List<Widget>> getSavedServices(bool oldServices, BuildContext context) async {
  List<Widget> widgets = [];

  for (int i = 0; i < savedServicesBox.length; i++) {
    String rid = savedServicesBox.keys.toList()[i];

    if (savedServicesBox.get(rid) != null) {
      Widget? serviceWidget = await getSavedServiceWidget(savedServicesBox.get(rid), oldServices, i == (savedServicesBox.length - 1), context);

      if (serviceWidget != null) {
        widgets.add(serviceWidget);
      }
    }
  }

  if (widgets.isEmpty) {
    return [
      Text(
        (oldServices) ? "There are no old services yet!" : "There are no current services!",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ];
  }

  return widgets;
}