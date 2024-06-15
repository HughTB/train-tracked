import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:train_tracked/api/api.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../classes/disruption.dart';
import '../main.dart';
import '../pages/arr_dep.dart';
import '../classes/station.dart';

List<Widget> updateStationsSearch(List<Station> stations, String? searchTerm, Function() setStateCallback, BuildContext context, Color textColour) {
  List<Widget> results = [];

  searchTerm = searchTerm?.toLowerCase();

  List<Station> foundStations = [];

  if (searchTerm == null || searchTerm.isEmpty) {
    for (int i = 0; i < recentSearchesBox.length && i <= 25; i++) {
      if (recentSearchesBox.getAt(i) == null) { continue; }

      foundStations.add(recentSearchesBox.getAt(i)!);
    }
  } else {
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

Widget getStationWidget(Station station, bool last, Function() callback, BuildContext context, {bool hasDisruption = false}) {
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
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${station.stationName} (${station.crs})",
                style: Theme.of(context).textTheme.bodyLarge,
              )
            ),
            Icon(
              Icons.warning_sharp,
              size: (hasDisruption) ? null : 0,
              color: delayedColour,
            ),
            const Icon(
              Icons.arrow_right_sharp,
            )
          ],
        )
      ),
    ),
    onTap: () {
      updateRecentSearches(station);

      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ArrDepPage(title: station.stationName!, crs: station.crs!)
      )).then((_) => callback());
    },
  );
}

List<Widget> getSavedStationsWidgets(Station? home, List<Station?> stations, Function() setStateCallback, BuildContext context, {Map<String, List<Disruption>>? disruptions}) {
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
    widgets.add(getStationWidget(home, stations.length == 1, setStateCallback, context, hasDisruption: (disruptions?[home.crs]?.isNotEmpty) ?? false));
  }

  for (int i = 0; i < stations.length; i++) {
    if (stations[i] != home && stations[i] != null) {
      widgets.add(getStationWidget(stations[i]!, i == (stations.length - ((home == null) ? 1 : 2)), setStateCallback, context, hasDisruption: (disruptions?[stations[i]?.crs!]?.isNotEmpty) ?? false));
    }
  }

  return widgets;
}

Future<List<Widget>> getSavedStationsDisruptions(Station? home, List<Station?> stations, Function() setStateCallback, BuildContext context) async {
  List<String> crsList = [];
  if (home != null) { crsList.add(home.crs!); }
  for (Station? station in stations) { if (station != null) { crsList.add(station.crs!); }}

  Map<String, List<Disruption>>? disruptions = await getDisruptions(crsList, ScaffoldMessenger.of(context));

  return getSavedStationsWidgets(home, stations, setStateCallback, context, disruptions: disruptions);
}

void updateRecentSearches(Station newStation) async {
  List<Station> oldSearches = [];

  for (int i = 0; i < recentSearchesBox.length && i <= 24; i++) {
    if (recentSearchesBox.getAt(i) == null) { continue; }

    oldSearches.add(recentSearchesBox.getAt(i)!);
  }

  if (oldSearches.isNotEmpty && oldSearches[0] == newStation) { return; }
  if (oldSearches.contains(newStation)) {
    oldSearches.remove(newStation);
  }

  oldSearches.insert(0, newStation);
  await recentSearchesBox.clear();
  await recentSearchesBox.addAll(oldSearches);
}

Future<List<Widget>> getDisruptionWidget(String? crs, Function() setStateCallback, BuildContext context) async {
  if (crs == null) { return []; }

  Map<String, List<Disruption>>? disruptions = await getDisruptions([crs], ScaffoldMessenger.of(context));

  if (disruptions != null && (disruptions[crs]?.isNotEmpty ?? false)) {
    List<Widget> cards = [];

    for (Disruption disruption in disruptions[crs]!) {
      Color disruptionColour = Theme.of(context).colorScheme.inverseSurface;
      String disruptionTitle = "";

      switch (disruption.severity) {
        case "Minor":
          disruptionColour = delayedColour;
          disruptionTitle = "Minor disruption to";
          break;
        case "Major":
          disruptionTitle = "Major disruption to";
        case "Severe":
          disruptionColour = cancelledColour;
          disruptionTitle = "Severe disruption to";
          break;
        case "Normal":
        default:
          disruptionColour = Theme.of(context).colorScheme.inverseSurface;
          disruptionTitle = "Info about";
          break;
      }

      disruptionTitle += " ${disruption.category}:";

      cards.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children:[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.warning_sharp,
                  color: disruptionColour,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disruptionTitle,
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
                        color: disruptionColour,
                      ),
                    ),
                    HtmlWidget(
                      disruption.message ?? "",
                      onTapUrl: (url) => launchUrlString(url),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }

    return cards;
  }

  return [];
}