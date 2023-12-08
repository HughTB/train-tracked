import 'package:flutter/material.dart';

import 'main.dart';
import 'stations_search.dart';
import 'stations.g.dart';

class LiveTrainsPage extends StatefulWidget {
  const LiveTrainsPage({super.key, required this.title});

  final String title;

  @override
  State<LiveTrainsPage> createState() => _LiveTrainsPageState();
}

class _LiveTrainsPageState extends State<LiveTrainsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[const SizedBox(height: 64)] + updateStationsSearch(stations, stationSearchTerm, context, Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SearchBar(
                padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
                leading: const Icon(Icons.search),
                onChanged: (String? value) {
                  setState(() {
                    stationSearchTerm = value;
                  });
                },
              ),
            )
          ),
        ],
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