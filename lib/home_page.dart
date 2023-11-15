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
            children: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Warning: This app does not use live data! It is currently using a snapshot of data from 16/11/2023',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Saved Stations',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ] + getSavedStationsWidgets(savedStations['home'], savedStations.values.toList(), context) + [
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