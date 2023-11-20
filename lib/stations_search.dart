import 'package:flutter/material.dart';

import 'main.dart';
import 'live_departures_page.dart';
import 'stations.dart';

List<Widget> updateStationsSearch(List<Station> stations, String? searchTerm, BuildContext context, Color textColour) {
  List<Widget> results = [];

  if (searchTerm == null || searchTerm == '') {
    return [];
  }

  searchTerm = searchTerm.toLowerCase();
  int foundStations = 0;

  List<Station> tempStations = stations.toList();

  if (searchTerm.length <= 3) {
    for (Station station in stations) {
      if (foundStations > 25) break;

      if (station.crs!.toLowerCase().contains(searchTerm)) {
        foundStations++;

        results.add(getStationWidget(station, context));

        tempStations.remove(station);
      }
    }
  }

  for (Station station in tempStations) {
    if (foundStations > 25) break;

    if (station.stationName!.toLowerCase().contains(searchTerm)) {
      foundStations++;

      results.add(getStationWidget(station, context));
    }
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

Widget getStationWidget(Station station, BuildContext context) {
  return ListTile(
    title: TextButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${station.stationName} (${station.crs})",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => LiveDeparturesPage(
            title: station.stationName!,
            crs: station.crs!,
          ),
        ));
      },
    ),
  );
}

List<Widget> getSavedStationsWidgets(Station? home, List<Station?> stations, BuildContext context) {
  List<Widget> widgets = [];

  if (home != null) {
    widgets.add(getStationWidget(home, context));
  }

  for (Station? station in stations) {
    if (station != home && station != null) {
      widgets.add(getStationWidget(station, context));
    }
  }

  return widgets;
}