import 'package:flutter/material.dart';

import '../main.dart';
import '../helpers/stations_search.dart';
import '../classes/station_list.g.dart';

class ArrDepSearchPage extends StatefulWidget {
  const ArrDepSearchPage({super.key, required this.title});

  final String title;

  @override
  State<ArrDepSearchPage> createState() => _ArrDepSearchPageState();
}

class _ArrDepSearchPageState extends State<ArrDepSearchPage> {
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
              navigatorKey.currentState?.popUntil((route) => route.isFirst);
              navigatorKey.currentState?.pushReplacementNamed(getNavRoute(index));
            }
          }
      ),
    );
  }
}