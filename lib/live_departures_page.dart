import 'package:flutter/material.dart';

import 'main.dart';
import 'stations_search.dart';

class LiveDeparturesPage extends StatefulWidget {
  const LiveDeparturesPage({super.key, required this.title, required this.crs});

  final String title;
  final String crs;

  @override
  State<LiveDeparturesPage> createState() => _LiveDeparturesPageState(crs);
}

class _LiveDeparturesPageState extends State<LiveDeparturesPage> {
  String crs;

  _LiveDeparturesPageState(this.crs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: (savedStations.containsKey(crs)) ? const Icon(Icons.star) : const Icon(Icons.star_border),
            tooltip: 'Favourite Station',
            onPressed: () {
              if (savedStations["home"]!.crs == crs) { return; }

              setState(() {
                if (savedStations.containsKey(crs)) {
                  savedStations.remove(crs);
                } else {
                  savedStations[crs] = getStationByCrs(stations, crs);
                }
              });
            }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: const [
            Text('lmao all the trains are cancelled 😢'),
          ],
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