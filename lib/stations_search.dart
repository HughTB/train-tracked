import 'package:train_tracked/stations.dart';

import 'package:flutter/material.dart';

List<ListTile> updateStationsSearch(List<Station> stations, String? searchTerm) {
  List<ListTile> tiles = [];

  if (searchTerm == null || searchTerm == '') {
    return [];
  }

  searchTerm = searchTerm.toLowerCase();

  for (Station station in stations) {
    if (station.stationName!.toLowerCase().contains(searchTerm)) {
      tiles.add(ListTile(
        title: Text(
          "${station.stationName} (${station.crs})",
        ),
      ));
    }
  }

  return tiles;
}