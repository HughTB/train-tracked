import 'package:flutter/material.dart';

import 'live_tracking_page.dart';

const Color onTimeColour = Colors.lightGreen;
const Color delayedColour = Colors.orange;
const Color cancelledColour = Colors.red;

class Service {
  int? rid;
  String? destination;
  String? origin;
  String? std;
  String? etd;
  String? sta;
  String? eta;
  String? platform;

  Service(this.rid, this.destination, this.origin, this.std, this.etd, this.sta, this.eta, this.platform);
}

List<Service> getLiveDepartures(String crs) {
  List<Service> services = [];

  services.add(Service(10, "London Waterloo", "Bournemouth", "13:00", "On Time", "15:21", "On Time", "1"));
  services.add(Service(11, "Portsmouth & Southsea", "Southampton Central", "13:44", "13:50", "14:38", "13:40", "3a"));
  services.add(Service(12, "London Victoria", "Southampton Central", "14:02", "On Time", "16:30", "On Time", "2"));
  services.add(Service(13, "Bournemouth", "Manchester Piccadilly", "14:10", "On Time", "15:03", "On Time", "4"));
  services.add(Service(14, "Poole", "London Waterloo", "14:20", "On Time", "17:10", "On Time", "3b"));
  services.add(Service(15, "Romsey", "Romsey", "14:24", "On Time", "14:54", "On Time", "2b"));

  return services;
}

List<Widget> getLiveCards(List<Service> services, BuildContext context) {
  List<Widget> cards = [];

  if (services.isEmpty) {
    cards.add(const Text("There are no trains :,("));
    return cards;
  }

  for (Service service in services) {
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
                      color: (service.etd != "On Time") ? delayedColour : onTimeColour,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "to ${service.destination}",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: ((service.etd != "On Time") ? <TextSpan>[TextSpan(
                              text: "${service.etd} ",
                              style: TextStyle(
                                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                                color: delayedColour,
                              )
                          )] : <TextSpan>[]) + <TextSpan>[TextSpan(
                            text: "${service.std}",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              decoration: (service.etd != "On Time") ? TextDecoration.lineThrough : null,
                            ),
                          )],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 10,
                        color: Colors.white,
                      ),
                      Text.rich(
                        TextSpan(
                          children: ((service.eta != "On Time") ? <TextSpan>[TextSpan(
                            text: "${service.eta} ",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: delayedColour,
                            )
                          )] : <TextSpan>[]) + <TextSpan>[TextSpan(
                            text: "${service.sta}",
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              decoration: (service.eta != "On Time") ? TextDecoration.lineThrough : null,
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
                      "${service.platform}",
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
                title: "to ${service.destination}",
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