import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stations.dart';

// Import pages from other files
import 'home_page.dart';
import 'live_trains_page.dart';
import 'settings_page.dart';

late final SharedPreferences preferences;
// Settings toggle variables
bool prefPlatformNotif = false;
bool prefDelayNotif = false;
bool prefCancellationNotif = false;
int prefThemeMode = 0;
String? prefHomeStation;
String? stationSearchTerm;

late final List<Station> stations;
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
  prefPlatformNotif = preferences.getBool('notif-platform-change') ?? false;
  prefDelayNotif = preferences.getBool('notif-train-delay') ?? false;
  prefCancellationNotif = preferences.getBool('notif-train-cancel') ?? false;
  prefThemeMode = preferences.getInt('pref-theme-mode') ?? 0;
  prefHomeStation = preferences.getString('pref-home-station');

  stations = await getStationList();
  homeStationEntries = getStationsDropdownList(stations);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeMode = (prefThemeMode == 0) ? ThemeMode.system : (prefThemeMode == 1) ? ThemeMode.light : ThemeMode.dark;

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