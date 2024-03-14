import 'package:flutter/material.dart';

import '../main.dart';
import '../helpers/services_search.dart';
import '../helpers/stations_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getSavedServices(false, () { setState(() {}); }, context),
        getSavedServices(true, () { setState(() {}); }, context),
      ]),
      initialData: const [
        <Widget>[Text("Loading...")],
        <Widget>[Text("Loading...")],
      ],
      builder: (BuildContext context, AsyncSnapshot<List<List<Widget>>> futures) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Saved Stations',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ] + getSavedStationsWidgets(savedStationsBox.get("home"), savedStationsBox.values.toList(), () { setState(() {}); }, context) + [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Saved Services',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ] + ((futures.data?[0] == null) ? [] : futures.data![0]) + [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Old Services',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ] + ((futures.data?[1] == null) ? [] : futures.data![1]),
              ),
            ),
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
    );
  }
}