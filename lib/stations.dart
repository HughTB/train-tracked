import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Station {
  String? stationName;
  double? lat;
  double? long;
  String? crs;

  Station(this.stationName, this.lat, this.long, this.crs);
}

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