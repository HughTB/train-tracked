import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main.dart';
import 'stations_search.dart';
import 'services_search.dart';
import 'stations.g.dart';

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
    return FutureBuilder(
      future: getLiveCards(crs, context),
      initialData: <Widget>[Container(
        height: 200,
        alignment: Alignment.center,
        child: SpinKitFoldingCube(
          color: Theme.of(context).primaryColor,
        ),
      )],
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> liveCards) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            actions: [
              IconButton(
                  icon: (savedStationsBox.containsKey(crs) || savedStationsBox.get("home")?.crs == crs) ? const Icon(Icons.star) : const Icon(Icons.star_border),
                  tooltip: 'Favourite Station',
                  onPressed: () {
                    if (savedStationsBox.get("home")?.crs == crs) { return; }

                    setState(() {
                      if (savedStationsBox.containsKey(crs)) {
                        savedStationsBox.delete(crs);
                      } else {
                        savedStationsBox.put(crs, getStationByCrs(stations, crs));
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
              children: (liveCards.data != null) ? liveCards.data! : <Widget>[],
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