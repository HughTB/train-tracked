import 'package:flutter/material.dart';

import 'main.dart';
import 'stations.dart';

List<Widget> updateStationsSearch(List<Station> stations, String? searchTerm, BuildContext context, Color textColour) {
  List<Widget> tiles = [];

  if (searchTerm == null || searchTerm == '') {
    return [];
  }

  searchTerm = searchTerm.toLowerCase();

  for (Station station in stations) {
    if (station.stationName!.toLowerCase().contains(searchTerm)) {
      tiles.add(ListTile(
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
          onPressed: () {},
        ),
      ));
    }
  }

  return tiles;
}