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
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sharp),
            tooltip: 'Delete Recent Searches',
            onPressed: () {
              setState(() {
                recentSearchesBox.clear();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[const SizedBox(height: 64)] + updateStationsSearch(stations, stationSearchTerm, () { setState(() {}); }, context, Theme.of(context).colorScheme.inverseSurface),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SearchBar(
                padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
                leading: const Icon(Icons.search),
                autoFocus: true,
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