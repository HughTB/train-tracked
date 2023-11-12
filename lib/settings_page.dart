import 'package:flutter/material.dart';

import 'main.dart';

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
                  initialSelection: prefThemeMode,
                  onSelected: (dynamic value) {
                    setState(() {
                      prefThemeMode = value;
                      preferences.setInt('pref-theme-mode', value);
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
                  initialSelection: prefHomeStation,
                  onSelected: (dynamic value) {
                    setState(() {
                      prefHomeStation = value;
                      preferences.setString('pref-home-station', value);
                    });
                  },
                );
              },
            ),
            const Divider(),
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SwitchListTile(
                title: const Text('Platform Change'),
                subtitle: const Text('Send a notification if a saved train changes platform'),
                value: prefPlatformNotif,
                onChanged: (bool value) {
                  setState(() {
                    prefPlatformNotif = value;
                    preferences.setBool('notif-platform-change', value);
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Delay'),
                subtitle: const Text('Send a notification if a saved train is delayed by more than 5 minutes'),
                value: prefDelayNotif,
                onChanged: (bool value) {
                  setState(() {
                    prefDelayNotif = value;
                    preferences.setBool('notif-train-delay', value);
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Cancellation'),
                subtitle: const Text('Send a notification if a saved train is cancelled'),
                value: prefCancellationNotif,
                onChanged: (bool value) {
                  setState(() {
                    prefCancellationNotif = value;
                    preferences.setBool('notif-train-cancel', value);
                  });
                }
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
              Navigator.pushReplacementNamed(context, getNavRoute(index));
            }
          }
      ),
    );
  }
}