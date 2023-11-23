import 'package:flutter/material.dart';

import 'main.dart';
import 'service.dart';
import 'services_search.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("to ${service.destination.station?.stationName}"),
        actions: [
          IconButton(
            icon: (savedServicesBox.get(service.rid) == true) ? const Icon(Icons.save) : const Icon(Icons.save_outlined),
            tooltip: 'Save Service',
            onPressed: () {
              setState(() {
                if (savedServicesBox.get(service.rid) == true) {
                  savedServicesBox.put(service.rid, false);
                } else {
                  savedServicesBox.put(service.rid, true);
                }
              });
            }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: getServiceView(context, service),
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
}