import 'package:flutter/material.dart';

import 'main.dart';
import 'service.dart';
import 'services_search.dart';
import 'stations_search.dart';
import 'stations.g.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key, required this.service});

  final Service service;

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState(service);
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  Service service;

  _LiveTrackingPageState(this.service);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getServiceView(context, service.rid),
      initialData: const <Widget>[Text("Loading...")],
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> serviceView) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text("to ${getStationByCrs(stations, (service.stoppingPoints.isEmpty) ? service.destination.first : (service.stoppingPoints.last.crs))?.stationName}"),
            actions: [
              IconButton(
                  icon: (savedServicesBox.get(service.rid) != null) ? const Icon(Icons.save) : const Icon(Icons.save_outlined),
                  tooltip: 'Save Service',
                  onPressed: () {
                    setState(() {
                      if (savedServicesBox.get(service.rid) != null) {
                        savedServicesBox.put(service.rid, null);
                      } else {
                        savedServicesBox.put(service.rid, service);
                      }
                    });
                  }
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: serviceView.data!,
            ),
          ),
          bottomNavigationBar: NavigationBar(
              destinations: navBarItems,
              selectedIndex: currentNavIndex,
              indicatorColor: Theme.of(context).colorScheme.inversePrimary,
              onDestinationSelected: (int index) {
                if (index != currentNavIndex) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, getNavRoute(index));
                }
              }
          ),
        );
      }
    );
  }
}