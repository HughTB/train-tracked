import 'package:flutter/material.dart';

class Service {
  int? rid;
  String? destination;
  String? origin;
  String? std;
  String? sta;
  String? platform;

  Service(this.rid, this.destination, this.origin, this.std, this.sta, this.platform);
}

List<Service> getLiveDepartures(String crs) {
  List<Service> services = [];

  services.add(Service(10, "London Waterloo", "Bournemouth", "13:00", "15:21", "3a"));

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
                const SizedBox(
                  height: 70,
                  width: 10,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color(0xFF92E335)
                      )
                  ),
                ),
                Expanded(
                  child: Text(
                    " to ${service.destination}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        "${service.std}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                      Container(
                        width: 2,
                        height: 10,
                        color: Colors.white,
                      ),
                      Text(
                        "${service.sta}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),
                Text(
                  "${service.platform}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                const Text(
                  "Gaming",
                )
            ));
          },
        ),
      )
    );
  }

  return cards;
}