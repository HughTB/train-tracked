import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import '../helpers/stations_search.dart';
import '../helpers/services_search.dart';
import '../classes/station_list.g.dart';

class ArrDepPage extends StatefulWidget {
  const ArrDepPage({super.key, required this.title, required this.crs});

  final String title;
  final String crs;

  @override
  State<ArrDepPage> createState() => _ArrDepPageState(crs);
}

class _ArrDepPageState extends State<ArrDepPage> {
  String crs;
  bool arrivals = false;

  late Future<List<Widget>> liveCardsFuture;

  _ArrDepPageState(this.crs);

  void refreshCards() {
    setState(() {
      liveCardsFuture = updateCards();
    });
  }

  Future<List<Widget>> updateCards() async {
    return await getLiveCards(crs, arrivals, context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: FutureBuilder(
        future: Future.wait([
          getLiveCards(crs, false, context),
          getLiveCards(crs, true, context),
        ]),
        initialData: [
          <Widget>[Container(
            height: 200,
            alignment: Alignment.center,
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
            ),
          )],
          <Widget>[Container(
            height: 200,
            alignment: Alignment.center,
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
            ),
          )],
        ],
        builder: (BuildContext context, AsyncSnapshot<List<List<Widget>>> liveCards) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            arrivals = tabController.index == 1;
            refreshCards();
          });
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
              bottom: const TabBar(
                tabs: [
                  Tab(text: "Departures"),
                  Tab(text: "Arrivals"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: liveCards.data?[0] ?? const <Widget>[Text("Failed to load services...")],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: liveCards.data?[1] ?? const <Widget>[Text("Failed to load services...")],
                  ),
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
      )
    );
  }
}