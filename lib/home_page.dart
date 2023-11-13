import 'package:flutter/material.dart';

import 'main.dart';
import 'stations_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Saved Stations',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (prefHomeStation != null) getStationWidget(getStationByCrs(stations, prefHomeStation)!, context),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Saved Journeys',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
          destinations: navBarItems,
          selectedIndex: currentNavIndex,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          onDestinationSelected: (int index) {
            if (index != currentNavIndex) {
              Navigator.pushReplacementNamed(context, getNavRoute(index));
            }
          }
      ),
    );
  }
}