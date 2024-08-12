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

Widget getStationWidget(Station station, bool last, Function() callback, BuildContext context, {Disruption? disruption, bool isHome = false}) {
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
              (disruption?.severity == "Normal") ? Icons.info_outline : Icons.warning_sharp,
              size: (disruption == null) ? 0 : null,
              color: getDisruptionColour(disruption, context),
            ),
            Padding(
              padding: EdgeInsets.only(left: (isHome) ? 5.0 : 0.0),
              child: Icon(
                Icons.home,
                size: (isHome) ? null : 0,
              ),
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
    // widgets.add(getStationWidget(home, stations.length == 1, setStateCallback, context, disruption: (disruptions?[home.crs]?.lastOrNull), isHome: true));
    Disruption? worst;
    for (Disruption dis in (disruptions?[home.crs] ?? [])) {
      // I am aware this is horrible but I don't want to refactor the class right now
      // TODO: Refactor Disruption.dart, using an enumeration for the severity
      if (worst == null || dis.severity == "Severe" || dis.severity == "Major" || (dis.severity == "Minor" && worst.severity == "Normal")) {
        worst = dis;
      }
    }

    widgets.add(getStationWidget(home, stations.length == 1, setStateCallback, context, disruption: worst, isHome: true));
  }

  for (int i = 0; i < stations.length; i++) {
    if (stations[i] != home && stations[i] != null) {
      // widgets.add(getStationWidget(stations[i]!, i == (stations.length - ((home == null) ? 1 : 2)), setStateCallback, context, disruption: (disruptions?[stations[i]?.crs!]?.lastOrNull)));
      Disruption? worst;
      for (Disruption dis in (disruptions?[stations[i]?.crs!] ?? [])) {
        if (worst == null || dis.severity == "Severe" || dis.severity == "Major" || (dis.severity == "Minor" && worst.severity == "Normal")) {
          worst = dis;
        }
      }

      widgets.add(getStationWidget(stations[i]!, i == (stations.length - ((home == null) ? 1 : 2)), setStateCallback, context, disruption: worst));
    }
  }

  return widgets;
}

Future<List<Widget>> getSavedStationsDisruptions(Station? home, List<Station?> stations, Function() setStateCallback, BuildContext context) async {
  List<String> crsList = [];
  if (home != null) { crsList.add(home.crs!); }
  for (Station? station in stations) { if (station != null) { crsList.add(station.crs!); }}

  late Map<String, List<Disruption>>? disruptions;

  if (crsList.isNotEmpty) { disruptions = await getStationDisruptions(crsList, ScaffoldMessenger.of(context)); }
  else { disruptions = null; }

  return getSavedStationsWidgets(home, stations, setStateCallback, context, disruptions: disruptions);
}

void updateRecentSearches(Station newStation) async {
  List<Station> oldSearches = [];

  for (int i = 0; i < recentSearchesBox.length && i <= 24; i++) {
    if (recentSearchesBox.getAt(i) == null) { continue; }

    oldSearches.add(recentSearchesBox.getAt(i)!);
  }

  final temp = oldSearches.toList();

  if (oldSearches.isNotEmpty && oldSearches[0].crs == newStation.crs) { return; }
  for (Station oldStation in temp) {
    if (oldStation.crs == newStation.crs) {
      oldSearches.remove(oldStation);
    }
  }

  oldSearches.insert(0, newStation);
  await recentSearchesBox.clear();
  await recentSearchesBox.addAll(oldSearches);
}

Color getDisruptionColour(Disruption? disruption, BuildContext context) {
  if (disruption == null) { return Theme.of(context).colorScheme.inverseSurface; }
  switch (disruption.severity) {
    case "Minor":
      return delayedColour;
    case "Major":
    case "Severe":
      return cancelledColour;
    case "Normal":
    default:
      return Theme.of(context).colorScheme.inverseSurface;
  }
}

String getDisruptionPrefix(Disruption? disruption, BuildContext context) {
  if (disruption == null) { return "Info about"; }
  switch (disruption.severity) {
    case "Minor":
      return "Minor disruption to";
    case "Major":
      return "Major disruption to";
    case "Severe":
      return "Severe disruption to";
    case "Normal":
    default:
      return "Info about";
  }
}

Future<List<Widget>> getDisruptionWidget(String? crs, Function() setStateCallback, BuildContext context) async {
  if (crs == null) { return []; }

  Map<String, List<Disruption>>? disruptions = await getStationDisruptions([crs], ScaffoldMessenger.of(context));

  if (disruptions != null && (disruptions[crs]?.isNotEmpty ?? false)) {
    List<Widget> cards = [];

    for (Disruption disruption in disruptions[crs]!) {
      Color disruptionColour = getDisruptionColour(disruption, context);
      String disruptionText = "${getDisruptionPrefix(disruption, context)} ${disruption.category}:";

      cards.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children:[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  (disruption.severity == "Normal") ? Icons.info_outline : Icons.warning_sharp,
                  color: disruptionColour,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disruptionText,
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