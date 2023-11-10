import 'stations.dart';
import 'stations_search.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences preferences;
// Settings toggle variables
bool _platformNotif = false;
bool _delayNotif = false;
bool _cancellationNotif = false;
int _themeMode = 0;
String? _homeStation;
String? _stationSearchTerm;

late final List<Station> _stations;
late final List<DropdownMenuEntry> homeStationEntries;

const List<DropdownMenuEntry> themeModeEntries = <DropdownMenuEntry>[
  DropdownMenuEntry(value: 0, label: 'Follow System Theme'),
  DropdownMenuEntry(value: 1, label: 'Light Mode'),
  DropdownMenuEntry(value: 2, label: 'Dark Mode'),
];

// Nav bar items to show at the bottom of all screens
const List<NavigationDestination> navBarItems = <NavigationDestination>[
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.train_outlined),
    selectedIcon: Icon(Icons.train),
    label: 'Live Trains',
  ),
  NavigationDestination(
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    label: 'Settings',
  ),
];

// The currently selected screen
int currentNavIndex = 0;
// Get the route to navigate to, given an index
String getNavRoute(int index) {
  currentNavIndex = index; // Set the selected screen

  switch(index) {
    case 0:
      return '/';
    case 1:
      return '/live-trains';
    case 2:
      return '/settings';
    default:
      return '/';
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  _platformNotif = preferences.getBool('notif-platform-change') ?? false;
  _delayNotif = preferences.getBool('notif-train-delay') ?? false;
  _cancellationNotif = preferences.getBool('notif-train-cancel') ?? false;
  _themeMode = preferences.getInt('pref-theme-mode') ?? 0;
  _homeStation = preferences.getString('pref-home-station');

  _stations = await getStationList();
  homeStationEntries = getStationsDropdownList(_stations);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeMode = (_themeMode == 0) ? ThemeMode.system : (_themeMode == 1) ? ThemeMode.light : ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Tracked',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8635E3), brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8635E3), brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeMode, // Follow system theme
      home: const HomePage(title: 'Home'),
      routes: <String, WidgetBuilder>{
        "/live-trains": (context) => const LiveTrainsPage(title: 'Live Trains'),
        "/settings": (context) => const SettingsPage(title: 'Settings'),
      },
    );
  }
}

// Home page
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home Page',
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

// Live Trains page
class LiveTrainsPage extends StatefulWidget {
  const LiveTrainsPage({super.key, required this.title});

  final String title;

  @override
  State<LiveTrainsPage> createState() => _LiveTrainsPageState();
}

class _LiveTrainsPageState extends State<LiveTrainsPage> {
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
            SearchBar(
              padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
              leading: const Icon(Icons.search),
              onChanged: (String? value) {
                setState(() {
                  _stationSearchTerm = value;
                });
              },
            ),
            Column(
              children: updateStationsSearch(_stations, _stationSearchTerm),
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

// Settings page
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
                  initialSelection: _themeMode,
                  onSelected: (dynamic value) {
                    setState(() {
                      _themeMode = value;
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
                  initialSelection: _homeStation,
                  onSelected: (dynamic value) {
                    setState(() {
                      _homeStation = value;
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
              value: _platformNotif,
              onChanged: (bool value) {
                setState(() {
                  _platformNotif = value;
                  preferences.setBool('notif-platform-change', value);
                });
              }
            ),
            SwitchListTile(
                title: const Text('Train Delay'),
                subtitle: const Text('Send a notification if a saved train is delayed by more than 5 minutes'),
                value: _delayNotif,
                onChanged: (bool value) {
                  setState(() {
                    _delayNotif = value;
                    preferences.setBool('notif-train-delay', value);
                  });
                }
            ),
            SwitchListTile(
                title: const Text('Train Cancellation'),
                subtitle: const Text('Send a notification if a saved train is cancelled'),
                value: _cancellationNotif,
                onChanged: (bool value) {
                  setState(() {
                    _cancellationNotif = value;
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