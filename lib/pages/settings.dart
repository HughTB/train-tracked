import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../main.dart';
import '../helpers/stations_search.dart';
import '../classes/station_list.g.dart';

const List<DropdownMenuEntry> themeModeEntries = <DropdownMenuEntry>[
  DropdownMenuEntry(value: 0, label: 'Follow System Theme'),
  DropdownMenuEntry(value: 1, label: 'Light Mode'),
  DropdownMenuEntry(value: 2, label: 'Dark Mode'),
];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'General',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DropdownMenu(
                  label: const Text('App Theme'),
                  dropdownMenuEntries: themeModeEntries,
                  width: constraints.maxWidth,
                  initialSelection: preferencesBox.get("themeMode"),
                  onSelected: (dynamic value) {
                    setState(() {
                      preferencesBox.put("themeMode", value);
                    });
                  },
                );
              },
            ),
            const Text('(Applied on app restart)'),
            Divider(color: Theme.of(context).canvasColor),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return DropdownSearch<String>(
                  items: homeStationEntries,
                  popupProps: const PopupProps.dialog(
                    showSelectedItems: true,
                    // constraints: BoxConstraints(maxHeight: 400),
                    searchDelay: Duration(seconds: 0),
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(autofocus: true),
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      label: Text('Home Station'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  selectedItem: savedStationsBox.get("home") == null ? null : "${savedStationsBox.get("home")?.stationName} (${savedStationsBox.get("home")?.crs})",
                  onChanged: (String? value) {
                    setState(() {
                      String? crs = value?.substring(value.length - 4, value.length - 1);
                      savedStationsBox.put("home", getStationByCrs(stations, crs));
                      if (savedStationsBox.containsKey(crs)) {
                        savedStationsBox.delete(crs);
                      }
                    });
                  },
                  filterFn: (item, search) { return (item.toLowerCase().contains(search.toLowerCase()) || item.toLowerCase().replaceAll("&", "and").contains(search.toLowerCase())); },
                );
              },
            ),
            SwitchListTile(
                title: const Text('Show Rail Replacement as Cancellation'),
                subtitle: const Text('Show Rail Replacement Busses as a cancellation rather than delay'),
                value: preferencesBox.get("railReplacementCancellation"),
                onChanged: (bool value) {
                  setState(() {
                    preferencesBox.put("railReplacementCancellation", value);
                  });
                }
            ),
            const Divider(thickness: 0.5),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SwitchListTile(
                title: const Text('Platform Change'),
                subtitle: const Text('Send a notification if a saved train changes platform'),
                value: preferencesBox.get("platformChangeNotif"),
                onChanged: (bool value) {
                  setState(() {
                    preferencesBox.put("platformChangeNotif", value);
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Delay'),
                subtitle: const Text('Send a notification if a saved train is delayed by more than 5 minutes'),
                value: preferencesBox.get("delayNotif"),
                onChanged: (bool value) {
                  setState(() {
                    preferencesBox.put("delayNotif", value);
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Cancellation'),
                subtitle: const Text('Send a notification if a saved train is cancelled'),
                value: preferencesBox.get("cancellationNotif"),
                onChanged: (bool value) {
                  setState(() {
                    preferencesBox.put("cancellationNotif", value);
                  });
                }
            ),
            const Divider(thickness: 0.5),
            Text(
              'Information',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "App Version: ${packageInfo.version}\n"
                  "Build Number: ${(packageInfo.buildNumber == "") ? "unknown" : packageInfo.buildNumber}\n"
                  "Bundle Name: ${packageInfo.packageName}\n"
                  "Installed From: ${packageInfo.installerStore}",
            ),
            HtmlWidget(
              "Any bugs or issues? Send an email to <a href=\"mailto:bug-hunt@train-tracked.com\">bug-hunt@train-tracked.com</a>",
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "© Hugh Baldwin, ${DateTime.now().year}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Image.asset(
                (Theme.of(context).brightness == Brightness.dark) ? "assets/powered_by_nre_white.png" : "assets/powered_by_nre_black.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
          destinations: navBarItems,
          selectedIndex: currentNavIndex,
          onDestinationSelected: (int index) {
            if (index != currentNavIndex) {
              navigatorKey.currentState?.popUntil((route) => route.isFirst);
              navigatorKey.currentState?.pushReplacementNamed(getNavRoute(index));
            }
          }
      ),
    );
  }
}