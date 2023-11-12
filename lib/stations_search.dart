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

        results.add(_getStationWidget(station, context, textColour));

        tempStations.remove(station);
      }
    }
  }

  for (Station station in tempStations) {
    if (foundStations > 25) break;

    if (station.stationName!.toLowerCase().contains(searchTerm)) {
      foundStations++;

      results.add(_getStationWidget(station, context, textColour));
    }
  }

  return results;
}

Widget _getStationWidget(Station station, BuildContext context, Color textColour) {
  return ListTile(
    title: TextButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${station.stationName} (${station.crs})",
          style: TextStyle(
            color: textColour,
            fontSize: 18.0,
          ),
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