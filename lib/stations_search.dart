import 'package:flutter/material.dart';

import 'main.dart';
import 'live_departures_page.dart';
import 'station.dart';

List<Widget> updateStationsSearch(List<Station> stations, String? searchTerm, BuildContext context, Color textColour) {
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
    results.add(getStationWidget(foundStations[i], i == (foundStations.length - 1), context));
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

Widget getStationWidget(Station station, bool last, BuildContext context) {
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
        ),
      ),
    ),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => LiveDeparturesPage(
          title: station.stationName!,
          crs: station.crs!,
        ),
      ));
    },
  );
}

List<Widget> getSavedStationsWidgets(Station? home, List<Station?> stations, BuildContext context) {
  List<Widget> widgets = [];

  if (home != null) {
    widgets.add(getStationWidget(home, stations.length == 1, context));
  }

  for (int i = 0; i < stations.length; i++) {
    if (stations[i] != home && stations[i] != null) {
      widgets.add(getStationWidget(stations[i]!, i == (stations.length - 2), context));
    }
  }

  return widgets;
}