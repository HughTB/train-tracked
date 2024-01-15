import 'package:flutter/material.dart';

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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                return DropdownMenu(
                  label: const Text('Home Station'),
                  dropdownMenuEntries: homeStationEntries,
                  width: constraints.maxWidth,
                  initialSelection: savedStationsBox.get("home")?.crs,
                  requestFocusOnTap: true,
                  enableFilter: true,
                  enableSearch: true,
                  menuHeight: 200,
                  onSelected: (dynamic value) {
                    setState(() {
                      savedStationsBox.put("home", getStationByCrs(stations, value));
                    });
                  },
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
            const Divider(),
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
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
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
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