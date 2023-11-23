import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'live_departures_page.dart';
import 'station.dart';

Future<List<Station>> getStationList() async {
  var stationsFile = await rootBundle.loadString("assets/stations.csv");
  List<List<dynamic>> csv = const CsvToListConverter().convert(stationsFile, eol: '\n');

  List<Station> stations = [];

  for (int i = 1; i < csv.length; i++) {
    if (csv[i][3] is! String) continue;

    stations.add(Station(
        csv[i][0],
        csv[i][1],
        csv[i][2],
        csv[i][3]
    ));
  }

  return stations;
}

List<DropdownMenuEntry> getStationsDropdownList(List<Station> stations) {
  List<DropdownMenuEntry> dropdownEntries = [];

  for (Station station in stations) {
    final value = station.crs;
    final label = "${station.stationName} (${station.crs})";

    dropdownEntries.add(
        DropdownMenuEntry(
          value: value,
          label: label,
        )
    );
  }

  return dropdownEntries;
}

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