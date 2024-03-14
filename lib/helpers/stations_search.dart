import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/arr_dep.dart';
import '../classes/station.dart';

List<Widget> updateStationsSearch(List<Station> stations, String? searchTerm, Function() setStateCallback, BuildContext context, Color textColour) {
  List<Widget> results = [];

  if (searchTerm == null || searchTerm == '') {
    return [];
  }

  searchTerm = searchTerm.toLowerCase();

  List<Station> foundStations = [];
  List<Station> tempStations = stations.toList();

  if (searchTerm.length <= 3) {
    for (Station station in stations) {
      if (foundStations.length > 25) break;

      if (station.crs!.toLowerCase().contains(searchTerm)) {
        foundStations.add(station);
        tempStations.remove(station);
      }
    }
  }

  for (Station station in tempStations) {
    if (foundStations.length > 25) break;

    if (station.stationName!.toLowerCase().contains(searchTerm)) {
      foundStations.add(station);
    }
  }

  for (int i = 0; i < foundStations.length; i++) {
    results.add(getStationWidget(foundStations[i], i == (foundStations.length - 1), setStateCallback, context));
  }

  return results;
}

Station? getStationByCrs(List<Station> stations, String? crs) {
  if (crs == null) {
    return null;
  }

  for (Station station in stations) {
    if (station.crs == crs.toUpperCase()) return station;
  }

  return null;
}

Widget getStationWidget(Station station, bool last, Function() callback, BuildContext context) {
  return InkWell(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).dividerColor.withAlpha((last) ? 0 : 50),
              width: 1.0
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "${station.stationName} (${station.crs})",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
    onTap: () {
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ArrDepPage(title: station.stationName!, crs: station.crs!)
      )).then((_) => callback());
    },
  );
}

List<Widget> getSavedStationsWidgets(Station? home, List<Station?> stations, Function() setStateCallback, BuildContext context) {
  List<Widget> widgets = [];

  if (home == null) {
    widgets.add(DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: Theme.of(context).dividerColor.withAlpha((stations.isEmpty) ? 0 : 50),
                width: 1.0
            ),
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "You haven't set a home station yet! You can do this on the settings page.\nIt will always show up at the top of this list for easy access",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      )
    ));
  } else {
    widgets.add(getStationWidget(home, stations.length == 1, setStateCallback, context));
  }

  for (int i = 0; i < stations.length; i++) {
    if (stations[i] != home && stations[i] != null) {
      widgets.add(getStationWidget(stations[i]!, i == (stations.length - ((home == null) ? 1 : 2)), setStateCallback, context));
    }
  }

  return widgets;
}