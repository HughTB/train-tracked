import 'package:flutter/material.dart';

import 'main.dart';
import 'services.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key, required this.title, required this.service});

  final String title;
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
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save Journey',
              onPressed: () {
                return;
              }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: getServiceView(service),
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