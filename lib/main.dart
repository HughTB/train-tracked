import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workmanager/workmanager.dart';

// Import classes for hive boxes
import 'classes/service.dart';
import 'classes/station.dart';
import 'classes/stopping_point.dart';

// Import pages from other files
import 'pages/home.dart';
import 'pages/arr_dep_search.dart';
import 'pages/settings.dart';

// Import other helper functions
import 'helpers/notifications.dart';

// Import background services
import 'services/background.dart';

// Current LiveDeparturesPage search term
String? stationSearchTerm;

// Statically defined colours
const Color onTimeColour = Colors.lightGreen;
const Color delayedColour = Colors.orange;
const Color cancelledColour = Colors.red;

// Hive boxes
late Box preferencesBox; // Preferences storage
late Box<Station> recentSearchesBox; // Recent searches storage
late Box<Station?> savedStationsBox; // Saved stations storage
late Box<Service?> savedServicesBox;

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

// Update interval in minutes
const updateInterval = 3;

late GlobalKey<NavigatorState> navigatorKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(StationAdapter());
  Hive.registerAdapter(StoppingPointAdapter());
  Hive.registerAdapter(ServiceAdapter());

  // Get hive boxes
  preferencesBox = await Hive.openBox('preferences');
  recentSearchesBox = await Hive.openBox<Station>('recentSearches');
  savedStationsBox = await Hive.openBox<Station?>('savedStations');
  savedServicesBox = await Hive.openBox<Service?>('savedServices');

  // Ensure that all settings are set to default if not found (should only be needed on first load, but better safe than sorry!)
  preferencesBox.put("railReplacementCancellation", preferencesBox.get("railReplacementCancellation") ?? false); // If value does not exist, set to false, etc
  preferencesBox.put("platformChangeNotif", preferencesBox.get("platformChangeNotif") ?? false);
  preferencesBox.put("delayNotif", preferencesBox.get("delayNotif") ?? false);
  preferencesBox.put("cancellationNotif", preferencesBox.get("cancellationNotif") ?? false);
  preferencesBox.put("themeMode", preferencesBox.get("themeMode") ?? 0);

  initNotifications();
  await getNotificationsPermission();

  // Only run the background service if the platform is android
  if (Platform.isAndroid) {
    // Slightly hacky workaround, but the minimum time for a periodic task is 15 minutes, so multiple are needed, starting with an offset
    Workmanager().initialize(callbackDispatcher);

    for (int i = 0; i < (15 / updateInterval); i++) {
      Workmanager().registerPeriodicTask(
          "tt_service_checker_$i",
          "service_check",
          frequency: const Duration(minutes: 15),
          existingWorkPolicy: ExistingWorkPolicy.replace,
          initialDelay: Duration(minutes: i * (15 ~/ updateInterval))
      );
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeMode = (preferencesBox.get("themeMode") == 0) ? ThemeMode.system : (preferencesBox.get("themeMode") == 1) ? ThemeMode.light : ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    // Lock the app to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Set the navigator key for later use
    navigatorKey = GlobalKey<NavigatorState>();

    // Actually build the app
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
        "/live-trains": (context) => const ArrDepSearchPage(title: 'Live Trains'),
        "/settings": (context) => const SettingsPage(title: 'Settings'),
      },
      initialRoute: '/',
      navigatorKey: navigatorKey,
    );
  }
}